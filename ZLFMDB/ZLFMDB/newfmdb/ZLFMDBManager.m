//
//  ZLFMDBManager.m
//  ZLFMDB
//
//  Created by Abe on 2018/12/14.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import "ZLFMDBManager.h"
#import "NSObject+DBExtension.h"
#import "NSDictionary+jsonExtension.h"
#import "NSArray+jsonExtension.h"
#import "NSArray+SwiftExtension.h"
#import "DefaultDatabaseQueue.h"
#import "YYModel.h"

@interface ZLFMDBManager()
// 所有的dbobj包括mapping自己增加的 和 属性映射的
@property(strong, nonatomic) FMDatabase *db;
@property(strong, nonatomic) NSMutableArray<DbObj *> *allDbObjs;
@end

// load时候将version 写入 userdefault   方便数据库升级

@implementation ZLFMDBManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 建表
        NSArray<DbObj *> *dbObjs = [[self dataCls] cls_propertyList];
        NSMutableArray *allDbObjs = [NSMutableArray arrayWithArray:dbObjs];
        for(DbObj *dbobj in allDbObjs) {
            [self setDBPropertynameWithDBObj:dbobj];
        }
        self.allDbObjs = allDbObjs;
        [self addConfig];
    }
    return self;
}

- (void)addConfig {
    __weak typeof(&*self) weakself = self;
    self.CUSMODIFY = ^ZLFMDBManager *(NSString *property, NSString *cusText) {
        __block DbObj *modifyObj;
        [weakself.allDbObjs enumerateObjectsUsingBlock:^(DbObj * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj.propertyName isEqualToString:property]) {
                modifyObj = obj;
                *stop = YES;
            }
        }];
        if(modifyObj) {
            modifyObj.dbAddStr = cusText;
        }
        return weakself;
    };
}

// 建表
- (void)createTableIfNeeded {
    if([self.db open]) {
        NSMutableArray *allDbObjs = self.allDbObjs;
        if(allDbObjs.count == 0) {
            return;
        }
        if([self.db tableExists:self.tabName]) {
            NSMutableArray *newAddColumn = [NSMutableArray array];
            for(DbObj *dbobj in allDbObjs) {
                if(! [self.db columnExists:dbobj.dbPropertyName inTableWithName:self.tabName] ) {
                    [newAddColumn addObject:dbobj];
                }
            }
            if(newAddColumn.count > 0) {
                [self.dbqueue inDatabase:^(FMDatabase * _Nonnull db) {
                    [db beginTransaction];
                    for(DbObj *dbobj in newAddColumn) {
                        NSString *str;
                        str = [NSString stringWithFormat:@"%@ %@",dbobj.dbPropertyName, dbobj.dbPropertyStr];
                        if(dbobj.dbAddStr.length) {
                            str = [NSString stringWithFormat:@"%@ %@", str, dbobj.dbAddStr];
                        }
                        
                        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@",self.tabName, str];
                        [db executeUpdate:alertStr];
                    }
                    [db commit];
                }];
            }
        }else {
            // 建表
            NSString *keyStr;
            if(allDbObjs.count > 0) {
                NSMutableString *mstr = [[NSMutableString alloc] initWithString:@""];
                for(DbObj *dbobj in allDbObjs) {
                    if(dbobj.isPrimaryKey) {
                        [mstr appendFormat:@"%@ %@ primary key ", dbobj.dbPropertyName, dbobj.dbPropertyStr];
                        
                    }else {
                        [mstr appendFormat:@"%@ %@ ", dbobj.dbPropertyName, dbobj.dbPropertyStr];
                    }
                    if(dbobj.dbAddStr.length) {
                        [mstr appendString:dbobj.dbAddStr];
                    }
                    
                    [mstr appendString:@","];
                }
                
                mstr = [[mstr substringToIndex:mstr.length - 1] mutableCopy];
                keyStr = [mstr copy];
            }
            NSString *creatStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@)",self.tabName, keyStr];
            [self.dbqueue inDatabase:^(FMDatabase * _Nonnull db) {
                [db executeUpdate:creatStr];
            }];
        }
    }
}

