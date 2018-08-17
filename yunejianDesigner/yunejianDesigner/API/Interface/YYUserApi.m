//
//  YYUserApi.m
//  Yunejian
//
//  Created by yyj on 15/7/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYUserApi.h"
#import "YYRequestHelp.h"
#import "RequestMacro.h"
#import "UserDefaultsMacro.h"
#import "YYHttpHeaderManager.h"
#import "YYUser.h"

#import "YYUserModel.h"
#import "YYRspStatusAndMessage.h"
#import "YYDesignerModel.h"
#import "YYBrandInfoModel.h"
#import "YYBuyerStoreModel.h"
#import "YYSalesManListModel.h"
#import "YYLookBookModel.h"
#import "YYBrandIntroductionModel.h"
#import "YYLookBookListModel.h"
#import "YYBuyerHomeInfoModel.h"
#import "YYBrandHomeInfoModel.h"
#import "YYShowroomInfoModel.h"
#import "MJExtension.h"
@implementation YYUserApi

/**
 *
 * 用户登录
 * @param username  用户名
 * @param password  密码
 * @param verificationCode  验证码（非必填）
 *
 */
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password  verificationCode:(NSString *)verificationCode andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYUserModel *userModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kLogin];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kLogin params:nil];

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    [mutParameters setObject:username forKey:@"email"];
    [mutParameters setObject:password forKey:@"password"];
    [mutParameters setObject:@"tbPhoneDesignerApp" forKey:@"type"];
    if (verificationCode
        && [verificationCode length] > 0) {
        [mutParameters setObject:verificationCode forKey:@"captcha"];
    }
    NSDictionary *parameters = [mutParameters copy];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYUserModel *rspDataModel = [[YYUserModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,rspDataModel,error);

        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}


/**
 *
 * 获取验证码
 *
 */
+ (void)getCaptchaWithBlock:(void (^)(NSData *imageData,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kCaptcha];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kCaptcha params:nil];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        NSData *nsdataFromBase64String = nil;
        if(responseObject != nil){
            NSDictionary *jsonObject = (NSDictionary *)responseObject;
            NSString *imgBase64String =[jsonObject objectForKey:@"data"];
            if(imgBase64String){
                nsdataFromBase64String = [[NSData alloc]initWithBase64EncodedString:imgBase64String options:0];
            }
        }
        block(nsdataFromBase64String,error);
    }];

}

/**
 *
 * 获取设计师个人信息
 *
 */
+ (void)getDesignerBasicInfoWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYDesignerModel *designerModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kDesignerBasicInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kDesignerBasicInfo params:nil];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYDesignerModel *designerModel = [[YYDesignerModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,designerModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}


/**
 *
 * 获取品牌信息
 *
 */
+ (void)getDesignerBrandInfoWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYBrandInfoModel *brandInfoModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kDesignerBrandInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kDesignerBrandInfo params:nil];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYBrandInfoModel *brandInfoModel = [[YYBrandInfoModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,brandInfoModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}
/**
 *
 * 获取Showroom信息
 *
 */
+ (void)getShowroomInfoWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomInfoModel *ShowroomModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kShowroomInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kShowroomInfo params:nil];
    
    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYShowroomInfoModel *ShowroomModel = [[YYShowroomInfoModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,ShowroomModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取买手店个人信息
 *
 */
+ (void)getBuyerStorBasicInfoWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYBuyerStoreModel *BuyerStoreModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kBuyerStorBasicInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kBuyerStorBasicInfo params:nil];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYBuyerStoreModel *BuyerStoreModel = [[YYBuyerStoreModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,BuyerStoreModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取销售代表列表
 *
 */
+ (void)getSalesManListWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYSalesManListModel *salesManListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kSalesManList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kSalesManList params:nil];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYSalesManListModel *salesManListModel = [[YYSalesManListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,salesManListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}
+ (void)getSalesManListWithBlockNew:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYSalesManListModel *salesManListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kSalesManListNew];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kSalesManListNew params:nil];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYSalesManListModel *salesManListModel = [[YYSalesManListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,salesManListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取收货地址列表
 *
 */
+ (void)getAddressListWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYAddressListModel *addressListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kAddressList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kAddressList params:nil];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYAddressListModel *addressListModel = [[YYAddressListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,addressListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 买家-删除地址
 *
 */
+ (void)deleteAddress:(NSInteger)addressId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kDeleteAddress];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kDeleteAddress params:nil];

    NSDictionary *parameters = @{@"addressId":@(addressId)};
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
 * 修改密码
 *
 */
+ (void)passwdUpdateWithOldPassword:(NSString *)oldPassword nowPassword:(NSString *)nowPassword andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kPasswdUpdate];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kPasswdUpdate params:nil];

    NSDictionary *parameters = @{@"oldPassword":oldPassword,@"newPassword":nowPassword};
    NSData *body = [parameters mj_JSONData];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {

            block(rspStatusAndMessage,error);
    
    }];
}

