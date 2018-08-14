//
//  YYRequestHelp.m
//  Yunejian
//
//  Created by yyj on 15/7/3.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYRequestHelp.h"
#import "AFNetworking.h"
#import "UserDefaultsMacro.h"
#import "YYRspStatusAndMessage.h"
#import "YYUserApi.h"

#import "YYUser.h"
#import "YYSubShowroomUserPowerModel.h"

#import "regular.h"
#import "YYShowroomApi.h"
#import "RequestMacro.h"
#import "MJExtension.h"
#import "YYHttpHeaderManager.h"

#import <Qiniu/QiniuSDK.h>



#define kNetworkTimeout 50

#define kMaxReRequestFor402 5
static int requestGet402Count = 0;

typedef NS_ENUM(NSInteger, RequestType)
{
    RequestTypeGET,
    RequestTypePOST,
    RequestTypePUT,
    RequestTypeDELETE
};


@implementation YYRequestHelp
#pragma mark - 网络请求
+ (void )POST:(NSDictionary *)headers requestUrl:(NSString *)requestUrl requestCount:(int)requestCount requestBody:(NSData *)requestBody andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block
{
    //网络状态监测
    if (![YYCurrentNetworkSpace isNetwork]) {
        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        block(nil,nil, nil, nil);
        return;
    }

    id parameters = [self getParametersByRequestBody:requestBody];
    //获取初始化 manager 并设置请求头
    AFHTTPSessionManager *manager = [YYRequestHelp getInitManagerWithHeaders:headers WithRequestUrl:requestUrl];

    [manager POST:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if(response) {
            [self NETWorkingSuccess:RequestTypePOST requestUrl:requestUrl headers:headers requestCount:requestCount requestBody:requestBody Response:response WithResponseObject:responseObject WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
                block(rspStatusAndMessage,responseObject, error, httpResponse);
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        [self NETWorkingFailure:requestUrl headers:headers Response:response error:error parameters:parameters WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
            block(rspStatusAndMessage,responseObject, error, httpResponse);
        }];

    }];
}

