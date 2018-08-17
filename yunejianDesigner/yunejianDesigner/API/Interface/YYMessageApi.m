//
//  YYMessageApi.m
//  yunejianDesigner
//
//  Created by Apple on 16/10/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYMessageApi.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "RequestMacro.h"
#import "YYRequestHelp.h"
#import "YYHttpHeaderManager.h"

#import "YYSkuMessageListModel.h"
#import "YYMessageTalkListModel.h"
#import "YYMessageUserChatListModel.h"

@implementation YYMessageApi
//获取合作买手店
+ (void)getUserChatListPageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYMessageUserChatListModel *chatListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kMessageUserChatList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kMessageUserChatList params:nil];

    NSDictionary *parameters = @{@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYMessageUserChatListModel * chatList = [[YYMessageUserChatListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,chatList,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}


//删除会话
+(void)deleteMessageUserChat:(NSString *)oppositeEmail andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kMessageUserChatDelete];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kMessageUserChatDelete params:nil];

    NSDictionary *parameters = @{@"oppositeEmail":oppositeEmail};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

//会话已读
+(void)markAsReadMessageUserChatWithOppositeId:(NSNumber *)oppositeId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSInteger num, NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kMessageMarkAsRead];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kMessageMarkAsRead params:nil];

    NSDictionary *parameters = @{@"receiveId":oppositeId};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            NSInteger num = [responseObject integerValue];
            block(rspStatusAndMessage,num,error);
        }else{
            block(rspStatusAndMessage,0,error);
        }
    }];
}

//消息历史记录
+ (void)getMessageTalkHistoryWithOppositeId:(NSNumber *)oppositeId pageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYMessageTalkListModel *talkListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kMessageTalkHistory];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kMessageTalkHistory params:nil];

    NSDictionary *parameters = @{@"receiveId":oppositeId,@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYMessageTalkListModel * talkList = [[YYMessageTalkListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,talkList,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}

//发送私信
+(void)sendTalkWithOppositeId:(NSNumber*)oppositeId content:(NSString *)content charType:(NSString *)charType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kMessageSend];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kMessageSend params:nil];

    NSDictionary *parameters = @{@"receiveIds":oppositeId,@"content":content,@"chatType":charType};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

//获取库存消息列表
+ (void)getSkuMessageListAtPageIndex:(NSNumber *)pageIndex complete:(void (^) (YYRspStatusAndMessage *rspStatusAndMessage, YYSkuMessageListModel *skuMessageListModel, NSError *error))completeBlock{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kGetSkuNotifyMsgList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kGetSkuNotifyMsgList params:nil];
    
    NSDictionary *parameters = @{@"pageIndex" : pageIndex, @"pageSize" : @(20), @"mark" : @(true)};
    NSData *body = [parameters mj_JSONData];
    
    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
        if (!error && responseObject) {
//            NSLog(@"Sku : %@", responseObject);
            YYSkuMessageListModel *skuMessageListModel = [[YYSkuMessageListModel alloc] initWithDictionary:responseObject error:nil];
            if (completeBlock) {
                completeBlock(rspStatusAndMessage, skuMessageListModel, error);
            }
        } else {
            if (completeBlock) {
                completeBlock(rspStatusAndMessage, nil, error);
            }
        }
    }];
}

//标记库存消息为已读
+ (void)markSkuAsRead:(void (^) (YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))completeBlock {
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kMarkSkuAsRead];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kMarkSkuAsRead params:nil];
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
        if (completeBlock) {
            completeBlock(rspStatusAndMessage, error);
        }
    }];
}

@end