//  取出数据时候  自行将resultSet 转化为 所需对象  连表查询暂时不考虑
- (NSArray *)changeSetToObjWithSet:(FMResultSet *)resultSet {
    NSMutableArray *mary = [NSMutableArray array];
    while(resultSet.next) {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        for(DbObj *dbObj in self.allDbObjs) {
            id obj = [resultSet objectForColumn:dbObj.dbPropertyName];
            if(obj && dbObj.propertyName) {
                if(dbObj.isAry && [obj isKindOfClass:[NSString class]]) {
                    if(((NSString *)obj).length > 0) {
                        obj = [NSArray arrayWithJsonString:(NSString *)obj];
                    }
                }else if(dbObj.isDic && [obj isKindOfClass:[NSString class]]) {
                    if(((NSString *)obj).length > 0) {
                        obj = [NSDictionary dictionaryWithJsonString:(NSString *)obj];
                    }
                }else if(dbObj.isTime && [obj isKindOfClass:[NSNumber class]]) {
                    obj = [NSDate dateWithTimeIntervalSince1970:[obj doubleValue]];
                }
                if(obj) {
                    [mdic setObject:obj forKey:dbObj.propertyName];
                }
            }
        }
        [mary addObject:mdic];
    }
    [resultSet close];
    return [mary copy];
}

// 把 obj 转化为插入语句
- (BOOL)isExistWithSqlStr:(NSString *)sqlStr values:(NSArray *)values WithDB:(FMDatabase *)db {
    if(sqlStr.length == 0) {
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"select count(*) from %@ where (%@)", self.tabName, sqlStr];
    int count = 0;
    FMResultSet *set = [db executeQuery:sql values:values error:nil];;
    while(set.next) {
        count = [set intForColumnIndex:0];
    }
    [set close];
    return count > 0;
}

- (NSArray<NSDictionary *> *)allObjsInDB {
    NSString *sql = [NSString stringWithFormat:@"select * from %@", [self tabName]];
    __weak typeof(&*self) weakself = self;
    __block NSArray *ary;
    [self.dbqueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSet = [db executeQuery:sql];
        ary = [weakself changeSetToObjWithSet:resultSet];
    }];
    return ary;
}

// 存储数据
- (void)saveObj:(id)obj withDB:(FMDatabase *)db{
    NSArray<DbObj *> *dbPropertys = self.allDbObjs;
    if(dbPropertys.count) {
        NSArray *primaryKeyDBObjs = [dbPropertys filter:^BOOL(DbObj *obj) {
            return obj.isPrimaryKey;
        }];
        NSMutableString *mstr = [[NSMutableString alloc] initWithString:@""];
        NSMutableArray *mary = [NSMutableArray array];
        for(DbObj *dbObj in primaryKeyDBObjs) {
            id value = [obj valueForKey:dbObj.propertyName];
            id dbValue = [dbObj valueWithDbFormatterWithObj:value];
            if(dbValue != nil) {
                [mstr appendFormat:@"%@ = ?,", dbObj.dbPropertyName];
                [mary addObject:dbValue];
            }
        }
        if(mstr.length > 0) {
            [mstr deleteCharactersInRange:NSMakeRange(mstr.length - 1, 1)];
        }
        if([self isExistWithSqlStr:mstr values:[mary copy] WithDB:db]) {
            // save
            [self updateobj:obj withDB:db];
        }else {
            [self insertobj:obj withDB:db];
        }
    }
}

- (void)dropTable {
    NSString *sql = [NSString stringWithFormat:@"drop %@", self.tabName];
    [self.db executeUpdate:sql];
}

- (void)deleteObj:(id)obj withDB:(FMDatabase *)db {
    NSArray *primaryKeyDBObjs = [self.allDbObjs filter:^BOOL(DbObj *obj) {
        return obj.isPrimaryKey;
    }];
    NSMutableString *conditionStr = [[NSMutableString alloc] initWithString:@""];
    NSMutableArray *values = [NSMutableArray array];
    for(DbObj *dbobj in primaryKeyDBObjs) {
        id value = [obj valueForKey:dbobj.propertyName];
        id dbValue = [dbobj valueWithDbFormatterWithObj:value];
        if(dbValue) {
            [conditionStr appendFormat:@"%@ = ? and", dbobj.dbPropertyName];
            [values addObject:dbValue];
        }
    }
    if(conditionStr.length > 3) {
        [conditionStr deleteCharactersInRange:NSMakeRange(conditionStr.length - 3, 3)];
    }
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@", self.tabName, conditionStr];
    [db executeUpdate:sql values:values error:nil];
}


