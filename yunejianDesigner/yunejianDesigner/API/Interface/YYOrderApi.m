//
//  YYOrderApi.m
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderApi.h"
#import "YYRequestHelp.h"
#import "YYHttpHeaderManager.h"
#import "RequestMacro.h"
#import "YYOrderStatusMarksModel.h"
#import "YYUser.h"

@implementation YYOrderApi
/**
 *
 * 拒绝订单
 *
 */
+(void)refuseOrderByOrderCode:(NSString *)orderCode reason:(NSString *)reason andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{

    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderRefuse];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderRefuse params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode,@"reason":reason};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            block(rspStatusAndMessage,error);

        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

/**
 *
 * 确认订单
 *
 */
+ (void)confirmOrderByOrderCode:(NSString *)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{

    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderConfirm];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderConfirm params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            block(rspStatusAndMessage,error);

        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}


/**
 *
 * 获取订单列表信息
 *
 */
+ (void)getOrderInfoListWithPayType:(int)payType orderStatus:(NSString *)orderStatus queryStr:(NSString *)queryStr pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderListModel *orderListModel,NSError *error))block;
{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kBrandOrderList];
    
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kBrandOrderList params:nil];

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];

    [mutParameters setObject:@(pageIndex) forKey:@"pageIndex"];
    [mutParameters setObject:@(pageSize) forKey:@"pageSize"];
    
    //payType 和 orderStatus只会存在一个
    if(payType != -1){
        [mutParameters setObject:@(payType) forKey:@"payType"];
    }else{
        if(![orderStatus isEqualToString:@"-1"]){
            [mutParameters setObject:orderStatus forKey:@"orderStatus"];
        }
    }

    if(![NSString isNilOrEmpty:queryStr]){
        [mutParameters setObject:queryStr forKey:@"queryStr"];
    }

    NSDictionary *parameters = [mutParameters copy];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOrderListModel *orderListModel = [[YYOrderListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,orderListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取订单列表单条信息
 *
 */
+ (void)getOrderInfoListItemWithOrderCode:(NSString *)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderListItemModel *orderListItemModel,NSError *error))block;
{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderListItem];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderListItem params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode};
    NSData *body = [parameters mj_JSONData];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOrderListItemModel *orderListItemModel = [[YYOrderListItemModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,orderListItemModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}


/**
 *
 * 获取订单信息
 * isForReBuildOrder ---->获取订单信息是否为了重新创建订单
 */
+ (void)getOrderByOrderCode:(NSString *)orderCode isForReBuildOrder:(BOOL)isForReBuildOrder andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderInfoModel *orderInfoModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderInfo params:nil];

    NSDictionary *parameters = nil;
    if(isForReBuildOrder){
        parameters = @{
                       @"orderCode":orderCode
                       ,@"stock":@(true)
                       ,@"source":@(2)
                       ,@"check":@(false)
                       };
    }else{
        parameters = @{
                       @"orderCode":orderCode
                       ,@"stock":@(true)
                       };
    }
    NSData *body = [parameters mj_JSONData];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error && responseObject) {
            YYOrderInfoModel *orderInfoModel = [[YYOrderInfoModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,orderInfoModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取订单设置信息
 *
 */
+ (void)getOrderSettingInfoWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderSettingInfoModel *orderSettingInfoModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderSettingInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderSettingInfo params:nil];

    NSDictionary *parameters = @{@"checkedOnly":@"true"};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOrderSettingInfoModel *orderSettingInfoModel = [[YYOrderSettingInfoModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,orderSettingInfoModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

+ (void)getOrderUnitPrice:(NSUInteger)designerId moneyType:(NSInteger)moneyType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSUInteger orderUnitPrice,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderUnitPrice];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderUnitPrice params:nil];

    NSDictionary *parameters = @{@"designerId":@(designerId),@"curType":@(moneyType)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            NSUInteger data = [responseObject unsignedIntegerValue];
            block(rspStatusAndMessage,data,error);
            
        }else{
            block(rspStatusAndMessage,0,error);
        }
        
    }];
}

/**
 *
 * 创建或修改订单
 *
 */
