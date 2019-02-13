//
//  ViewController.m
//  ZLFMDB
//
//  Created by Abe on 2017/11/29.
//  Copyright © 2017年 heimavista. All rights reserved.
//

#import "ViewController.h"
#import "YYModel.h"
#import "TestObj.h"
#import "NSObject+DBExtension.h"
#import "UserManager.h"
#import "NewUser.h"

@interface ViewController ()
@property (strong, nonatomic) FMDatabase *db;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NewUser *user1 = [[NewUser alloc] init];
    user1.name = @"user 1";
    user1.age = 18;
    user1.idNum = @"100";
    user1.height = 179;
    user1.pan = 80;
    user1.dic = @{@"dic":@"this is dix"};
    user1.ary = @[@"ary"];
    // 增 或 改 1个
    [[UserManager shareInstance] saveObj:user1];
    
    NewUser *user2 = [[NewUser alloc] init];
    user2.name = @"user 2";
    user2.age = 19;
    user2.idNum = @"101";
    user2.height = 179;
    user2.pan = 80;
    user2.dic = @{@"dic":@"this is dix"};
    user2.ary = @[@"ary"];
    
    NewUser *user3 = [[NewUser alloc] init];
    user3.name = @"user 1";
    user3.age = 19;
    user3.idNum = @"103";
    user3.height = 179;
    user3.pan = 80;
    user3.dic = @{@"dic":@"this is dix"};
    user3.ary = @[@"ary"];
    
    // 批量增 或 批量改
    [[UserManager shareInstance] saveObjs:@[user2, user3]];
    
    NSArray *allAry = [[UserManager shareInstance] allObjsInDB];
    NSMutableArray *userAry = [NSMutableArray arrayWithCapacity:allAry.count];
    for(NSDictionary *dic in allAry) {
        NewUser *user = [NewUser yy_modelWithDictionary:dic];
        if(user) {
            [userAry addObject:user];
        }
    }
    
    // 搜 年龄 大于等于 19的
    NSArray *query = [[UserManager shareInstance] queryTest];
    
    [[UserManager shareInstance] deleteObj:user2];

    return;

//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"history.json" ofType:nil];
//    NSString *jsonstr = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:nil];
//
//    NSData *jsonData = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
//    NSArray *users = jsonDic[@"user"];
//    User *user = [User yy_modelWithDictionary:[users firstObject]];
//    NSLog(@"%@",user);

}


@end
