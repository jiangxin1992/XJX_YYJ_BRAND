//
//  YYOpusApi.m
//  Yunejian
//
//  Created by yyj on 15/7/23.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOpusApi.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "RequestMacro.h"
#import "YYRequestHelp.h"
#import "YYHttpHeaderManager.h"

#import "YYStyleInfoModel.h"
#import "YYBrandHomeInfoModel.h"
#import "YYOpusStyleListModel.h"
#import "YYOpusSeriesListModel.h"
#import "YYSeriesInfoDetailModel.h"
#import "YYOpusSeriesAuthTypeBuyerListModel.h"

@implementation YYOpusApi
/**
 *
 * 分享系列
 *
 */
+ (void)sendlineSheetWithHomePageModel:(YYBrandHomeInfoModel *)homePageMode withSeriesId:(NSInteger)seriesId withEmail:(NSString *)email andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kSeriesLineSheet];
    
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kSeriesLineSheet params:nil];


    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    [mutParameters setObject:email forKey:@"email"];
    [mutParameters setObject:@(seriesId) forKey:@"seriesId"];

    //0 邮箱, 4 固定电话 1 电话, 3 微信号, 2 QQ,
    //    NSInteger idx=contactType==0?0:contactType==1?2:contactType==2?3:contactType==3?4:contactType==4?2:-1;
    if(homePageMode.userContactInfos){
        if(homePageMode.userContactInfos.count){
            for (int i=0; i<homePageMode.userContactInfos.count; i++) {
                YYBuyerContactInfoModel *obj = [homePageMode.userContactInfos objectAtIndex:i];
                if(![YYOpusApi isNilOrEmptyWithContactValue:obj.contactValue WithContactType:obj.contactType]){
                    NSInteger number = [obj.contactType integerValue];
                    NSString *valueStr = obj.contactValue;
                    if(number==0){
                        //                        brandEmail = valueStr;
                        [mutParameters setObject:valueStr forKey:@"brandEmail"];
                    }else if(number==1){
                        //                        phone = valueStr;
                        [mutParameters setObject:valueStr forKey:@"phone"];
                    }else if(number==2){
                        //                        qq = valueStr;
                        [mutParameters setObject:valueStr forKey:@"qq"];
                    }else if(number==3){
                        //                        weChat = valueStr;
                        [mutParameters setObject:valueStr forKey:@"weChat"];
                    }else if(number==4){
                        //                        tel = valueStr;
                        [mutParameters setObject:valueStr forKey:@"tel"];
                    }
                }
            }
        }
    }
    

    NSDictionary *parameters = [mutParameters copy];
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

+(BOOL)isNilOrEmptyWithContactValue:(NSString *)contactValue WithContactType:(NSNumber *)contactType
{
    if([NSString isNilOrEmpty:contactValue])
    {
        return YES;
    }else
    {
        if([contactType integerValue] == 1)
        {
            //移动电话
            NSArray *teleArr = [contactValue componentsSeparatedByString:@" "];
            if(teleArr.count>1)
            {
                if(![NSString isNilOrEmpty:teleArr[1]])
                {
                    return NO;
                }else
                {
                    return YES;
                }
            }
            return YES;
        }else if([contactType integerValue] == 4)
        {
            //固定电话
            NSArray *tempphoneArr = [contactValue componentsSeparatedByString:@" "];
            if(tempphoneArr.count>1)
            {
                if(![NSString isNilOrEmpty:tempphoneArr[1]])
                {
                    NSArray *phoneArr = [tempphoneArr[1] componentsSeparatedByString:@"-"];
                    NSString *vauleStr = [phoneArr componentsJoinedByString:@""];
                    if(![NSString isNilOrEmpty:vauleStr])
                    {
                        return NO;
                    }
                    return YES;
                }else
                {
                    return YES;
                }
            }
            return YES;
        }
        return NO;
    }
}
/**
 *
 * 判断是否存在多币种
 *
 */