/**
 *
 * 修改买家用户名或电话
 *
 */
+ (void)updateBuyerUsername:(NSString *)username phone:(NSString *)phone province:(NSString *)province city:(NSString *)city andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUpdateBuyerUsernameOrPhone];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kUpdateBuyerUsernameOrPhone params:nil];

    NSDictionary *parameters = @{@"name":username,@"phone":phone,@"province":province,@"city":city};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        block(rspStatusAndMessage,error);
        
    }];
}

/**
 *
 * 修改设计师用户名或电话
 *
 */
+ (void)updateDesignerUsername:(NSString *)username phone:(NSString *)phone andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUpdateDesignerUsernameOrPhone];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kUpdateDesignerUsernameOrPhone params:nil];

    NSDictionary *parameters = @{@"userName":username,@"phone":phone};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        block(rspStatusAndMessage,error);
        
    }];
}

/**
 *
 * 新建销售代表
 *
 */
+ (void)createSellerWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kaddSalesman];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kaddSalesman params:nil];

    NSDictionary *parameters = @{@"name":username,@"email":email,@"password":password};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        block(rspStatusAndMessage,error);
        
    }];
}

/**
 *
 * 修改设计师品牌信息
 *
 */
+ (void)brandInfoUpdateByBrandName:(NSString *)brandName webUrl:(NSString *)webUrl underLinePartnerCount:(int)underLinePartnerCount annualSales:(float)annualSales retailerName:(NSString *)retailerName andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kBrandInfoUpdate_brand];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kBrandInfoUpdate_brand params:nil];

    NSDictionary *parameters = @{@"brandName":brandName,@"webUrl":webUrl,@"underlinePartnerCount":@(underLinePartnerCount),@"annualSales":@(annualSales),@"retailerName":retailerName};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        block(rspStatusAndMessage,error);
        
    }];
}

/**
 *
 * 修改买家店铺信息
 *
 */
+ (void)storeUpdateByBuyerStoreModel:(YYBuyerStoreModel *)BuyerStoreModel andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kStoreUpdate];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kStoreUpdate params:nil];

    NSDictionary *parameters = @{@"name":BuyerStoreModel.name,@"foundYear":BuyerStoreModel.foundYear,@"businessBrands":objArrayToJSON(BuyerStoreModel.businessBrands),@"priceMin":BuyerStoreModel.priceMin,@"priceMax":BuyerStoreModel.priceMax};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        block(rspStatusAndMessage,error);
        
    }];
}

/**
 *
 * 添加或修改收货地址
 *
 */
+ (void)createOrModifyAddress:(YYAddress *)address andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = @"";
    NSDictionary *dic = nil;
    
    NSString *_nationId  = @"";
    if([address.nationId integerValue]>0){
        _nationId = [[NSString alloc] initWithFormat:@"%ld",[address.nationId integerValue]];
    }
    NSString *_provinceId  = @"";
    if([address.provinceId integerValue]>0){
        _provinceId = [[NSString alloc] initWithFormat:@"%ld",[address.provinceId integerValue]];
    }
    NSString *_cityId = @"";
    if([address.cityId integerValue]>0){
        _cityId = [[NSString alloc] initWithFormat:@"%ld",[address.cityId integerValue]];
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
    [mutParameters setObject:address.defaultShipping?@"true":@"false" forKey:@"default"];
    [mutParameters setObject:_nation forKey:@"nation"];
    [mutParameters setObject:_nationId forKey:@"nationId"];
    [mutParameters setObject:_provinceId forKey:@"provinceId"];
    [mutParameters setObject:_cityId forKey:@"cityId"];
    if (address.addressId) {
        requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kModifyAddress];
        dic = [YYHttpHeaderManager buildHeadderWithAction:kModifyAddress params:nil];

        [mutParameters setObject:address.addressId forKey:@"addressId"];

    }else{
        requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kAddAddress];
        dic = [YYHttpHeaderManager buildHeadderWithAction:kAddAddress params:nil];
    }
    NSDictionary *parameters = [mutParameters copy];
    NSData *body = [parameters mj_JSONData];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        block(rspStatusAndMessage,error);
        
    }];
}