+ (void )GET:(NSDictionary *)headers requestUrl:(NSString *)requestUrl requestCount:(int)requestCount requestBody:(NSData *)requestBody andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block
{
    //网络状态监测
    if (![YYCurrentNetworkSpace isNetwork]) {
        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        block(nil,nil, nil, nil);
        return;
    }

    id parameters = [self getParametersByRequestBody:requestBody];
    //获取初始化 manager 并设置请求头
    AFHTTPSessionManager *manager = [YYRequestHelp getInitManagerWithHeaders:headers WithRequestUrl:requestUrl];

    [manager GET:requestUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if(response)
        {
            [self NETWorkingSuccess:RequestTypeGET requestUrl:requestUrl headers:headers requestCount:requestCount requestBody:requestBody Response:response WithResponseObject:responseObject WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
                block(rspStatusAndMessage,responseObject, error, httpResponse);
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        [self NETWorkingFailure:requestUrl headers:headers Response:response error:error parameters:parameters WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
            block(rspStatusAndMessage,responseObject, error, httpResponse);
        }];

    }];
}
+ (void )PUT:(NSDictionary *)headers requestUrl:(NSString *)requestUrl requestCount:(int)requestCount requestBody:(NSData *)requestBody andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block
{
    //网络状态监测
    if (![YYCurrentNetworkSpace isNetwork]) {
        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        block(nil,nil, nil, nil);
        return;
    }

    id parameters = [self getParametersByRequestBody:requestBody];
    //获取初始化 manager 并设置请求头
    AFHTTPSessionManager *manager = [YYRequestHelp getInitManagerWithHeaders:headers WithRequestUrl:requestUrl];

    [manager PUT:requestUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if(response)
        {
            [self NETWorkingSuccess:RequestTypePUT requestUrl:requestUrl headers:headers requestCount:requestCount requestBody:requestBody Response:response WithResponseObject:responseObject WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
                block(rspStatusAndMessage,responseObject, error, httpResponse);
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        [self NETWorkingFailure:requestUrl headers:headers Response:response error:error parameters:parameters WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
            block(rspStatusAndMessage,responseObject, error, httpResponse);
        }];
    }];
}
+ (void )DELETE:(NSDictionary *)headers requestUrl:(NSString *)requestUrl requestCount:(int)requestCount requestBody:(NSData *)requestBody andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block
{
    //网络状态监测
    if (![YYCurrentNetworkSpace isNetwork]) {
        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        block(nil,nil, nil, nil);
        return;
    }

    id parameters = [self getParametersByRequestBody:requestBody];
    //获取初始化 manager 并设置请求头
    AFHTTPSessionManager *manager = [YYRequestHelp getInitManagerWithHeaders:headers WithRequestUrl:requestUrl];

    [manager DELETE:requestUrl parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if(response)
        {
            [self NETWorkingSuccess:RequestTypeDELETE requestUrl:requestUrl headers:headers requestCount:requestCount requestBody:requestBody Response:response WithResponseObject:responseObject WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
                block(rspStatusAndMessage,responseObject, error, httpResponse);
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        [self NETWorkingFailure:requestUrl headers:headers Response:response error:error parameters:parameters WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError *error, id httpResponse) {
            block(rspStatusAndMessage,responseObject, error, httpResponse);
        }];

    }];
}
#pragma mark - SomeAction
+ (void)NETWorkingFailure:(NSString *)requestUrl headers:(NSDictionary *)headers Response:(NSHTTPURLResponse *)response error:(NSError *)error parameters:(id )parameters WithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block{

    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];

    NETLog(@"----------Http请求----------\n");
    NETLog(@"----------Http请求Headers：%@", headers);

    NETLog(@"----------Http请求Body：%@", parameters);

    NETLog(@"----------Http请求Url：%@", requestUrl);

    NETLog(@"----------Http响应----------\n");

    NETLog(@"----------Http响应error：%@",error);

    if(errorData){
        NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
        NETLog(@"----------Http响应serializedData：%@",serializedData);
        YYRspStatusAndMessage *rspStatusAndMessage = [[YYRspStatusAndMessage alloc] init];
        rspStatusAndMessage.message = [serializedData objectForKey:@"message"];
        rspStatusAndMessage.status = (int)[[serializedData objectForKey:@"status"] integerValue];
        block(rspStatusAndMessage,nil, error, response);
    }else{
        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        block(nil,nil, error, response);
    }
}
+ (void)NETWorkingSuccess:(RequestType )requestType requestUrl:(NSString *)requestUrl headers:(NSDictionary *)headers requestCount:(int)requestCount requestBody:(NSData *)requestBody Response:(NSHTTPURLResponse *)response  WithResponseObject:(id  _Nullable)responseObject WithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block{

    NSDictionary *responseHeaders = response.allHeaderFields;

    NETLog(@"----------Http请求----------\n");
    NETLog(@"----------Http请求Headers：%@", headers);

    id parameters = [self getParametersByRequestBody:requestBody];

    NETLog(@"----------Http请求Body：%@", parameters);

    NETLog(@"----------Http请求Url：%@", requestUrl);

    NETLog(@"----------Http响应----------\n");
    NETLog(@"----------Http响应Rsp：%@", response);
    NETLog(@"----------Http响应Body：%@", (NSDictionary *)responseObject);


    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [responseHeaders objectForKey:@"token"];

    if ([requestUrl containsString:kShowroomToBrand]||[requestUrl containsString:kGetShowroomBrandToken]) {
        //showroom到品牌 获取品牌信息
        if (token) {
            [userDefaults setObject:token forKey:kTempUserLoginTokenKey];
        }
    }else if ([requestUrl containsString:kShowroomBrandToShowroom]){
        //品牌到showroom
        if (token) {
            [userDefaults setObject:token forKey:kUserLoginTokenKey];
        }
    }else
    {
        if (token) {
            [userDefaults setObject:token forKey:kUserLoginTokenKey];
        }
    }

    NSString *scrt = [responseHeaders objectForKey:@"scrt"];
    if (scrt) {
        [userDefaults setObject:scrt forKey:kScrtKey];
    }

    [userDefaults synchronize];

    NSError *currentError = nil;


    if ([requestUrl rangeOfString:kCaptcha].location != NSNotFound) {
        block(nil,responseObject, currentError, response);
    }else{
        NSDictionary *jsonObject = (NSDictionary *)responseObject;
        YYRspStatusAndMessage *rspStatusAndMessage = nil;
        if (jsonObject) {
            rspStatusAndMessage = [[YYRspStatusAndMessage alloc] init];
            NSString *message = [jsonObject objectForKey:@"message"];
            rspStatusAndMessage.message = message;

            NSNumber *status = [jsonObject objectForKey:@"status"];
            if (status) {
                rspStatusAndMessage.status = status.intValue;
            }

            if ((!message || [message length] <= 0 )
                && status) {
                rspStatusAndMessage.message = [NSString stringWithFormat:@"错误码为: %i",status.intValue];
            }


            //需要重新登录
            if (rspStatusAndMessage.status == YYReqStatusCode402
                ) {
                if(requestGet402Count != 0){//重新获取toke
                    block(nil,nil, currentError, response);
                    return ;
                }
                [YYRequestHelp increaseOrDecreaseRequestGet402Count:YES];
                int currentRequestCount = requestCount + 1;
                if(currentRequestCount >= kMaxReRequestFor402)
                {
                    if([YYUser isShowroomToBrand])
                    {
                        [YYUser removeTempUser];
                    }
                    //遇到无限循环，原因未知，所以添加请求次数限制来避免
                    rspStatusAndMessage.status = -1;
                    rspStatusAndMessage.message = @"请重新登录";
                    [YYRequestHelp increaseOrDecreaseRequestGet402Count:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNeedLoginNotification object:nil];
                    return ;
                }

                YYUser *user = [YYUser currentUser];
                if([YYUser isShowroomToBrand])
                {
                    //品牌重新登录
                    [YYShowroomApi getShowroomToBrandToken:^(YYRspStatusAndMessage *rspStatusAndMessage, YYUserModel *userModel, NSError *error) {
                        if (rspStatusAndMessage
                            && (rspStatusAndMessage.status == YYReqStatusCode100 || rspStatusAndMessage.status == YYReqStatusCode1000)) {
                            [YYRequestHelp increaseOrDecreaseRequestGet402Count:NO];
                            NSMutableDictionary *headDic = [[NSMutableDictionary alloc] initWithDictionary:headers];

                            NSString *tokenValue = [userDefaults objectForKey:kTempUserLoginTokenKey];

                            if (tokenValue) {
                                [headDic setObject:tokenValue forKey:@"token"];
                            }

                            if(requestType == RequestTypePOST){
                                [YYRequestHelp POST:headDic
                                                   requestUrl:requestUrl
                                                 requestCount:currentRequestCount
                                                  requestBody:requestBody
                                                     andBlock:block];
                            }else if(requestType == RequestTypeDELETE){
                                [YYRequestHelp DELETE:headDic
                                                           requestUrl:requestUrl
                                                         requestCount:currentRequestCount
                                                          requestBody:requestBody
                                                             andBlock:block];
                            }else{
                                [YYRequestHelp GET:headDic
                                                   requestUrl:requestUrl
                                                 requestCount:currentRequestCount
                                                  requestBody:requestBody
                                                     andBlock:block];
                            }

                        }else{
                            [YYRequestHelp increaseOrDecreaseRequestGet402Count:NO];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNeedLoginNotification object:nil];

                        }
                    }];
                }else if (user.email && user.password) {
                    [YYUserApi loginWithUsername:user.email password:md5(user.password) verificationCode:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYUserModel *userModel, NSError *error) {
                        if (rspStatusAndMessage
                            && (rspStatusAndMessage.status == YYReqStatusCode100 || rspStatusAndMessage.status == YYReqStatusCode1000)) {
                            [YYRequestHelp increaseOrDecreaseRequestGet402Count:NO];
                            NSMutableDictionary *headDic = [[NSMutableDictionary alloc] initWithDictionary:headers];

                            NSString *tokenValue = [userDefaults objectForKey:kUserLoginTokenKey];

                            if (tokenValue) {
                                [headDic setObject:tokenValue forKey:@"token"];
                            }

                            [LanguageManager setLanguageToServer];

                            if(requestType == RequestTypePOST){
                                [YYRequestHelp POST:headDic
                                                   requestUrl:requestUrl
                                                 requestCount:currentRequestCount
                                                  requestBody:requestBody
                                                     andBlock:block];
                            }else if(requestType == RequestTypeDELETE){
                                [YYRequestHelp DELETE:headDic
                                                           requestUrl:requestUrl
                                                         requestCount:currentRequestCount
                                                          requestBody:requestBody
                                                             andBlock:block];
                            }else{
                                [YYRequestHelp GET:headDic
                                                   requestUrl:requestUrl
                                                 requestCount:currentRequestCount
                                                  requestBody:requestBody
                                                     andBlock:block];
                            }

                            // 获取subshowroom的权限列表, 首先是判断showroom子账号
                            if (user.userType == YYUserTypeShowroomSub) {
                                [YYShowroomApi selectSubShowroomPowerUserId:[NSNumber numberWithInteger:[user.userId integerValue]] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSArray *powerArray, NSError *error) {
                                    YYSubShowroomUserPowerModel *subShowroom = [YYSubShowroomUserPowerModel shareModel];
                                    for (NSNumber *i in powerArray) {
                                        if ([i intValue] == 1) {
                                            subShowroom.isBrandAction = YES;
                                        }
                                    }
                                    
                                }];
                            }

                        }else{
                            [YYRequestHelp increaseOrDecreaseRequestGet402Count:NO];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNeedLoginNotification object:nil];

                        }
                    }];
                }else{
                    [YYRequestHelp increaseOrDecreaseRequestGet402Count:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNeedLoginNotification object:nil];
                }
            }else{
                id dataDic = [jsonObject objectForKey:@"data"];
                //                        NSString *value = [dataDic objectForKey:@"toMainPage"];
                //审核功能 老版本(1.2)没
                if ([requestUrl rangeOfString:kLogin].location != NSNotFound) {
                    //登录接口
                    if(rspStatusAndMessage.status == YYReqStatusCode100 &&[dataDic objectForKey:@"toMainPage"] != nil){
                        NSString *toMainPage = (NSString *)[dataDic objectForKey:@"toMainPage"];
                        if([toMainPage intValue]>0){
                            id expireDate = [dataDic objectForKey:@"expireDate"];
                            if(expireDate == 0 ||(NSNull *)expireDate == [NSNull null]){
                                rspStatusAndMessage.status = YYReqStatusCode100;
                            }else{
                                rspStatusAndMessage.status = YYReqStatusCode1000;
                                rspStatusAndMessage.message =  getShowDateByFormatAndTimeInterval(NSLocalizedString(@"请在30天内完成品牌信息，未验证的品牌账号将被锁定（yyyy/MM/dd）",nil),[NSString stringWithFormat:@"%@",expireDate]);
                            }
                        }
                    }
                }


                block(rspStatusAndMessage,dataDic, currentError, response);
            }
        }else{

            currentError = [NSError errorWithDomain:@"com.yyj" code:9009 userInfo:@{@"message":@"平台没有下发任何数据错误"}];
            block(nil,nil, currentError, response);
        }
    }
}

