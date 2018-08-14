//
//  YYVerifyTool.h
//  Yunejian
//
//  Created by yyj on 2016/12/27.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYVerifyTool : NSObject

/**
 * 电子邮箱正则
 */
+ (BOOL)emailVerify:(NSString *)email;

/**
 * 正则匹配用户密码6-15位数字和字母组合
 */
+ (BOOL)checkPassword:(NSString *)password;

/**
 * 验证码格式验证
 */
+(BOOL)codeVerify:(NSString *)verifycode;

/**
 * 邮编格式验证
 */
+(BOOL)postCodeVerify:(NSString *)postcode;

/**
 * 手机号码格式验证
 */
+(BOOL)phoneVerify:(NSString *)phone;

/**
 * 国际手机号码格式验证(中国 11位纯数字 国外 6-20位纯数字)
 */
+(BOOL)internationalPhoneVerify:(NSString *)phone WithCountryCode:(NSInteger )countryCode;

+(BOOL)internationalPhoneVerify:(NSString *)phone;

/**
 * 纯数字验证
 */
+(BOOL)numberVerift:(NSString *)num;

/**
 * 固定电话区号正则
 */
+(BOOL)telephoneAreaCode:(NSString *)telephoneArea;

/**
 * 英文字母与数字正则
 */
+(BOOL)inputShouldLetterOrNum:(NSString *)inputString;

@end
