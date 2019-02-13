//
//  NSArray+jsonExtension.m
//  ZLFMDB
//
//  Created by Abe on 2017/11/29.
//  Copyright © 2017年 heimavista. All rights reserved.
//

#import "NSArray+jsonExtension.h"

@implementation NSArray (jsonExtension)
- (NSString *)jsonStr {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (instancetype)arrayWithJsonString:(NSString *)jsonString {
    if(jsonString == nil || jsonString.length == 0) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return array;
}

@end