+ (void)createOrModifyOrderByJsonData:(NSData *)jsonData actionRefer:(NSString*)actionRefer realBuyerId:(NSInteger)realBuyerId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSString *orderCode,NSError *error))block{
    // get URL
    NSString *actionName = nil;//@"create":@"modify"
    if([actionRefer isEqualToString:@"create"]){
        actionName = kOrderCreate;
        if(realBuyerId>0){
            actionName = [NSString stringWithFormat:@"%@?realBuyerId=%ld",actionName,(long)realBuyerId];
        }
    }else if([actionRefer isEqualToString:@"append"]){
        actionName = kOrderAppend;
        if(realBuyerId>0){
            actionName = [NSString stringWithFormat:@"%@?realBuyerId=%ld",actionName,(long)realBuyerId];
        }
    }else if([actionRefer isEqualToString:@"modify"]){
        actionName = kOrderModify;
        if(realBuyerId>0){
            actionName = [NSString stringWithFormat:@"%@?realBuyerId=%ld",actionName,(long)realBuyerId];
        }
    }else if([actionRefer isEqualToString:@"rebuild"]){
        actionName = kOrderModify;
        if(realBuyerId>0){
            actionName = [NSString stringWithFormat:@"%@?realBuyerId=%ld&reassociate=true",actionName,(long)realBuyerId];
        }else{
            actionName = [NSString stringWithFormat:@"%@?realBuyerId=0&reassociate=true",actionName];
        }

    }else{
        actionName = kOrderCreateOrModify;
    }
    
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:actionName];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:actionName params:nil];

    NSDictionary *parameters = [jsonData mj_JSONObject];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            block(rspStatusAndMessage,responseObject,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 创建或修改买家地址
 *
 */
+ (void)createOrModifyAddress:(YYAddress *)address orderCode:(NSString*)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYBuyerAddressModel *addressModel, NSError *error))block{

    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kAddOrModifyBuyerAddress];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kAddOrModifyBuyerAddress params:nil];

    NSString *_nationId  = @"";
    if([address.nationId integerValue]>0){
        _nationId = [[NSString alloc] initWithFormat:@"%ld",(long)[address.nationId integerValue]];
    }
    NSString *_provinceId  = @"";
    if([address.provinceId integerValue]>0){
        _provinceId = [[NSString alloc] initWithFormat:@"%ld",(long)[address.provinceId integerValue]];
    }
    NSString *_cityId = @"";
    if([address.cityId integerValue]>0){
        _cityId = [[NSString alloc] initWithFormat:@"%ld",(long)[address.cityId integerValue]];
    }
    
    NSString *_nation  = @"";
    if(![NSString isNilOrEmpty:address.nation]){
        if(![address.nation isEqualToString:@"-"]){
            _nation = address.nation;
        }
    }
    
    NSString *_province  = @"";
    if(![NSString isNilOrEmpty:address.province]){
        if(![address.province isEqualToString:@"-"]){
            _province = address.province;
        }
    }
    
    NSString *_city  = @"";
    if(![NSString isNilOrEmpty:address.city]){
        if(![address.city isEqualToString:@"-"]){
            _city = address.city;
        }
    }

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    [mutParameters setObject:_province forKey:@"province"];
    [mutParameters setObject:_city forKey:@"city"];
    [mutParameters setObject:address.receiverName forKey:@"receiverName"];
    [mutParameters setObject:address.receiverPhone forKey:@"receiverPhone"];
    [mutParameters setObject:address.detailAddress forKey:@"detailAddress"];
    [mutParameters setObject:address.zipCode forKey:@"zipCode"];
    [mutParameters setObject:_nation forKey:@"nation"];
    [mutParameters setObject:_nationId forKey:@"nationId"];
    [mutParameters setObject:_provinceId forKey:@"provinceId"];
    [mutParameters setObject:_cityId forKey:@"cityId"];
    if (address.addressId) {
        [mutParameters setObject:address.addressId forKey:@"addressId"];
    }

    if(orderCode != nil){
        [mutParameters setObject:orderCode forKey:@"orderCode"];
    }

    NSDictionary *parameters = [mutParameters copy];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        YYBuyerAddressModel *addressModel = [[YYBuyerAddressModel alloc] initWithDictionary:responseObject error:nil];
        block(rspStatusAndMessage,addressModel,error);
        
    }];

}

/**
 *
 * 上传图片
 *
 */
+ (void)uploadImage:(UIImage *)image size:(CGFloat)size andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSString *imageUrl,NSError *error))block{

    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUploadImage];

    [YYRequestHelp uploadImageWithUrl:requestURL image:image size:size andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
        block(rspStatusAndMessage,responseObject,error);
    }];
}

/**
 *
 * 上传图片 带进度
 *
 */
