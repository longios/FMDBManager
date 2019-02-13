//
//  TestObj.h
//  ZLFMDB
//
//  Created by Abe on 2018/12/10.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+DBExtension.h"
#import "User.h"

@interface TestObj : NSObject
@property(assign, nonatomic) NSInteger integer;
@property(assign, nonatomic) CGFloat floatValue;
@property(assign, nonatomic) double doubleValue;
@property(strong, nonatomic) NSNumber *number;
@property(assign, nonatomic) CGRect rect;
@property(assign, nonatomic) CGSize size;

@property(strong, nonatomic) NSObject *obj;
@property(strong, nonatomic) User *cusUser;
@property(strong, nonatomic) NSString *str;
@property(strong, nonatomic) id objID;

@property(strong, nonatomic) NSArray *ary;
@property(strong, nonatomic) NSDictionary *dic;
@property(strong, nonatomic) NSDate *timeDate;
@property(strong, nonatomic) NSMutableArray *mary;
@property(strong, nonatomic) NSMutableDictionary *mdic;

- (NSDictionary *)dbDic;

@end
