//
//  NSObject+DBExtension.h
//  ZLFMDB
//
//  Created by Abe on 2018/12/10.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface NSObject (DBExtension)
- (NSArray *)propertyList;
+ (NSArray *)cls_propertyList;

// obj 重写
+ (NSArray *)primaryKeys; // 主
// 只有一个会生效
+ (NSArray *)dbPropertyWhiteList; // 白名单  优先级高于黑名单
+ (NSArray *)dbPropertyBlackList; // 黑名单

@end