/**
 *
 * 用户反馈
 *
 */
+ (void)userFeedBack:(NSString *)content andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kSubmitFeedback];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kSubmitFeedback params:nil];

    NSDictionary *parameters = @{@"content":content};
    NSData *body = [parameters mj_JSONData];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        block(rspStatusAndMessage,error);
        
    }];
}

/**
 *
 * lookBook详情
 *
 */
+ (void)getLookBookInfoWithId:(NSInteger)LookBookId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYLookBookModel *lookBookModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kLookBookInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kLookBookInfo params:nil];

    NSDictionary *parameters = @{@"lookBookId":@(LookBookId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYLookBookModel *lookBookModel = [[YYLookBookModel alloc] initWithDictionary:[responseObject objectForKey:@"lookBook"] error:nil];
            lookBookModel.picUrls = [responseObject objectForKey:@"pics"];
            block(rspStatusAndMessage,lookBookModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 更改头像 logo
 *
 */
+(void)modifyLogoWithUrl:(NSString *)url andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    YYUser *user = [YYUser currentUser];
    NSString *urlstr = @"";
    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    if(user.userType == 5||user.userType == 6)
    {
        [mutParameters setObject:url forKey:@"logo"];
        urlstr = kShowroomModifyLogoInfo;
    }else
    {
        [mutParameters setObject:url forKey:@"logoPath"];
        urlstr = kModifyLogoInfo;
    }
    
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:urlstr];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:urlstr params:nil];

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

///**
// *
// * 设计师注册
// *
// */
+(void)registerDesignerWithData:(NSArray *)data andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kRegisterDesigner];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kRegisterDesigner params:nil];

    NSDictionary *integrationData = [self integrationWithData:data];
    NSData *body = [integrationData mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            block(rspStatusAndMessage,error);
        }else{
            block(rspStatusAndMessage,error);
        }
        
    }];
}
+(NSDictionary *)integrationWithData:(NSArray *)data{
    NSMutableArray *realdata = [data mutableCopy];
    NSString *paramsCountryCodeValue = @"";
    NSString *paramsPhoneValue = @"";
    NSInteger paramsCountryCodeIndex = 0;
    NSInteger paramsPhoneIndex = 0;
    BOOL paramsCountryCodeIsExist = NO;
    BOOL paramsPhoneIsExist = NO;
    for (int i = 0; i < realdata.count; i ++ ) {
        NSString *paramsStr = realdata[i];
        NSArray *tempArr = [paramsStr componentsSeparatedByString:@"="];
        if(tempArr.count>1){
            if([tempArr[0] isEqualToString:@"countryCode"]){
                NSArray *tempArr1 = [tempArr[1] componentsSeparatedByString:@" "];
                if(tempArr1.count){
                    paramsCountryCodeIndex = i;
                    paramsCountryCodeIsExist = YES;
                    paramsCountryCodeValue = tempArr1[0];
                }
            }else if([tempArr[0] isEqualToString:@"phone"]){
                paramsPhoneIndex = i;
                paramsPhoneIsExist = YES;
                paramsPhoneValue = tempArr[1];
            }
        }
    }
    if(paramsCountryCodeIndex > paramsPhoneIndex){
        if(paramsCountryCodeIsExist){
            [realdata removeObjectAtIndex:paramsCountryCodeIndex];
        }
        if(paramsPhoneIsExist){
            [realdata removeObjectAtIndex:paramsPhoneIndex];
        }
    }else{
        if(paramsPhoneIsExist){
            [realdata removeObjectAtIndex:paramsPhoneIndex];
        }
        if(paramsCountryCodeIsExist){
            [realdata removeObjectAtIndex:paramsCountryCodeIndex];
        }
    }
    
    if(paramsPhoneIsExist&&paramsCountryCodeIsExist){
        //整合
        NSString *tempPhoneParamsStr = [[NSString alloc] initWithFormat:@"phone=%@ %@",paramsCountryCodeValue,paramsPhoneValue];
        [realdata addObject:tempPhoneParamsStr];
    }

    NSDictionary *parameters = [self getDataWithArr:[realdata copy]];

    return parameters;
}
/**
 *
 * 买手注册
 *
 */
