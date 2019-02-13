//
//  DefaultDatabaseQueue.m
//  ZLFMDB
//
//  Created by Abe on 2018/12/14.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import "DefaultDatabaseQueue.h"

@implementation DefaultDatabaseQueue
static DefaultDatabaseQueue *_queue;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = [[DefaultDatabaseQueue alloc] init];
    });
    return _queue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *defaultDbName = [NSString stringWithFormat:@"%@.db", @"default"];
        NSString *dbPath = [path stringByAppendingPathComponent:defaultDbName];
        self = (DefaultDatabaseQueue *)[DefaultDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

@end
