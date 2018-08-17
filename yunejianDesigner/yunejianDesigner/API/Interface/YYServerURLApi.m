//
//  YYServerURLApi.m
//  Yunejian
//
//  Created by Apple on 15/12/29.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYServerURLApi.h"
#import "YYRequestHelp.h"
#import "YYHttpHeaderManager.h"

#define hostUrl @"/service/iosutil/hostUrlV2"

@implementation YYServerURLApi

+(void)getAppServerURLWidth:(void (^)(NSString *serverURL,BOOL isNeedUpdate,NSError *error))block{
    // get URL
    NSString *requestURL = [kYYServerURL stringByAppendingString:hostUrl];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:hostUrl params:nil];

    NSDictionary *parameters = @{@"version":kYYCurrentVersion,@"type":@"tbPhoneDesignerApp"};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
        if (responseObject) {
            BOOL isNeedUpdate = [[responseObject objectForKey:@"isNeedUpdate"] integerValue];
            block([responseObject objectForKey:@"host"],isNeedUpdate,error);
        }else{
            block(nil,NO,error);
        }
    }];
}
@end
