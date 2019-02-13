//
//  NSArray+jsonExtension.h
//  ZLFMDB
//
//  Created by Abe on 2017/11/29.
//  Copyright © 2017年 heimavista. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (jsonExtension)
- (NSString *)jsonStr;
+ (instancetype)arrayWithJsonString:(NSString *)jsonString;

@end
