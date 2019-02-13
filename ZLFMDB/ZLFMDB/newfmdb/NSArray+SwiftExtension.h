//
//  NSArray+SwiftExtension.h
//  ZLTools
//
//  Created by Abe on 2018/4/3.
//  Copyright © 2018年 heimavista. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^MapBlock)( id obj);
typedef BOOL (^FilterBlock)( id obj);
typedef double (^ReduceBlock)(double orignNum, id obj);

@interface NSArray (SwiftExtension)

- (NSArray *)map:(MapBlock)block;
- (NSArray *)filter:(FilterBlock)filterBlock;
- (double )reduceWithOrignValue:(double)orignvalue reduceBlock:(ReduceBlock)reduceBlock ;

- (BOOL)aryOneFollowCondition:(FilterBlock)filterBlock;
- (BOOL)aryAllFollowCondition:(FilterBlock)filterBlock;

- (BOOL)containString:(NSString *)string;
@end