+(void)registerBuyerWithData:(NSArray *)data andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kRegisterBuyer];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kRegisterBuyer params:nil];

    NSDictionary *parameters = [self getDataWithArr:data];
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
+(NSDictionary *)getDataWithArr:(NSArray *)array{
    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    for (NSString *paramsStr in array) {
        NSArray *tempArr = [paramsStr componentsSeparatedByString:@"="];
        if(tempArr.count > 1){
            [mutParameters setObject:tempArr[1] forKey:tempArr[0]];
        }
    }
    return [mutParameters copy];
}
/**
 *
 * 买手店提交审核信息
 *
 */
+(void)checkBuyerWithData:(NSArray *)data andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{

    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUploadCertInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kUploadCertInfo params:nil];

    NSDictionary *parameters = [self getDataWithArr:data];
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
 * 买手店更新审核信息
 *
 */
+(void)updateBuyerWithData:(NSData *)data andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{

    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUpdateCertInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kUpdateCertInfo params:nil];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:data andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
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
 * 发送订单到邮箱
 *
 */
+(void)sendOrderByMail:(NSString *)email andCode:(NSString *)orderCode andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kSendOrderByMail];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kSendOrderByMail params:nil];

    NSDictionary *parameters = @{@"email":email,@"orderCode":orderCode};
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
 * 重发账户邮件确认邮件
 *
 */
+(void)reSendMailConfirmMail:(NSString *)email andUserType:(NSString *)type andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kReSendMailConfirmMail];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kReSendMailConfirmMail params:nil];

    NSDictionary *parameters = @{@"email":email,@"userType":type};
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
 * 上传品牌审核文件
 *
 */
+(void) uploadBrandFiles:(NSString *)brandFiles andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSInteger errorCode,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUploadBrandFiles];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kUploadBrandFiles params:nil];
    
    NSDictionary *parameters = @{@"brandFiles":brandFiles};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error) {
            NSInteger errorCode = kCode100;
            if([responseObject objectForKey:@"data"] != nil){
                errorCode =[[responseObject objectForKey:@"data"] integerValue];
            }
            block(rspStatusAndMessage,errorCode,error);
        }else{
            block(rspStatusAndMessage,kCode203,error);
        }
        
    }];
}

/**
 *
 * 按条件查询所有买手店
 *
 */
+(void) queryBuyer:(NSString *)queryStr andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,YYBuyerListModel *buyerList,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kBuyerList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kBuyerList params:nil];

    NSDictionary *parameters = @{@"queryStr":queryStr};
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


/**
 *
 * 获取收货地址列表
 *
 */
