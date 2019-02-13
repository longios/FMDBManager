//
//  UserManager.m
//  ZLFMDB
//
//  Created by Abe on 2018/12/19.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager
static UserManager *manager;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.CUSMODIFY(@"idNum",@"not null default ''");
        [self createTableIfNeeded];
    }
    return self;
}

- (void)deleteObj:(id)obj {
    __weak typeof(&*self) weakself = self;
    [self.dbqueue inDatabase:^(FMDatabase * _Nonnull db) {
        [weakself deleteObj:obj withDB:db];
    }];
}

- (void)saveObj:(id)obj {
    __weak typeof(&*self) weakself = self;
    [self.dbqueue inDatabase:^(FMDatabase * _Nonnull db) {
        [weakself saveObj:obj withDB:db];
    }];
    //    [self saveObj:obj withDB:self.db];
}


- (void)saveObjs:(NSArray *)objs {
    __weak typeof(&*self) weakself = self;
    [self.dbqueue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        for(id obj in objs) {
            [weakself saveObj:obj withDB:db];
        }
    }];
    
}

- (NSArray *)queryTest {
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where age >= ?", self.tabName];
    __block NSArray *ary;
    __weak typeof(self) weakself = self;
    [self.dbqueue inDatabase:^(FMDatabase * _Nonnull db) {
        FMResultSet *resultSets = [db executeQuery:sql, @(19)];
        ary = [weakself changeSetToObjWithSet:resultSets];
    }];
    return ary;
}

- (Class)dataCls {
    return [NewUser class];
}

- (NSString *)tabName {
    return @"UserManager";
}


@end
