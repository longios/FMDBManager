//
//  UserManager.h
//  ZLFMDB
//
//  Created by Abe on 2018/12/19.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import "ZLFMDBManager.h"
#import "NewUser.h"

@interface UserManager : ZLFMDBManager
+ (instancetype)shareInstance;

- (void)deleteObj:(id)obj;

// 没有事务的时候
- (void)saveObj:(id)obj;

- (void)saveObjs:(NSArray *)objs;


- (NSArray *)queryTest;

@end
