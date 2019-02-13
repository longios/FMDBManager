//
//  ZLFMDBManager.h
//  ZLFMDB
//
//  Created by Abe on 2018/12/14.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "DbObj.h"

@class ZLFMDBManager;
// 属性名字和db中的名字一样的情况
// cusText 为 dbname dbproperty  cusText , 即后面要添加的东西 比如 not null default 0， AUTOINCREMENT, primary key ...
typedef  ZLFMDBManager *(^DBMapKeyBlockWithType2)(NSString *property,NSString *cusText);
// 属性名字和db中的名字不一样的情况
//typedef  ZLFMDBManager *(^DBDifKeyMapBlockWithType)(NSString *orignProperty, NSString *dbProperty,NSString *propertyType ,NSString *tableProperty);

@interface ZLFMDBManager : NSObject
// 添加额外的字段  或者想要自定义的时候使用
@property(copy, nonatomic) DBMapKeyBlockWithType2 CUSMODIFY;
//@property(copy, nonatomic) DBMapKeyBlockWithType2 MAPPING;
//@property(copy, nonatomic) DBMapKeyBlockWithType2 DICMAPPING; // 增加字典
//@property(copy, nonatomic) DBMapKeyBlockWithType2 ARRAYMAPPING; // 增加数组

// 先不支持不一样的名字
// 和上面唯一的区别  可以指定 db的名字和属性名字不一样
//@property(copy, nonatomic) DBDifKeyMapBlockWithType DIF_MAPPING;
//@property(copy, nonatomic) DBDifKeyMapBlockWithType DIF_DICMAPPING;
//@property(copy, nonatomic) DBDifKeyMapBlockWithType DIF_ARRAYMAPPING;

//@property(copy, nonatomic) ZLFMDBManager *PRIMARYMAPPING; //
// public
// 创建表
- (void)createTableIfNeeded;
// 将 resultset 转化为datacls
- (NSArray *)changeSetToObjWithSet:(FMResultSet *)resultSet;
// 保存数据  开事务的时候 db 外界穿进去
- (void)saveObj:(id)obj withDB:(FMDatabase *)db;
// 删除某个obj
- (void)deleteObj:(id)obj withDB:(FMDatabase *)db;
// 查询表中所有的obj
- (NSArray<NSDictionary *> *)allObjsInDB;

- (void)dropTable;

// 继承
- (Class)dataCls;
- (NSString *)dbName;
- (FMDatabaseQueue *)dbqueue;
- (NSString *)tabName;
// 数据库中属性的前缀
- (NSString *)property_preStr;



@end