+ (void)uploadImage:(UIImage *)image size:(CGFloat)size sign:(NSString *)sign indexpath:(NSIndexPath *)indexpath uploadProgress:(void(^)(float uploadProgress, NSIndexPath *indexpath))uploadProgress andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSString *sign, NSIndexPath *indexpath, NSString *imageUrl, NSError *error))block{

    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUploadImage];

    [YYRequestHelp uploadImageWithUrl:requestURL image:image size:size progress:^(float progress) {
        if (uploadProgress) {
            uploadProgress(progress, indexpath);
        }
    } andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSString *imageUrl, NSError *error) {
        block(rspStatusAndMessage, sign, indexpath, imageUrl, error);
    }];
}

/**
 *
 * opType 取消订单1，恢复订单2，删除订单3
 *
 *
 */
+ (void)updateOrderWithOrderCode:(NSString *)orderCode opType:(int)opType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{

    // get URL
    NSString *actionName = nil;
    if (opType == 1) {
        YYUser *user = [YYUser currentUser];
        if(user.userType == kBuyerStorUserType){
            actionName = kBuyerCancelOrder;
        }else{
            actionName = kCancelOrder;
        }
        
    }else if (opType == 3) {
        actionName = kDeleteOrder_brand;
    }

    if(![NSString isNilOrEmpty:actionName]){
        NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:actionName];
        NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:actionName params:nil];

        NSDictionary *parameters = @{@"orderCode":orderCode};
        NSData *body = [parameters mj_JSONData];

        [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
            block(rspStatusAndMessage,error);
        }];
    }
}

/**
 *
 * 单个订单的操作记录(分页)
 *
 */
+ (void)getsingleOrderInfoDynamicsList:(NSString *)orderCode pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderOperateLogListModel *orderListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kGetSingleOrderInfoDynamics];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kGetSingleOrderInfoDynamics params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode,@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOrderOperateLogListModel *logListModel = [[YYOrderOperateLogListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,logListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 *获取通知消息列表
 *
 */
+ (void)getNotifyMsgList:(NSString *)msgType pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderMessageInfoListModel *msgListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kGetNotifyMsgList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kGetNotifyMsgList params:nil];

    NSDictionary *parameters = @{@"msgType":msgType,@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOrderMessageInfoListModel *msgListModel = [[YYOrderMessageInfoListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,msgListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];

}

/**
 *
 *未读消息条数查询
 *
 */
+ (void)getUnreadNotifyMsgAmount:(NSString *)msgType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, YYMessageUnreadModel *messageUnreadModel, NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kGetUnreadNotifyMsgAmount];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kGetUnreadNotifyMsgAmount params:nil];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error && responseObject) {
            YYMessageUnreadModel *unreadModel = [[YYMessageUnreadModel alloc] initWithDictionary:responseObject error:nil];
        block(rspStatusAndMessage, unreadModel, error);
        }else{
            block(rspStatusAndMessage, nil, error);
        }
        
    }];
}
/**
 *
 *买手操作订单关联请求
 *
 */
+ (void)setOpWithOrderConn:(NSString *)orderCode opType:(NSInteger)opType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kopWithOrderConn];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kopWithOrderConn params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode,@"opType":@(opType)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
        
    }];
}

/**
 *
 *标记同一类型通知消息为已读
 *
 */
+ (void)markAsRead:(NSInteger)msgType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kMarkAsRead];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kMarkAsRead params:nil];

    NSDictionary *parameters = @{@"msgType":@(msgType)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}


/**
 *
 *获取某个订单的分享状态信息
 *
 */
+ (void)getOrderConnStatus:(NSString *)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderConnStatusModel* statusModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kGetorderConnStatus];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kGetorderConnStatus params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode};
    NSData *body = [parameters mj_JSONData];

    __block NSString *blockOrderCode = orderCode;
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && (NSNull *)responseObject != [NSNull null]) {
            YYOrderConnStatusModel *statusModel = [[YYOrderConnStatusModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,statusModel,error);
            
        }else{
            YYOrderConnStatusModel *statusModel = [[YYOrderConnStatusModel alloc] init];
            statusModel.status = [[NSNumber alloc] initWithInteger:kOrderStatus];//;
            statusModel.orderCode = blockOrderCode;
            block(rspStatusAndMessage,statusModel,error);
        }
        
    }];
}

/**
 *
 *更新订单流转状态
 *
 */
