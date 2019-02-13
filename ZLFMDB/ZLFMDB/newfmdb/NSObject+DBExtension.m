//
//  NSObject+DBExtension.m
//  ZLFMDB
//
//  Created by Abe on 2018/12/10.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import "NSObject+DBExtension.h"
#import "DbObj.h"
#import "NSArray+SwiftExtension.h"

@implementation NSObject (DBExtension)
+ (NSArray *)cls_propertyList {
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList(self, &count);
    NSMutableArray *mary = [NSMutableArray arrayWithCapacity:count];
    for(int i=0 ;i<count; i++) {
        objc_property_t property = propertyList[i];
        YYClassPropertyInfo *propertyInfo = [[YYClassPropertyInfo alloc] initWithProperty:property];
        YYEncodingType numberType = YYEncodingTypeMask;
        YYEncodingNSType2 nsType = YYEncodingTypeNSUnknown;
        if((propertyInfo.type & YYEncodingTypeMask) == YYEncodingTypeObject) {
            numberType = YYEncodingTypeObject;
            nsType = YYClassGetNSType2(propertyInfo.cls);
        }else {
            BOOL isnumber = YYEncodingTypeIsCNumber2(propertyInfo.type);
            if(isnumber) {
                numberType = (YYEncodingTypeMask&propertyInfo.type);
            }
        } 
        DbObj *dbobj = [[DbObj alloc] initWithPropertyName:propertyInfo.name nsType:nsType numberType:numberType];
        if(propertyInfo) {
            [mary addObject:dbobj];
        }
    }
    free(propertyList);
//  过滤掉不转换的属性
    NSArray *propertyAry = [mary filter:^BOOL(DbObj *obj) {
        if(obj.dbPropertyStr.length > 0) {
            return YES;
        }
        return NO;
    }];
    if([[self class] respondsToSelector:@selector(dbPropertyWhiteList)]) {
        NSArray *whiteAry = [[self class] dbPropertyWhiteList];
        if(whiteAry.count) {
            NSArray *whiteProperty = [propertyAry filter:^BOOL(DbObj *dbobj) {
                if([whiteAry containString:dbobj.propertyName]) {
                    return YES;
                }
                return NO;
            }];
            propertyAry = whiteProperty;
        }
    }else if([[self class] respondsToSelector:@selector(dbPropertyBlackList)]) {
        NSArray *blackAry = [[self class] dbPropertyBlackList];
        if(blackAry.count) {
            NSArray *whiteProperty = [propertyAry filter:^BOOL(DbObj *dbobj) {
                if([blackAry containString:dbobj.propertyName]) {
                    return NO;
                }
                return YES;
            }];
            propertyAry = whiteProperty;
        }
    }
    
    
    if([[self class] respondsToSelector:@selector(primaryKeys)]) {
        NSArray *primaryKeys = [[self class] primaryKeys];
        if(primaryKeys.count) {
            [propertyAry enumerateObjectsUsingBlock:^(DbObj *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([primaryKeys containString:obj.propertyName]) {
                    obj.isPrimaryKey = YES;
                }
            }];
        }
    }
    return propertyAry;
}

- (NSArray *)propertyList {
    return [[self class] cls_propertyList];
}



@end
