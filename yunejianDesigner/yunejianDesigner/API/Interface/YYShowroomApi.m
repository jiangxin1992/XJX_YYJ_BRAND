//
//  YYShowroomApi.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomApi.h"

#import "YYShowroomBrandListModel.h"
#import "YYShowroomHomePageModel.h"
#import "YYShowroomOrderingListModel.h"
#import "YYShowroomOrderingCheckListModel.h"
#import "YYHttpHeaderManager.h"
#import "YYRequestHelp.h"
#import "RequestMacro.h"
#import "UserDefaultsMacro.h"
#import "YYUser.h"
#import "YYShowroomInfoByDesignerModel.h"

@implementation YYShowroomApi
/**
 *
 * sr订货会权限查询(调用权限：仅showroom_sub)
 *
 */
+ (void)hasPermissionToVisitOrderingWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,BOOL hasPermission,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:KGetShowroomPermissionToOrdering];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:KGetShowroomPermissionToOrdering params:nil];

    NSDictionary *parameters = @{@"auth":@(5)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {

            block(rspStatusAndMessage,[((NSDictionary *)responseObject)[@"result"] boolValue],error);

        }else{
            block(rspStatusAndMessage,NO,error);
        }
    }];
}
/**
 *
 * sr订货会是否有消息
 *
 */
+ (void)hasOrderingMsgWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,BOOL hasMsg,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:KGetShowroomHasOrderingMsg];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:KGetShowroomHasOrderingMsg params:nil];

    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            block(rspStatusAndMessage,[responseObject boolValue],error);

        }else{
            block(rspStatusAndMessage,NO,error);
        }
    }];
}
/**
 *
 * 清空sr订货会消息
 *
 */
+ (void)clearOrderingMsgWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:KGetShowroomHasOrderingMsg];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:KGetShowroomHasOrderingMsg params:nil];

    [YYRequestHelp DELETE:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
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
 * sr订货会列表
 *
 */
+ (void)getOrderingListWithPageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomOrderingListModel *showroomOrderingListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:KGetShowroomOrderingList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:KGetShowroomOrderingList params:nil];

    NSDictionary *parameters = @{@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYShowroomOrderingListModel * showroomOrderingListModel = [[YYShowroomOrderingListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,showroomOrderingListModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}
/**
 *
 * 预约列表
 *
 */
+ (void)getOrderingCheckListWithAppointmentId:(NSNumber *)appointmentId status:(NSString *)status PageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomOrderingCheckListModel *showroomOrderingCheckListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:KGetShowroomOrderingCheckList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:KGetShowroomOrderingCheckList params:nil];

    NSDictionary *parameters = nil;
    if(![NSString isNilOrEmpty:status]){
        parameters = @{@"appointmentId":appointmentId,@"status":status,@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    }else{
        parameters = @{@"appointmentId":appointmentId,@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    }
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            YYShowroomOrderingCheckListModel * showroomOrderingCheckListModel = [[YYShowroomOrderingCheckListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,showroomOrderingCheckListModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}/**
  *
  * 预约申请审核 通过
  *
  */
+ (void)agreeOrderingApplicationWithIds:(NSString *)ids andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:KGetShowroomOrderingCheckList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:KGetShowroomOrderingCheckList params:nil];

    NSDictionary *parameters = @{@"ids":ids,@"to":@"VERIFIED"};
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
 * 预约申请审核 拒绝
 *
 */
+ (void)refuseOrderingApplicationWithIds:(NSString *)ids andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:KGetShowroomOrderingCheckList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:KGetShowroomOrderingCheckList params:nil];

    NSDictionary *parameters = @{@"ids":ids,@"to":@"REJECTED"};
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
 * 是否有权限访问该款式
 *
 */
+ (void)hasPermissionToVisitStyleWithStyleId:(NSInteger)styleId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,BOOL hasPermission,NSNumber *brandId,NSError *error))block{

    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:KGetShowroomPermissionToVisitStyle];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:KGetShowroomPermissionToVisitStyle params:nil];

    NSDictionary *parameters = @{@"styleId":@(styleId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            block(rspStatusAndMessage,YES,responseObject,error);

        }else{
            block(rspStatusAndMessage,NO,nil,error);
        }

    }];
}
/**
 * 品牌页面中token失效处理
 */
+ (void)getShowroomToBrandToken:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYUserModel *userModel,NSError *error))block
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    YYUser *user = [YYUser currentUser];
    NSString *showroomId = user.userId;
    NSString *brandId = [userDefaults objectForKey:kTempBrandID];
    
    if(brandId&&showroomId)
    {
        NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kGetShowroomBrandToken];
        NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kGetShowroomBrandToken params:nil];

        NSDictionary *parameters = @{@"showroomId":showroomId,@"brandId":brandId};
        NSData *body = [parameters mj_JSONData];

        [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
            if (!error
                && responseObject) {
                YYUserModel *rspDataModel = [[YYUserModel alloc] initWithDictionary:responseObject error:nil];
                block(rspStatusAndMessage,rspDataModel,error);
                
            }else{
                block(rspStatusAndMessage,nil,error);
            }}
         ];
    }
}
/**
 * 品牌到showroom
 */
