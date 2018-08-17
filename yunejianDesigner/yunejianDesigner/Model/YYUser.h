//
//  YYUser.h
//  Yunejian
//
//  Created by yyj on 15/7/10.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYUser : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *tokenId;      // 登录成功后的tokenId
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *status;//300 //审核中301 //审核被 303 //需要审核
@property (nonatomic, assign) YYUserType userType;//用户类型 0:设计师 1:买手店 2:销售代表 5:Showroom 6:Showroom子账号
@property (nonatomic, copy) NSString *brandId;

//获取当前用户
+ (YYUser *)currentUser;
//保存用户数据
- (void)saveUserWithEmail:(NSString *)email username:(NSString *)username password:(NSString *)password userType:(NSInteger)userType userId:(NSString*)userId logo:(NSString *)logo status:(NSString*)status brandId:(NSString *)brandId;
- (void)saveUserData;

//登出
- (void)loginOut;
//存取new的状态，根据不同账号的不同版本 1新增主页
+ (void)saveNewsReadStateWithType:(NSInteger )type;
+ (BOOL)getNewsReadStateWithType:(NSInteger )type;

/**
 * 判断当前用户角色是否是brand角色（showroom———>品牌）
 * 判断本地的kTempUserLoginTokenKey对应的有没有值
 * 有值返回true
 * 没有值返回false
 */
+(BOOL)isShowroomToBrand;

/**
 * 获取当前用户token
 * 通过isShowroomToBrand方法，判断是否是brand角色（showroom———>品牌）
 * 如果不是、通过kUserLoginTokenKey获取token
 * 如果是、通过kTempUserLoginTokenKey获取token
 */
+(NSString *)getToken;

/**
 * 清空 kTempUserLoginTokenKey、kTempBrandID
 * 其实就是使brand角色（showroom———>品牌）登出
 */
+ (void )removeTempUser;
@end