+ (void)updateTransStatus:(NSString *)orderCode  statusCode:(NSInteger)statusCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *actionName = nil;

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    [mutParameters setObject:orderCode forKey:@"orderCode"];

    if(statusCode == kOrderCode_DELIVERY){
        actionName = kDesignerSendOut;
    }else{
        actionName = kUpdateTransStatus;
        [mutParameters setObject:@(statusCode) forKey:@"statusCode"];
    }
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:actionName];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:actionName params:nil];

    NSDictionary *parameters = [mutParameters copy];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

/**
 *
 *当前订单流转状态
 *
 */
+ (void)getOrderTransStatus:(NSString *)orderCode  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderTransStatusModel* transStatusModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kCrtTransStatus];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kCrtTransStatus params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYOrderTransStatusModel *statusModel = [[YYOrderTransStatusModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,statusModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 *添加付款（收款）记录
 *
 */
+ (void)addPaymentNote:(NSString *)orderCode  percent:(NSInteger)percent amount:(float)amount andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kAddPaymentNote];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kAddPaymentNote params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode,@"percent":@(percent),@"amount":@(amount)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

/**
 *
 *订单收款记录
 *
 */
+ (void)getPaymentNoteList:(NSString *)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYPaymentNoteListModel *noteList,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kPaymentNoteList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kPaymentNoteList params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYPaymentNoteListModel *noteListModel = [[YYPaymentNoteListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,noteListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}


/**
 *
 *关闭订单请求(买手,设计师)
 *
 */
+ (void)setOrderCloseRequest:(NSString *)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderCloseRequest];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderCloseRequest params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

/**
 *
 *处理关闭订单请求(买手,设计师)
 *
 */
+ (void)dealOrderCloseRequest:(NSString *)orderCode isAgree:(NSString*)isAgree andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kDealOrderCloseRequest];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kDealOrderCloseRequest params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode,@"isAgree":isAgree};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

/**
 *
 *撤销关闭订单请求(买手,设计师)
 *
 */
+ (void)revokeOrderCloseRequest:(NSString *)orderCode  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kRevokeOrderCloseRequest];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kRevokeOrderCloseRequest params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}
/**
 *
 *款式是否过期
 *
 */
+ (void)isStyleModify:(NSString *)styleMap  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderStyleModifyReslutModel *styleModifyReslut,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kIsStyleModify];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kIsStyleModify params:nil];

    NSDictionary *parameters = @{@"styleMap":styleMap};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYOrderStyleModifyReslutModel *styleModifyReslutModel = [[YYOrderStyleModifyReslutModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,styleModifyReslutModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}

/**
 *
 *查看对方是否订单关闭
 *
 */
+ (void)getOrderCloseStatus:(NSString *)orderCode  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSInteger isclose,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderCloseStatus];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderCloseStatus params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,[responseObject integerValue],error);
        }else{
            block(rspStatusAndMessage,0,error);
        }
    }];
}

/**
 *
 *关闭订单
 *
 */
+ (void)closeOrder:(NSString *)orderCode  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kCloseOrder];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kCloseOrder params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}
/**
 *
 *开启或关闭补货
 *
 */
+ (void)getOrderSimpleStyleList:(NSString *)orderCode  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOrderSimpleStyleList *styleList,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderSimpleStyleList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderSimpleStyleList params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYOrderSimpleStyleList *simpleStyleList = [[YYOrderSimpleStyleList alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,simpleStyleList,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}

/**
 *
 *追单初始化创建
 *
 */
+ (void)appendOrder:(YYOrderAppendParamModel *)model  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSString *orderCode,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderPreAppend_brand];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderPreAppend_brand params:nil];

    NSDictionary *parameters = [model toDescription];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            NSString *orderCode = responseObject;
            block(rspStatusAndMessage,orderCode,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}


/**
 *
 *废弃付款记录
 *
 */
+ (void)discardPayment:(NSInteger )payId  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kPaymentDiscard];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kPaymentDiscard params:nil];

    NSDictionary *parameters = @{@"id":@(payId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

/**
 *
 *确认付款记录
 *
 */
+ (void)confirmPayment:(NSInteger )payId  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kPaymentConfirm];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kPaymentConfirm params:nil];

    NSDictionary *parameters = @{@"id":@(payId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}

/**
 *
 *删除付款记录
 *
 */
+ (void)deletePayment:(NSInteger )payId  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kPaymentDelete];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kPaymentDelete params:nil];

    NSDictionary *parameters = @{@"id":@(payId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
    }];
}
@end
