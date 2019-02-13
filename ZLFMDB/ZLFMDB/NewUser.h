//
//  NewUser.h
//  ZLFMDB
//
//  Created by Abe on 2018/12/19.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewUser : NSObject
@property(strong, nonatomic) NSString *idNum;
@property(strong, nonatomic) NSString *name;
@property(assign, nonatomic) NSInteger age;
@property(strong, nonatomic) NSDate *birthDay;
@property(strong, nonatomic) NSDictionary *dic;
@property(strong, nonatomic) NSArray *ary;
@property(assign, nonatomic) float height;
@property(assign, nonatomic) float pan;

@end