+ (void)increaseOrDecreaseRequestGet402Count:(BOOL)isIncrease{
    @synchronized(self){
        if (isIncrease) {
            requestGet402Count++;
        }else{
            requestGet402Count = 0;
        }
    }
}

+(AFHTTPSessionManager *)getInitManagerWithHeaders:(NSDictionary *)headers WithRequestUrl:(NSString *)requestUrl{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //    如果你还想进一步保障的话 在你封装的地方加上这个代码    //新增IPv6
    //    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];

    if ([requestUrl rangeOfString:kOrderCreate].location != NSNotFound
        || [requestUrl rangeOfString:kOrderModify].location != NSNotFound
        || [requestUrl rangeOfString:kOrderAppend].location != NSNotFound
        || [requestUrl rangeOfString:kBrandInfoUpdate_buyer].location != NSNotFound
        || [requestUrl rangeOfString:kBrandInfoUpdate_brand].location != NSNotFound
        || [requestUrl rangeOfString:kSaveParcel].location != NSNotFound
        || [requestUrl rangeOfString:kSaveDeliverPackage].location != NSNotFound) {
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }

    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];

    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书

    manager.securityPolicy.validatesDomainName = NO;//是否验证域名

    for (NSString *key in headers)
    {
        NSString *value = [headers objectForKey:key];
        [manager.requestSerializer setValue:value forHTTPHeaderField:key];
    }

    return manager;
}

