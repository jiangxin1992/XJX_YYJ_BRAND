//
//  YYConnApi.m
//  Yunejian
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYConnApi.h"
#import "YYRequestHelp.h"
#import "RequestMacro.h"
#import "UserDefaultsMacro.h"
#import "YYHttpHeaderManager.h"
@implementation YYConnApi
//设计师添加买手店(买手添加设计师)
+ (void)invite:(NSInteger )guestId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kConnInvite];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kConnInvite params:nil];

    NSDictionary *parameters = @{@"guestId":@(guestId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

//对设计师的邀请请求操作
+ (void)getConnBuyers:(NSInteger)status pageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYConnBuyerListModel *listModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kConnBuyers];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kConnBuyers params:nil];

    NSDictionary *parameters = @{@"status":@(status),@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYConnBuyerListModel * buyerList = [[YYConnBuyerListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,buyerList,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}
//设计师对买手合作关系的操作（原设计师移除与买手店的合作关系接口）
+ (void)OprateConnWithBuyer:(NSInteger)buyerId status:(NSInteger)status andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kConnWithBuyerOp];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kConnWithBuyerOp params:nil];

    NSDictionary *parameters = @{@"buyerId":@(buyerId),@"status":@(status)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

//对设计师的邀请请求操作 1->同意邀请 2->拒绝邀请 3->解除合作关系 4->取消合作邀请
+ (void)OprateConnWithDesignerBrand:(NSInteger)designerId status:(NSInteger)status andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kConnWithDesignerBrandOp];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kConnWithDesignerBrandOp params:nil];

    NSDictionary *parameters = @{@"designerId":@(designerId),@"status":@(status)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

//正在被邀请的品牌(收到的邀请<设计师品牌列表>)1 买手店的所有合作品牌2
+ (void)getConnBrands:(NSInteger)type  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYConnBrandInfoListModel *listModel,NSError *error))block{
    // get URL
    NSString *actionUrl = @"";
    if(type == 1){
        actionUrl = kAllAlreadyConnBrands;
    }else if(type == 2){
        actionUrl = kBeingInvitedBrands;
    }

    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:actionUrl];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:actionUrl params:nil];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYConnBrandInfoListModel * brandList = [[YYConnBrandInfoListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,brandList,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}
//买手店按条件查询所有设计师(带分页,)
+ (void)queryDesignerWithQueryStr:(NSString *)queryStr pageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYConnDesignerListModel *designerListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kConnQueryDesignerWithPage];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kConnQueryDesignerWithPage params:nil];

    NSDictionary *parameters = nil;
    if(![NSString isNilOrEmpty:queryStr]){
        parameters = @{@"queryStr":queryStr,@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    }else{
        parameters = @{@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    }
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYConnDesignerListModel *listModel = [[YYConnDesignerListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,listModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];

}

//设计师按条件查询所有买手店(带分页,目前邀请状态)
+(void) queryConnBuyer:(NSString *)queryStr  pageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,YYBuyerListModel *buyerList,NSError *error))block{

    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kConnQueryBuyerList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kConnQueryBuyerList params:nil];

    NSDictionary *parameters = nil;
    if(![queryStr isEqualToString:@""]){
        parameters = @{@"queryStr":queryStr,@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    }else{
        parameters = @{@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    }
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYBuyerListModel *buyerListModel = [[YYBuyerListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,buyerListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

//批量判断买手店是否在合作状态中
+(void)checkConnBuyers:(NSString *)buyerIds andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,BOOL isConn,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kCheckConnBuyers];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kCheckConnBuyers params:nil];

    NSDictionary *parameters = @{@"buyerIds":buyerIds};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error && [responseObject objectForKey:@"hasUnConnected"] != [NSNull null]) {
            BOOL isconn = ![[responseObject objectForKey:@"hasUnConnected"] integerValue];
            block(rspStatusAndMessage,isconn,error);
        }else{
            block(rspStatusAndMessage,YES,error);
        }
    }];
}
@end