+ (void)hasMultiCurrencyWithSeriesId:(NSInteger)seriesId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,BOOL hasMultiCurrency,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kStyleHasMultiCurrency];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kStyleHasMultiCurrency params:nil];

    NSDictionary *parameters = @{@"seriesId":@(seriesId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            BOOL _hasMultiCurrency = [responseObject boolValue];
            block(rspStatusAndMessage,_hasMultiCurrency,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取设计师系列列表
 *
 */
+ (void)getSeriesListWithId:(int)designerId pageIndex:(int)pageIndex pageSize:(int)pageSize withDraft:(NSString*)draft andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOpusSeriesListModel *opusSeriesListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kSeriesList_brand];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kSeriesList_brand params:nil];

    NSDictionary *parameters = @{@"designerId":@(designerId),@"pageIndex":@(pageIndex),@"pageSize":@(pageSize),@"withDraft":draft};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOpusSeriesListModel *opusSeriesListModel = [[YYOpusSeriesListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,opusSeriesListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取款式详情
 *
 */
+ (void)getStyleInfoByStyleId:(long)styleId orderCode:(NSString*)orderCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYStyleInfoModel *styleInfoModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kStyleInfo];
    
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kStyleInfo params:nil];

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    [mutParameters setObject:@(styleId) forKey:@"styleId"];
    if(orderCode){
        [mutParameters setObject:orderCode forKey:@"orderCode"];
    }

    NSDictionary *parameters = [mutParameters copy];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYStyleInfoModel *styleInfoModel = [[YYStyleInfoModel alloc] initWithDictionary:responseObject error:nil];
            styleInfoModel.style.styleDescription = [responseObject valueForKeyPath:@"style.description"];
            block(rspStatusAndMessage,styleInfoModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取设计师系列列表
 *
 */
+ (void)getSeriesListWithOrderCode:(NSString*)orderCode pageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOpusSeriesListModel *opusSeriesListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kBuyerAvailableSeries];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kBuyerAvailableSeries params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode,@"pageIndex":@(pageIndex),@"pageSize":@(pageSize),@"withDraft":@"false"};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOpusSeriesListModel *opusSeriesListModel = [[YYOpusSeriesListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,opusSeriesListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 买手修改订单可用的款式
 *
 */
+ (void)getStyleListWithOrderCode:(NSString*)orderCode seriesId:(long)seriesId orderBy:(NSString *)orderBy queryStr:(NSString *)queryStr pageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOpusStyleListModel *opusStyleListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kBuyerAvailableStyles];
    
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kBuyerAvailableStyles params:nil];

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    [mutParameters setValue:orderCode forKey:@"orderCode"];
    [mutParameters setValue:@(pageIndex) forKey:@"pageIndex"];
    [mutParameters setValue:@(pageSize) forKey:@"pageSize"];

    if (seriesId > 0) {
        [mutParameters setValue:@(seriesId) forKey:@"seriesId"];
    }
    
    if (orderBy
        && [orderBy length] > 0) {
        [mutParameters setValue:orderBy forKey:@"orderBy"];
    }
    
    if(![queryStr isEqualToString:@""]){
        [mutParameters setValue:queryStr forKey:@"queryStr"];
    }
    NSDictionary *parameters = [mutParameters copy];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOpusStyleListModel *opusStyleListModel = [[YYOpusStyleListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,opusStyleListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}

/**
 *
 *合作设计师的系列列表
 *
 */
+ (void)getConnSeriesListWithId:(int)designerId pageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOpusSeriesListModel *opusSeriesListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kConnSeriesList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kConnSeriesList params:nil];

    NSDictionary *parameters = @{@"designerId":@(designerId),@"pageIndex":@(pageIndex),@"pageSize":@(pageSize),@"withDraft":@"false"};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOpusSeriesListModel *opusSeriesListModel = [[YYOpusSeriesListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,opusSeriesListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}
/**
 *
 *设计师自己的系列列表
 *
 */
+ (void)getBrandSeriesListWithPageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOpusSeriesListModel *opusSeriesListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kSeriesList_brand];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kSeriesList_brand params:nil];

    NSDictionary *parameters = @{@"pageIndex":@(pageIndex),@"pageSize":@(pageSize),@"withDraft":@"false"};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOpusSeriesListModel *opusSeriesListModel = [[YYOpusSeriesListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,opusSeriesListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 *合作设计师系列详情
 *
 */
+ (void)getConnSeriesInfoWithId:(NSInteger )designerId seriesId:(NSInteger )seriesId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYSeriesInfoDetailModel *infoDetailModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kConnSeriesInfo_brand];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kConnSeriesInfo_brand params:nil];

    NSDictionary *parameters = @{@"designerId":@(designerId),@"seriesId":@(seriesId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            NSError *error = nil;
            YYSeriesInfoDetailModel *infoDetailModel = [[YYSeriesInfoDetailModel alloc] initWithDictionary:responseObject error:nil];
            infoDetailModel.brandDescription = [[responseObject objectForKey:@"series"] objectForKey:@"description"];
            if(![[responseObject objectForKey:@"lookBookId"] isKindOfClass:[NSNull class]]){
                infoDetailModel.series.lookBookId = [responseObject objectForKey:@"lookBookId"];
            }
            block(rspStatusAndMessage,infoDetailModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 合作设计师款式列表（带搜索）
 *
 */
+ (void)getConnStyleListWithDesignerId:(NSInteger )designerId seriesId:(NSInteger )seriesId orderBy:(NSString *)orderBy queryStr:(NSString *)queryStr pageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOpusStyleListModel *opusStyleListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kConnStyleList_brand];
    
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kConnStyleList_brand params:nil];

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    [mutParameters setObject:@(designerId) forKey:@"designerId"];
    [mutParameters setObject:@(pageIndex) forKey:@"pageIndex"];
    [mutParameters setObject:@(pageSize) forKey:@"pageSize"];

    if (seriesId > 0) {
        [mutParameters setObject:@(seriesId) forKey:@"seriesId"];
    }
    
    if (orderBy
        && [orderBy length] > 0) {
        [mutParameters setObject:orderBy forKey:@"orderBy"];
    }
    
    if(![queryStr isEqualToString:@""]){
        [mutParameters setObject:queryStr forKey:@"queryStr"];
    }

    NSDictionary *parameters = [mutParameters copy];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOpusStyleListModel *opusStyleListModel = [[YYOpusStyleListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,opusStyleListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];

}

/**
 *
 * 更改系列权限
 *
 */
+ (void)updateSeriesAuthType:(long)seriesId authType:(NSInteger)authType buyerIds:(NSString*)buyerIds andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUpdateSeriesAuthType_brand];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kUpdateSeriesAuthType_brand params:nil];

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];

    [mutParameters setObject:@(seriesId) forKey:@"seriesId"];
    [mutParameters setObject:@(authType) forKey:@"authType"];
    if(![NSString isNilOrEmpty:buyerIds]){
        [mutParameters setObject:buyerIds forKey:@"buyerIds"];
    }
    NSDictionary *parameters = [mutParameters copy];
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
 *设计师系列详情
 *
 */