+(AFHTTPSessionManager *)getInitManagerWithRequestUrl:(NSString *)requestUrl{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    //    如果你还想进一步保障的话 在你封装的地方加上这个代码    //新增IPv6
    //    manager.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil];

    if ([requestUrl rangeOfString:kOrderCreate].location != NSNotFound
        || [requestUrl rangeOfString:kOrderModify].location != NSNotFound
        || [requestUrl rangeOfString:kOrderAppend].location != NSNotFound
        || [requestUrl rangeOfString:kBrandInfoUpdate_buyer].location != NSNotFound
        || [requestUrl rangeOfString:kBrandInfoUpdate_brand].location != NSNotFound
        || [requestUrl rangeOfString:kSaveParcel].location != NSNotFound
        || [requestUrl rangeOfString:kSaveDeliverPackage].location != NSNotFound) {
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }


    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];

    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书

    manager.securityPolicy.validatesDomainName = NO;//是否验证域名

    return manager;
}

+ (id )getParametersByRequestBody:(NSData *)requestBody{
    return [requestBody mj_JSONObject];
}
#pragma mark - 上传图片
// 带进度的上传图片
+ (void)uploadImageWithUrl:(NSString *)url
                     image:(UIImage *)image
                      size:(CGFloat )size
                  progress:(void(^)(float percent))progress
                  andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSString *imageUrl, NSError *error))block {

    [YYRequestHelp getUploadTokenWithType:@"yej-tb-ufile" WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSString *UploadToken, NSString *Key,NSString *pathType,NSError *error) {
        if(UploadToken){
            // 上传图片
            NSData *imageData = [regular getImageForSize:size WithImage:image];

            QNUploadManager *upManager = [[QNUploadManager alloc] init];

            QNUploadOption *op = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                if (progress) {
                    progress(percent);
                }
            } params:nil checkCrc:NO cancellationSignal:nil];

            [upManager putData:imageData key:Key token:UploadToken complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if(resp[@"key"]){
                    [YYRequestHelp UploadQiniuKey:resp[@"key"] WithType:pathType WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSString *imageUrl, NSError *error) {
                        block(rspStatusAndMessage, imageUrl, error);
                    }];
                }else{
                    block(nil,nil,nil);
                }
            } option:op];
        }
    }];
}

