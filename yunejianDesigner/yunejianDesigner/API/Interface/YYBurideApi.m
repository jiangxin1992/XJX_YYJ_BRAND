//
//  YYBurideApi.m
//  Yunejian
//
//  Created by chuanjun sun on 2017/8/15.
//  Copyright © 2017年 yyj. All rights reserved.
//

#import "YYBurideApi.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "RequestMacro.h"
#import "YYRequestHelp.h"
#import "YYHttpHeaderManager.h"

@implementation YYBurideApi

/**
 * 新增一条日活记录
 */
+ (void)addStatDaily{
    // get URL 
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:KBurideStatDaily];
    // 传入的值都没用
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:KBurideStatDaily params:nil];

    NSDictionary *parameters = @{@"platform":@"IPAD"};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {

    }];
}



@end
