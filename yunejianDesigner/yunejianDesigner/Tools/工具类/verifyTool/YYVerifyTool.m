//
//  YYVerifyTool.m
//  Yunejian
//
//  Created by yyj on 2016/12/27.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "YYVerifyTool.h"

@implementation YYVerifyTool

+(BOOL )emailVerify:(NSString *)email
{
    NSString *newEmail = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(![NSString isNilOrEmpty:newEmail]){
        if(![newEmail containsString:@" "]){
            return [self Verify:newEmail WithCode:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
        }
    }
    return NO;
}

+(BOOL )codeVerify:(NSString *)phone
{
    return [self Verify:phone WithCode:@"^[A-Za-z0-9]+$"];
}
+(BOOL )phoneVerify:(NSString *)phone
{
    return [self Verify:phone WithCode:@"^1[3|4|5|7|8][0-9]\\d{8}$"];
}
+(BOOL )postCodeVerify:(NSString *)phone
{
    
    return [self Verify:phone WithCode:@"^[1-9][0-9]{5}$"];
}

+ (BOOL)checkPassword:(NSString *) password
{
    return [self Verify:password WithCode:@"^[A-Za-z0-9]{6,16}$"];
    
}

+(BOOL)numberVerift:(NSString *)phone
{
    return [self Verify:phone WithCode:@"^[0-9]+([.]{0,1}[0-9]+){0,1}$"];
}
+(BOOL )telephoneAreaCode:(NSString *)telephoneArea
{
    // 03xx
    NSString *fourDigit03 = @"03([157]\\d|35|49|9[1-68])";
    // 04xx
    NSString *fourDigit04 = @"04([17]\\d|2[179]|[3,5][1-9]|4[08]|6[4789]|8[23])";
    // 05xx
    NSString *fourDigit05 = @"05([1357]\\d|2[37]|4[36]|6[1-6]|80|9[1-9])";
    // 06xx
    NSString *fourDigit06 = @"06(3[1-5]|6[0238]|9[12])";
    // 07xx
    NSString *fourDigit07 = @"07(01|[13579]\\d|2[248]|4[3-6]|6[023689])";
    // 08xx
    NSString *fourDigit08 = @"08(1[23678]|2[567]|[37]\\d)|5[1-9]|8[3678]|9[1-8]";
    // 09xx
    NSString *fourDigit09 = @"09(0[123689]|[17][0-79]|[39]\\d|4[13]|5[1-5])";
    
    NSString *codeStr = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@",fourDigit03,fourDigit04,fourDigit05,fourDigit06,fourDigit07,fourDigit08,fourDigit09];
    
    return [self Verify:telephoneArea WithCode:codeStr]||[self Verify:telephoneArea WithCode:@"010|02[0-57-9]"];
}

+(BOOL)Verify:(NSString *)content WithCode:(NSString *)code
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:code options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (result) {
        return YES;
    }
    return NO;
}
/**
 * 国际手机号码格式验证(中国 11位纯数字 国外 6-20位纯数字)
 */
+(BOOL )internationalPhoneVerify:(NSString *)phone WithCountryCode:(NSInteger )countryCode{
    BOOL isValidPhone = NO;
    //如果手机号码没有满足正确格式
    //中国 11 位数效验正确性  其他国家 6-20（中国 11位纯数字 国外 6-20位纯数字）
    if([YYVerifyTool numberVerift:phone]){
        //通过数字验证
        if(countryCode == 721){
            //            中国
            if(phone.length == 11){
                isValidPhone = YES;
            }
        }else{
            //            国外
            if(phone.length <= 20 && phone.length >= 6){
                isValidPhone = YES;
            }
            
        }
    }
    return isValidPhone;
}
+(BOOL)internationalPhoneVerify:(NSString *)phone{
    if([YYVerifyTool numberVerift:phone] && (phone.length <= 20 && phone.length >= 6)){
        return YES;
    }
    return NO;
}
/**
 * 英文字母与数字正则
 */
+(BOOL)inputShouldLetterOrNum:(NSString *)inputString{
    if (inputString.length == 0){
        return NO;
    }
    
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:inputString];
}

@end
