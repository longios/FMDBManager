//
//  DbObj.m
//  ZLFMDB
//
//  Created by Abe on 2018/12/11.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import "DbObj.h"
#import "NSArray+jsonExtension.h"
#import "NSDictionary+jsonExtension.h"
@interface DbObj()
@property(assign, nonatomic) BOOL nsTypeSet;
@property(assign, nonatomic) BOOL numberTypeSet;
@end

@implementation DbObj

- (instancetype)initWithPropertyName:(NSString *)propertyName nsType:(YYEncodingNSType2)nstype numberType:(YYEncodingType)numberType
{
    self = [super init];
    if (self) {
        self.propertyName = propertyName;
        self.nsType = nstype;
        self.numberType = numberType;
    }
    return self;
}

- (void)setNsType:(YYEncodingNSType2)nsType {
    _nsType = nsType;
    self.nsTypeSet = YES;
    [self setDBPropertyStrIfNeeded];
}

- (void)setNumberType:(YYEncodingType)numberType {
    _numberType = numberType;
    self.numberTypeSet = YES;
    [self setDBPropertyStrIfNeeded];
}

- (void)setDBPropertyStrIfNeeded {
    if(self.nsTypeSet && self.numberTypeSet) {
        switch (self.numberType) {
            case YYEncodingTypeBool:
            case YYEncodingTypeInt8:
            case YYEncodingTypeUInt8:
            case YYEncodingTypeInt16:
            case YYEncodingTypeUInt16:
            case YYEncodingTypeInt32:
            case YYEncodingTypeUInt32:
            case YYEncodingTypeInt64:
            case YYEncodingTypeUInt64:
            {
                self.dbPropertyStr = @"integer";
            }
                break;
            case YYEncodingTypeFloat:
            {
                self.dbPropertyStr = @"float";
            }
                break;
            case YYEncodingTypeDouble:
            case YYEncodingTypeLongDouble:
            {
                self.dbPropertyStr = @"double";
            }
                break;
            case YYEncodingTypeObject:
            {
                // 对象
                [self setPropertyStrWithNSType];
            }
                break;
            default:
            {
                self.dbPropertyStr = @"";
            }
                break;
        }
    }
}

- (void)setPropertyStrWithNSType {
    switch (self.nsType) {
        case YYEncodingTypeNSString:
        case YYEncodingTypeNSMutableString:
        {
            self.dbPropertyStr = @"text";
        }
            break;
        case YYEncodingTypeNSDate:
        {
            self.isTime = YES;
            self.dbPropertyStr = @"datetime";
        }
            break;
        case YYEncodingTypeNSArray:
        case YYEncodingTypeNSMutableArray:
        {
            self.isAry = YES;
            self.dbPropertyStr = @"text";
        }
            break;
        case YYEncodingTypeNSDictionary:
        case YYEncodingTypeNSMutableDictionary:
        {
            self.isDic = YES;
            self.dbPropertyStr = @"text";
        }
            break;
        default:
        {
            self.dbPropertyStr = @"";
        }
            break;
    }
}

- (id)valueWithDbFormatterWithObj:(id)obj {
    // 只返回对象  数字必须number封装
    if(self.isAry) {
        return [(NSArray *)obj jsonStr];
    }else if(self.isDic) {
        return [(NSDictionary*)obj jsonStr];
    }else if(self.isTime) {
        if([obj isKindOfClass:[NSDate class]]) {
            return @([(NSDate *)obj timeIntervalSince1970]);
        }
    }else if(self.dbNumberType > 0) {
        return obj;
    }else if([obj isKindOfClass:[NSString class]]) {
        return obj;
    }
    return nil;
}

- (void)setDbPropertyStr:(NSString *)dbPropertyStr {
    _dbPropertyStr = dbPropertyStr;
    if([dbPropertyStr isEqualToString:@"integer"]) {
        self.dbNumberType = DBNumberIntegerType;
    }else if([dbPropertyStr isEqualToString:@"double"]) {
        self.dbNumberType = DBNumberDoubleType;
    }else if([dbPropertyStr isEqualToString:@"float"]) {
        self.dbNumberType = DBNumberFloatType;
    }else if([dbPropertyStr isEqualToString:@"text"]) {
        self.dbNumberType = DBNumberStringType;
    }else if([dbPropertyStr isEqualToString:@"datetime"]) {
        self.dbNumberType = DBNumberTimeType;
    }
}



@end
