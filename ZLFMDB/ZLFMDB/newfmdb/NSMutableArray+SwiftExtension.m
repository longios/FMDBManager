//
//  NSMutableArray+SwiftExtension.m
//  ZLFMDB
//
//  Created by Abe on 2018/12/14.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import "NSMutableArray+SwiftExtension.h"


@implementation NSMutableArray (SwiftExtension)


- (NSMutableArray *)map:(MapBlock)block {
    NSMutableArray *mary = [NSMutableArray array];
    for(id obj in self) {
        id afterObj = block(obj);
        [mary addObject:afterObj];
    }
    return mary;
}


- (NSMutableArray *)filter:(FilterBlock)filterBlock {
    NSMutableArray *mary = [NSMutableArray array];
    for(id obj in self) {
        if(filterBlock(obj)) {
            [mary addObject:obj];
        }
    }
    return mary;
}

- (double )reduceWithOrignValue:(double)orignvalue reduceBlock:(ReduceBlock)reduceBlock {
    double value = orignvalue;
    for(id obj in self) {
        double reduceValue = reduceBlock(value, obj);
        value = reduceValue;
    }
    return value;
}

- (BOOL)aryOneFollowCondition:(FilterBlock)filterBlock {
    for(id obj in self) {
        if(filterBlock(obj)) {
            return YES;
            break;
        }
    }
    return NO;
}

- (BOOL)aryAllFollowCondition:(FilterBlock)filterBlock {
    for(id obj in self) {
        if(!filterBlock(obj)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)containString:(NSString *)string {
    for(id obj in self) {
        if([obj isKindOfClass:[NSString class]]) {
            if([(NSString*)obj isEqualToString:string]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
