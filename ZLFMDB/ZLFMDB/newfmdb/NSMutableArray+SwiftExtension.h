//
//  NSMutableArray+SwiftExtension.h
//  ZLFMDB
//
//  Created by Abe on 2018/12/14.
//  Copyright © 2018 heimavista. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef id (^MapBlock)( id obj);
typedef BOOL (^FilterBlock)( id obj);
typedef double (^ReduceBlock)(double orignNum, id obj);

@interface NSMutableArray (SwiftExtension)
- (NSMutableArray *)map:(MapBlock)block;
- (NSMutableArray *)filter:(FilterBlock)filterBlock;
- (double )reduceWithOrignValue:(double)orignvalue reduceBlock:(ReduceBlock)reduceBlock ;
- (BOOL)aryOneFollowCondition:(FilterBlock)filterBlock;
- (BOOL)aryAllFollowCondition:(FilterBlock)filterBlock;
- (BOOL)containString:(NSString *)string;

@end
