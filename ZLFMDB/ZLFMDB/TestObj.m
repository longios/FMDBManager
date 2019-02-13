//
//  TestObj.m
//  ZLFMDB
//
//  Created by Abe on 2018/12/10.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import "TestObj.h"

@implementation TestObj

- (NSDictionary *)dbDic {
    return @{};
}

//+ (NSArray *)dbPropertyWhiteList {
//    return @[@"floatValue",@"str",@"none"];
//}

+ (NSArray *)dbPropertyBlackList {
    return @[@"rect",@"size",@"obj"];
}

@end