- (void)insertobj:(id)obj withDB:(FMDatabase *)db{
    if(![obj isKindOfClass:[self dataCls]]) {
        return;
    }
    NSMutableString *columnStr = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *valueStr = [[NSMutableString alloc] initWithString:@""];
    NSMutableArray *insertValues = [NSMutableArray array];
    for(DbObj *dbobj in self.allDbObjs) {
        id value = [obj valueForKey:dbobj.propertyName];
        id dbSetValue = [dbobj valueWithDbFormatterWithObj:value];
        if(dbSetValue != nil) {
            [columnStr appendFormat:@"%@,", dbobj.dbPropertyName];
            [valueStr appendFormat:@"?,"];
            [insertValues addObject:dbSetValue];
        }
    }
    if(columnStr.length > 0) {
        [columnStr deleteCharactersInRange:NSMakeRange(columnStr.length - 1, 1)];
    }
    if(valueStr.length > 0) {
        [valueStr deleteCharactersInRange:NSMakeRange(valueStr.length - 1, 1)];
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",self.tabName,columnStr,valueStr];
    [db executeUpdate:sql values:insertValues error:nil];
}

- (void)updateobj:(id)obj withDB:(FMDatabase *)db {
    if(![obj isKindOfClass:[self dataCls]]) {
        // 不是对象 不执行
        return;
    }
    NSMutableString *conditionMstr = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *setMstr = [[NSMutableString alloc] initWithString:@""];
    NSMutableArray *primaryValues = [NSMutableArray array];
    NSMutableArray *conditionValues = [NSMutableArray array];
    for(DbObj *dbobj in self.allDbObjs) {
        id value = [obj valueForKey:dbobj.propertyName];
        id dbvalue = [dbobj valueWithDbFormatterWithObj:value];
        if(dbvalue != nil) {
            if(dbobj.isPrimaryKey) {
                [conditionMstr appendFormat:@" %@ = ? and", dbobj.dbPropertyName];
                [primaryValues addObject:dbvalue];
            }else {
                [setMstr appendFormat:@"%@ = ? ,", dbobj.dbPropertyName];
                [conditionValues addObject:dbvalue];
            }
        }
    }
    if(setMstr.length) {
        if(conditionMstr.length > 3) {
            [conditionMstr deleteCharactersInRange:NSMakeRange(conditionMstr.length - 3, 3)];
        }
        if(setMstr.length > 1) {
            [setMstr deleteCharactersInRange:NSMakeRange(setMstr.length - 1, 1)];
        }
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ set %@ where %@",self.tabName, setMstr, conditionMstr];
        NSMutableArray *mary = [NSMutableArray arrayWithArray:conditionValues];
        [mary addObjectsFromArray:primaryValues];
        [db executeUpdate:sql values:[mary copy] error:nil];
    }
}

- (void)setDBPropertynameWithDBObj:(DbObj *)dbobj {
    dbobj.dbPropertyName = [NSString stringWithFormat:@"%@%@",[self property_preStr], dbobj.propertyName];
}

#pragma mark -lazy
- (Class)dataCls {
    NSAssert(false, @"must rewrite");
    return nil;
}
- (NSString *)dbName {
//    NSString *appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    return [NSString stringWithFormat:@"%@.db", @"default"];
}
- (FMDatabaseQueue *)dbqueue {
    return [DefaultDatabaseQueue shareInstance];
}

- (NSString *)tabName {
    NSAssert(false, @"must rewrite");
    return nil;
}

- (FMDatabase *)db {
    if(!_db) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *dbPath = [path stringByAppendingPathComponent:[self dbName]];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSLog(@"dbPath is : %@", dbPath);
        });
        _db = [FMDatabase databaseWithPath:dbPath];
    }
    return _db;
}

// 默认为空  即数据库中的属性会和模型属性一样
- (NSString *)property_preStr {
    return @"";
}

@end
