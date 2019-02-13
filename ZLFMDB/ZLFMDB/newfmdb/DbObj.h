//
//  DbObj.h
//  ZLFMDB
//
//  Created by Abe on 2018/12/11.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYClassInfo.h>

typedef NS_ENUM(NSUInteger, DBNumberType) {
    DBNumberNoneType = 0,
    DBNumberIntegerType = 1,
    DBNumberFloatType,
    DBNumberDoubleType,
    DBNumberStringType,
    DBNumberTimeType,
};

// YYCopy 从yy中拿出  为了属性的映射
typedef NS_ENUM (NSUInteger, YYEncodingNSType2) {
    YYEncodingTypeNSUnknown = 0,
    YYEncodingTypeNSString,
    YYEncodingTypeNSMutableString,
    YYEncodingTypeNSValue,
    YYEncodingTypeNSNumber,
    YYEncodingTypeNSDecimalNumber,
    YYEncodingTypeNSData,
    YYEncodingTypeNSMutableData,
    YYEncodingTypeNSDate,
    YYEncodingTypeNSURL,
    YYEncodingTypeNSArray,
    YYEncodingTypeNSMutableArray,
    YYEncodingTypeNSDictionary,
    YYEncodingTypeNSMutableDictionary,
    YYEncodingTypeNSSet,
    YYEncodingTypeNSMutableSet,
};

static __inline__ __attribute__((always_inline)) YYEncodingNSType2 YYClassGetNSType2(Class cls) {
    if (!cls) return YYEncodingTypeNSUnknown;
    if ([cls isSubclassOfClass:[NSMutableString class]]) return YYEncodingTypeNSMutableString;
    if ([cls isSubclassOfClass:[NSString class]]) return YYEncodingTypeNSString;
    if ([cls isSubclassOfClass:[NSDecimalNumber class]]) return YYEncodingTypeNSDecimalNumber;
    if ([cls isSubclassOfClass:[NSNumber class]]) return YYEncodingTypeNSNumber;
    if ([cls isSubclassOfClass:[NSValue class]]) return YYEncodingTypeNSValue;
    if ([cls isSubclassOfClass:[NSMutableData class]]) return YYEncodingTypeNSMutableData;
    if ([cls isSubclassOfClass:[NSData class]]) return YYEncodingTypeNSData;
    if ([cls isSubclassOfClass:[NSDate class]]) return YYEncodingTypeNSDate;
    if ([cls isSubclassOfClass:[NSURL class]]) return YYEncodingTypeNSURL;
    if ([cls isSubclassOfClass:[NSMutableArray class]]) return YYEncodingTypeNSMutableArray;
    if ([cls isSubclassOfClass:[NSArray class]]) return YYEncodingTypeNSArray;
    if ([cls isSubclassOfClass:[NSMutableDictionary class]]) return YYEncodingTypeNSMutableDictionary;
    if ([cls isSubclassOfClass:[NSDictionary class]]) return YYEncodingTypeNSDictionary;
    if ([cls isSubclassOfClass:[NSMutableSet class]]) return YYEncodingTypeNSMutableSet;
    if ([cls isSubclassOfClass:[NSSet class]]) return YYEncodingTypeNSSet;
    return YYEncodingTypeNSUnknown;
}

static __inline__ __attribute__((always_inline)) BOOL YYEncodingTypeIsCNumber2(YYEncodingType type) {
    switch (type & YYEncodingTypeMask) {
        case YYEncodingTypeBool:
        case YYEncodingTypeInt8:
        case YYEncodingTypeUInt8:
        case YYEncodingTypeInt16:
        case YYEncodingTypeUInt16:
        case YYEncodingTypeInt32:
        case YYEncodingTypeUInt32:
        case YYEncodingTypeInt64:
        case YYEncodingTypeUInt64:
        case YYEncodingTypeFloat:
        case YYEncodingTypeDouble:
        case YYEncodingTypeLongDouble: return YES;
        default: return NO;
    }
}

@interface DbObj : NSObject
@property (assign, nonatomic) YYEncodingType numberType;
@property (assign, nonatomic) YYEncodingNSType2 nsType;
@property (strong, nonatomic) NSString *dbPropertyName; // 原有的属性名  默认为空
@property (strong, nonatomic) NSString *propertyName; // 数据库属性名  属性名字和数据库名字一样
@property (strong, nonatomic) NSString *dbPropertyStr; // db 中的属性类型
//@property (strong, nonatomic) NSString *dbCusStuctStr; // db 自定义构建语句
@property (strong, nonatomic) NSString *dbAddStr;  //db 后面增加的

@property (assign, nonatomic) BOOL isPrimaryKey;
@property (assign, nonatomic) BOOL isAry; // 需要数组转换
@property (assign, nonatomic) BOOL isDic; // 需要字典转换
@property (assign, nonatomic) BOOL isTime; // 需要时间转换

@property (assign, nonatomic) DBNumberType dbNumberType;

- (instancetype)initWithPropertyName:(NSString *)propertyName nsType:(YYEncodingNSType2)nstype numberType:(YYEncodingType)numberType;
// 将obj的值转化为  db 中的值  即 ary  dic  time 的时候需要转换
- (id)valueWithDbFormatterWithObj:(id)obj;

@end