+ (void)getAddressListWithID:(NSInteger)buyerId pageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYBuyerAddressListModel *addressListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kBuyerAddressList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kBuyerAddressList params:nil];

    NSDictionary *parameters = @{@"buyerId":@(buyerId),@"pageIndex":@(pageIndex),@"pageSize":@(pageSize)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYBuyerAddressListModel *addressListModel = [[YYBuyerAddressListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,addressListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

+ (void)getAddressListWithPageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYBuyerAddressListModel *addressListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kAddressList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kAddressList params:nil];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYBuyerAddressListModel *addressListModel = [[YYBuyerAddressListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,addressListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 设计师查询买手店详情
 *
 */
+ (void)getBuyerDetailInfoWithID:(NSInteger)buyerId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYBuyerDetailModel *buyerModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kBuyerPubInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kBuyerPubInfo params:nil];

    NSDictionary *parameters = @{@"buyerId":@(buyerId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYBuyerDetailModel *buyerModel = [[YYBuyerDetailModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,buyerModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 首页品牌介绍
 *
 */
+ (void)getHomePageBrandInfo:(NSInteger)designerId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYHomePageModel *homePageModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kHomePageInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kHomePageInfo params:nil];

    NSDictionary *parameters = @{@"designerId":@(designerId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYHomePageModel *homePageModel = [[YYHomePageModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,homePageModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}
/**
 *
 * 订单品牌介绍
 *
 */
+ (void)getOrderDesignerInfoBrandInfo:(NSString *)orderCode designerId:(NSInteger)designerId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYHomePageModel *homePageModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kOrderDesignerInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kOrderDesignerInfo params:nil];

    NSDictionary *parameters = @{@"orderCode":orderCode,@"designerId":@(designerId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYHomePageModel *homePageModel = [[YYHomePageModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,homePageModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
    }];
}

/**
 *
 * 首页图集
 *
 */
+ (void)getHomePagePics:(NSInteger)designerId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYIndexPicsModel *picsModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kHomePageIndexPics];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kHomePageIndexPics params:nil];

    NSDictionary *parameters = @{@"designerId":@(designerId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYIndexPicsModel *picsModel = [[YYIndexPicsModel alloc] initWithDictionary:responseObject error:nil];
            
            block(rspStatusAndMessage,picsModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 更新产品介绍
 *
 */
+(void)updateBrandWithData:(NSArray *)data andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{

    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kHomeUpdateBrandInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kHomeUpdateBrandInfo params:nil];

    NSDictionary *parameters = [self getDataWithArr:data];
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
+(void)updateBrandWithDataDict:(NSDictionary *)params andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kBrandInfoUpdate_brand];
    NSDictionary *headParams = [YYHttpHeaderManager buildHeadderWithAction:kBrandInfoUpdate_brand params:nil];

    NSData *body = [params mj_JSONData];

    [YYRequestHelp POST:headParams requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
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
 * 新建（修改）首页图集
 *
 */
+(void)updateHomePagePicsWithData:(NSArray *)data andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{

    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kHomeUpdateIndexPics];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kHomeUpdateIndexPics params:nil];

    NSDictionary *parameters = @{@"pics":[data componentsJoinedByString:@","]};
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
 *忘记密码
 *
 */
+(void)forgetPassword:(NSString *)email andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kForgetPassword];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kForgetPassword params:nil];

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    NSArray *tempArr = [email componentsSeparatedByString:@"="];
    if(tempArr.count > 1){
        [mutParameters setObject:tempArr[1] forKey:tempArr[0]];
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
 * 停用或启用销售代表
 *
 */
+ (void)updateSalesmanStatusWithId:(NSInteger)userId status:(NSInteger)status andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUpdateSalesmanStatuse];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kUpdateSalesmanStatuse params:nil];

    NSDictionary *parameters = @{@"salesmanId":@(userId),@"opType":@(status)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        
        block(rspStatusAndMessage,error);
        
    }];
}

/**
 *
 * 用户状态
 *
 */
+(void)getUserStatus:(NSInteger)userId andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage, NSInteger status,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kUserStatus];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kUserStatus params:nil];

    NSData *body =nil;
    if(userId >-1){
        NSDictionary *parameters = @{@"userId":@(userId)};
        body = [parameters mj_JSONData];
    }
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            NSInteger status = [responseObject integerValue];
            block(rspStatusAndMessage,status,error);
        }else{
            block(rspStatusAndMessage,-1,error);
        }
        
    }];
}

/**
 *
 * 已发布新闻列表
 *
 */
