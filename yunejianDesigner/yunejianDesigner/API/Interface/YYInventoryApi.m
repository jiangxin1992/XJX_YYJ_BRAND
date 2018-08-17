//
//  YYInventoryApi.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYInventoryApi.h"
#import "YYRequestHelp.h"
#import "RequestMacro.h"
#import "UserDefaultsMacro.h"
#import "YYHttpHeaderManager.h"
#import "YYMessageUnreadModel.h"
#import "AppDelegate.h"
@implementation YYInventoryApi

//库存调拨列表
+(void)getAllottingList:(NSString *)buyerIds month:(NSInteger)month status:(NSInteger)status pageIndex:(int)pageIndex pageSize:(int)pageSize queryStr:(NSString *)queryStr andBlock:(void (^)(YYRspStatusAndMessage *, YYInventoryAllottingListModel *listModel, NSError *))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kInventoryAllotting];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kInventoryAllotting params:nil];

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    [mutParameters setObject:@(pageIndex) forKey:@"pageIndex"];
    [mutParameters setObject:@(pageSize) forKey:@"pageSize"];

    if(![NSString isNilOrEmpty:queryStr]){
        [mutParameters setObject:queryStr forKey:@"query"];
    }
    NSDictionary *parameters = [mutParameters copy];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYInventoryAllottingListModel *allottingList= [[YYInventoryAllottingListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,allottingList,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}
//获取调拨详情
+(void)getAllottingInfo:(NSInteger)styleId colorId:(NSInteger)colorId andBlock:(void (^)(YYRspStatusAndMessage *, YYInventoryAllottingInfoModel *infoModel, NSError *))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kInventoryAllottingInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kInventoryAllottingInfo params:nil];

    NSDictionary *parameters = @{@"styleId":@(styleId),@"colorId":@(colorId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYInventoryAllottingInfoModel *infoModel= [[YYInventoryAllottingInfoModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,infoModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}

//单个买手店订单列表
+(void)getBuyerOrders:(NSString *)orderCodes andBlock:(void (^)(YYRspStatusAndMessage *, YYInventoryOrderListModel *listModel, NSError *))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kInventoryOrders];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kInventoryOrders params:nil];

    NSDictionary *parameters = @{@"orderCodes":orderCodes};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYInventoryOrderListModel *listModel= [[YYInventoryOrderListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,listModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}

//标识补货需求已解决
+(void)setDemandResolve:(NSInteger)demandId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kInventoryDemandResolve];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kInventoryDemandResolve params:nil];

    NSDictionary *parameters = @{@"id":@(demandId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

//标识库存已解决
+(void)setAllottingResolve:(NSInteger)allottingId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kInventoryAllottingResolve];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kInventoryAllottingResolve params:nil];

    NSDictionary *parameters = @{@"id":@(allottingId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

//标记消息为已读
+(void)markAsReadOnMsg:(NSString *)msgIds adnBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kInventoryMarkAsRead];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kInventoryMarkAsRead params:nil];

    NSDictionary *parameters = nil;
    if(![NSString isNilOrEmpty:msgIds]){
        parameters = @{@"msgIds":msgIds};
    }else{
        parameters = @{@"msgIds":@"",@"clearAll":@"true"};
    }
    NSData *body = [parameters mj_JSONData];
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            if(block){
                block(rspStatusAndMessage,error);
            }else{
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                if([appDelegate.messageUnreadModel.inventoryAmount integerValue] > 0){
                    appDelegate.messageUnreadModel.inventoryAmount = @(0);
                    [[NSNotificationCenter defaultCenter] postNotificationName:UnreadInventoryNotifyMsgAmount object:nil userInfo:nil];
                }
            }
        }else{
            if(block)
            block(rspStatusAndMessage,error);
        }
    }];
}
@end
