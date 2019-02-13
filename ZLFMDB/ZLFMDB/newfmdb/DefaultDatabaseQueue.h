//
//  DefaultDatabaseQueue.h
//  ZLFMDB
//
//  Created by Abe on 2018/12/14.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import "FMDB.h"

@interface DefaultDatabaseQueue : FMDatabaseQueue
+ (instancetype)shareInstance;

@end