+(void)UploadQiniuKey:(NSString *)key WithType:(NSString *)type WithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSString *imageUrl,NSError *error))block
{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUploadKey];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:@"" params:@{@"type":type, @"key":key}];

    //    //获取初始化 manager 并设置请求头
    AFHTTPSessionManager *manager = [YYRequestHelp getInitManagerWithRequestUrl:requestURL];

    [manager POST:requestURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *jsonObject = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            jsonObject = (NSDictionary *)responseObject;
        }
        YYRspStatusAndMessage *rspStatusAndMessage = nil;
        if (jsonObject) {
            rspStatusAndMessage = [[YYRspStatusAndMessage alloc] init];
            NSString *message = [jsonObject objectForKey:@"message"];
            rspStatusAndMessage.message = message;

            NSNumber *status = [jsonObject objectForKey:@"status"];
            if (status) {
                rspStatusAndMessage.status = status.intValue;
            }

            if ((!message || [message length] <= 0 )
                && status) {
                rspStatusAndMessage.message = [NSString stringWithFormat:@"错误码为: %i",status.intValue];
            }
        }
        if (responseObject) {
            block(rspStatusAndMessage,[jsonObject objectForKey:@"data"],nil);
        }else{
            block(rspStatusAndMessage,nil,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        block(nil,nil, error);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];

        NETLog(@"----------Http请求----------\n");

        NETLog(@"----------Http响应----------\n");

        NETLog(@"----------Http响应error：%@",error);

        if(errorData){
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NETLog(@"----------Http响应serializedData：%@",serializedData);
            YYRspStatusAndMessage *rspStatusAndMessage = [[YYRspStatusAndMessage alloc] init];
            rspStatusAndMessage.message = [serializedData objectForKey:@"message"];
            rspStatusAndMessage.status = (int)[[serializedData objectForKey:@"status"] integerValue];
            block(rspStatusAndMessage,nil, error);
        }else{
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            block(nil,nil, error);
        }
    }];
}