+ (void)getSeriesInfo:(NSInteger )seriesId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYSeriesInfoDetailModel *infoDetailModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kSeriesInfo_brand];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kSeriesInfo_brand params:nil];

    NSDictionary *parameters = @{@"seriesId":@(seriesId)};
    NSData *body = [parameters mj_JSONData];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYSeriesInfoDetailModel *infoDetailModel = [[YYSeriesInfoDetailModel alloc] initWithDictionary:responseObject error:nil];
            infoDetailModel.brandDescription = [[responseObject objectForKey:@"series"] objectForKey:@"description"];
            block(rspStatusAndMessage,infoDetailModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 *更改系列发布状态与权限
 *
 */
+ (void)updateSeriesPubStatus:(NSInteger)seriesId status:(NSInteger)status authType:(NSString*)authType buyerIds:(NSString*)buyerIds andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUpdateSeriesPubStatus];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kUpdateSeriesPubStatus params:nil];

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    [mutParameters setValue:@(seriesId) forKey:@"seriesId"];
    [mutParameters setValue:@(status) forKey:@"status"];
    [mutParameters setValue:authType forKey:@"authType"];
    if(![NSString isNilOrEmpty:buyerIds]){
        [mutParameters setValue:buyerIds forKey:@"buyerIds"];
    }
    NSDictionary *parameters = [mutParameters copy];
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
 *获取系列发布权限名单
 *
 */
+ (void)getSeriesAuthTypeBuyerList:(NSInteger)seriesId  authType:(NSString*)authType andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYOpusSeriesAuthTypeBuyerListModel * buyerList,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kGetSeriesAuthBuyers];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kGetSeriesAuthBuyers params:nil];

    NSDictionary *parameters = @{@"seriesId":@(seriesId),@"authType":authType};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYOpusSeriesAuthTypeBuyerListModel *listModel = [[YYOpusSeriesAuthTypeBuyerListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,listModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}
@end