+ (void)brandToShowroomBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYUserModel *userModel,NSError *error))block
{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kShowroomBrandToShowroom];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kShowroomBrandToShowroom params:nil];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            [YYUser removeTempUser];
            YYUserModel *rspDataModel = [[YYUserModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,rspDataModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }}
     ];
}
/**
 * showroom到品牌
 */
+ (void)showroomToBrandWithBrandID:(NSNumber *)brandID andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYUserModel *userModel,NSError *error))block
{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kShowroomToBrand];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kShowroomToBrand params:nil];

    NSDictionary *parameters = @{@"brandId":brandID};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYUserModel *rspDataModel = [[YYUserModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,rspDataModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }}
     ];
 }
//获取Showroom首页信息
+ (void)getShowroomBrandListWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomBrandListModel *brandListModel,NSError *error))block
{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kShowroomList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kShowroomList params:nil];

    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            NSLog(@"111");
            YYShowroomBrandListModel * brandlistmodel = [[YYShowroomBrandListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,brandlistmodel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}

+ (void)getShowroomHomePageInfoWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomHomePageModel *ShowroomHomePageModel,NSError *error))block
{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kShowroomHomePageInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kShowroomHomePageInfo params:nil];

    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            NSLog(@"111");
            YYShowroomHomePageModel * homepageModel = [[YYShowroomHomePageModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,homepageModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}

/**
 *
 * 停用或启用销售代表
 *
 */
+ (void)updateSubShowroomStatusWithId:(NSInteger)userId status:(NSInteger)status andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestUrl = nil;
    if(status){
        //停用
        requestUrl = kShowroomUpdateSalesmanStatusOFF;
    }else{
        //启用
        requestUrl = kShowroomUpdateSalesmanStatusON;
    }
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:requestUrl];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:requestUrl params:nil];

    NSDictionary *parameters = @{@"subId":@(userId)};
    NSData *body = [parameters mj_JSONData];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        block(rspStatusAndMessage,error);
        
    }];
}
/**
 *
 * 新建subshowroom账号
 *
 */
+ (void)createSubShowroomWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSNumber *userId, NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kShowroomAddSalesman];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kShowroomAddSalesman params:nil];

    NSDictionary *parameters = @{@"name":username,@"email":email,@"passWord":password};
    NSData *body = [parameters mj_JSONData];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {

        block(rspStatusAndMessage, responseObject, error);
        
    }];
}

/**
 *
 * 添加／修改showroom子账号权限
 *
 */
+ (void)subShowroomPowerUserId:(NSNumber *)userId authList:(NSArray *)authList andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kShowroomCreateOrUpdatePower];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kShowroomAddSalesman params:nil];

    NSString *auth = [authList componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"userId":userId,@"authList":auth};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {

        block(rspStatusAndMessage, error);
        
    }];
}
/**
 *
 * 查询showroom子账号权限
 *
 */
+ (void)selectSubShowroomPowerUserId:(NSNumber *)userId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSArray *powerArray, NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kSubShowroomCreatePower];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kShowroomAddSalesman params:nil];

    NSDictionary *parameters = @{@"userId":userId};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {


        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:responseObject];
        NSArray *power = dict[@"result"];
        NSMutableArray *powerArray = [NSMutableArray array];
        for (NSDictionary *dicts in power) {
            if ([dicts[@"checked"] intValue] == YES) {
                [powerArray addObject:[NSString stringWithFormat:@"%@", dicts[@"id"]]];
            }
        }

        block(rspStatusAndMessage, powerArray, error);

    }];
}


/**
 *
 * 删除showroom子账号
 *
 */
+ (void)deleteNotActiveSubShowroomUserId:(NSNumber *)userId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kShowroomDeleteNotActive];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kShowroomAddSalesman params:nil];

    NSDictionary *parameters = @{@"userId":userId};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        block(rspStatusAndMessage,error);
        
    }];
}

/**
 * 根据设计师获取showroom用户
 */
+ (void)getShowroomInfoByDesigner:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomInfoByDesignerModel *showroomInfoByDesignerModel,NSError *error))block
{
    YYUser *user = [YYUser currentUser];
    
    if(user.userType == 0||user.userType == 2)
    {
        NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kGetShowroomInfoByDesigner];
        NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kGetShowroomInfoByDesigner params:nil];

        NSDictionary *parameters = @{@"designerId":user.userId};
        NSData *body = [parameters mj_JSONData];

        [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
            if (!error
                && responseObject) {
                //AGREE已同意，代理中 INIT待同意
                YYShowroomInfoByDesignerModel *rspDataModel = [[YYShowroomInfoByDesignerModel alloc] initWithDictionary:responseObject error:nil];
                block(rspStatusAndMessage,rspDataModel,error);
                
            }else{
                block(rspStatusAndMessage,nil,error);
            }
        }];
    }
}
@end