+(void)getUploadTokenWithType:(NSString *)uploadType WithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSString *UploadToken,NSString *key,NSString *pathType, NSError *error))block
{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kGetToken];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kGetToken params:@{@"type":uploadType}];

    //    //获取初始化 manager 并设置请求头
    AFHTTPSessionManager *manager = [YYRequestHelp getInitManagerWithRequestUrl:requestURL];

    [manager POST:requestURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *jsonObject = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            jsonObject = (NSDictionary *)responseObject;
        }
        YYRspStatusAndMessage *rspStatusAndMessage = nil;
        if (jsonObject) {
            rspStatusAndMessage = [[YYRspStatusAndMessage alloc] init];
            NSString *message = [jsonObject objectForKey:@"message"];
            rspStatusAndMessage.message = message;

            NSNumber *status = [jsonObject objectForKey:@"status"];
            if (status) {
                rspStatusAndMessage.status = status.intValue;
            }

            if ((!message || [message length] <= 0 )
                && status) {
                rspStatusAndMessage.message = [NSString stringWithFormat:@"错误码为: %i",status.intValue];
            }
        }
        if (responseObject) {
            NSDictionary *data=[jsonObject objectForKey:@"data"];
            block(rspStatusAndMessage,[data objectForKey:@"token"],[data objectForKey:@"key"],[data objectForKey:@"type"],nil);
        }else{
            block(rspStatusAndMessage,nil,nil,nil,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        block(nil,nil,nil,nil,error);
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];

        NETLog(@"----------Http请求----------\n");

        NETLog(@"----------Http响应----------\n");

        NETLog(@"----------Http响应error：%@",error);

        if(errorData){
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NETLog(@"----------Http响应serializedData：%@",serializedData);
            YYRspStatusAndMessage *rspStatusAndMessage = [[YYRspStatusAndMessage alloc] init];
            rspStatusAndMessage.message = [serializedData objectForKey:@"message"];
            rspStatusAndMessage.status = (int)[[serializedData objectForKey:@"status"] integerValue];
            block(rspStatusAndMessage,nil,nil,nil,error);
        }else{
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            block(nil,nil,nil,nil,error);
        }
    }];
    return;
}


// 上传图片
+ (AFHTTPRequestOperation *)uploadImageWithUrl:(NSString *)url
                                         image:(UIImage *)image
                                          size:(CGFloat )size
                                      andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, id responseObject, NSError* error, id httpResponse))block {


    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];

    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {

        NSData *imageData = [regular getImageForSize:size WithImage:image];

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];

        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"myfiles" fileName:fileName mimeType:@"image/jpeg"];

    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *jsonObject = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            jsonObject = (NSDictionary *)responseObject;
        }

        YYRspStatusAndMessage *rspStatusAndMessage = nil;
        if (jsonObject) {
            rspStatusAndMessage = [[YYRspStatusAndMessage alloc] init];
            NSString *message = [jsonObject objectForKey:@"message"];
            rspStatusAndMessage.message = message;

            NSNumber *status = [jsonObject objectForKey:@"status"];
            if (status) {
                rspStatusAndMessage.status = status.intValue;
            }

            if ((!message || [message length] <= 0 )
                && status) {
                rspStatusAndMessage.message = [NSString stringWithFormat:@"错误码为: %i",status.intValue];
            }
        }


        id dataDic = [jsonObject objectForKey:@"data"];
        block(rspStatusAndMessage,dataDic, nil, response);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        //        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        //        block(nil,nil, error, response);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];

        NETLog(@"----------Http请求----------\n");

        NETLog(@"----------Http响应----------\n");

        NETLog(@"----------Http响应error：%@",error);

        if(errorData){
            NSDictionary *serializedData = [NSJSONSerialization JSONObjectWithData:errorData options:kNilOptions error:nil];
            NETLog(@"----------Http响应serializedData：%@",serializedData);
            YYRspStatusAndMessage *rspStatusAndMessage = [[YYRspStatusAndMessage alloc] init];
            rspStatusAndMessage.message = [serializedData objectForKey:@"message"];
            rspStatusAndMessage.status = (int)[[serializedData objectForKey:@"status"] integerValue];
            block(rspStatusAndMessage,nil, error, response);
        }else{
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            block(nil,nil, error, response);
        }
    }];
    return nil;
}

@end