+(void)getNewsList:(NSInteger)type pageIndex:(int)pageIndex pageSize:(int)pageSize andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage, YYNewsListModel *listModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kNewsList];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kNewsList params:nil];

    NSMutableDictionary *mutParameters = [[NSMutableDictionary alloc] init];
    [mutParameters setObject:@(pageIndex) forKey:@"pageIndex"];
    [mutParameters setObject:@(pageSize) forKey:@"pageSize"];
    if(type >-1){
        [mutParameters setObject:@(type) forKey:@"type"];
    }
    NSDictionary *parameters = [mutParameters copy];
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYNewsListModel *listModel = [[YYNewsListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,listModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}
/**
 *
 * 买手店首页信息
 *
 */
+(void)getBuyerHomeInfo:(NSString *)buyerId andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage, YYBuyerHomeInfoModel *infoModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kBuyerHomeInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kBuyerHomeInfo params:nil];

    NSDictionary *parameters = @{@"buyerId":buyerId};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYBuyerHomeInfoModel *infoModel = [[YYBuyerHomeInfoModel alloc] initWithDictionary:responseObject error:nil];
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            if(infoModel.storeImgs)
            {
                if(infoModel.storeImgs.count)
                {
                    [infoModel.storeImgs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if(![NSString isNilOrEmpty:obj])
                        {
                            [tempArr addObject:obj];
                        }
                    }];
                }
            }
            infoModel.storeImgs = [tempArr copy];
            block(rspStatusAndMessage,infoModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}
/**
 *
 * 设计师首页(主页)信息
 *
 */
+(void)getDesignerHomeInfo:(NSString *)designerId andBlock:(void(^)(YYRspStatusAndMessage *rspStatusAndMessage, YYBrandHomeInfoModel *infoModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kDesignerHomeInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kDesignerHomeInfo params:nil];

    NSDictionary *parameters = @{@"designerId":designerId};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYBrandHomeInfoModel *infoModel = [[YYBrandHomeInfoModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,infoModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 首页品牌介绍
 *
 */
+ (void)getHomePageBrandInfoWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYUserHomePageModel *homePageModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kHomePageInfoNew];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kHomePageInfoNew params:nil];
    
    [YYRequestHelp POST:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYUserHomePageModel *homePageModel = [[YYUserHomePageModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,homePageModel,error);
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取下级信息（国家之下）
 *
 */
+ (void)getSupCountryInfo:(NSInteger )impId WithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYCountryListModel *countryListModel,NSError *error))block{
    // get URL
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kCountryInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kCountryInfo params:nil];

    NSDictionary *parameters = @{@"parent":@(impId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYCountryListModel *CountryListModel = [[YYCountryListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,CountryListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取国家信息
 *
 */
+ (void)getCountryInfoWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYCountryListModel *countryListModel,NSError *error))block{
    // get URL
    
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kCountryInfo];
    
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kCountryInfo params:nil];
    
    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:nil andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYCountryListModel *CountryListModel = [[YYCountryListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,CountryListModel,error);
            
        }else{
            block(rspStatusAndMessage,nil,error);
        }
        
    }];
}

/**
 *
 * 获取下级信息（国家之下）
 *
 */
+ (void)getSubCountryInfoWithCountryID:(NSInteger )impId WithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYCountryListModel *countryListModel,NSInteger impId,NSError *error))block{

    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kCountryInfo];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kCountryInfo params:nil];

    NSDictionary *parameters = @{@"parent":@(impId)};
    NSData *body = [parameters mj_JSONData];

    [YYRequestHelp GET:dic requestUrl:requestURL requestCount:0 requestBody:body andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,id responseObject, NSError *error, id httpResponse) {
        if (!error
            && responseObject) {
            YYCountryListModel *CountryListModel = [[YYCountryListModel alloc] initWithDictionary:responseObject error:nil];
            block(rspStatusAndMessage,CountryListModel,impId,error);
            
        }else{
            block(rspStatusAndMessage,nil,impId,error);
        }
        
    }];
}

/**
 * 切换语言 保存到服务器
 */
+(void)setLanguageToServer:(ELanguage )Language andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block{
    
    NSString *requestURL = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL] stringByAppendingString:kSwitchLang];
    NSDictionary *dic = [YYHttpHeaderManager buildHeadderWithAction:kSwitchLang params:nil];
    
    NSString *lang = @"cn";
    if(Language == ELanguageEnglish){
        lang = @"en";
    }

    NSDictionary *parameters = @{@"lang":lang};
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
@end
