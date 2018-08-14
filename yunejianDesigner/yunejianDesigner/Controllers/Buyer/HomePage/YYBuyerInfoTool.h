//
//  YYBuyerInfoTool.h
//  yunejianDesigner
//
//  Created by yyj on 2017/2/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYBuyerInfoTool : NSObject

+(BOOL)isNilOrEmptyWithContactValue:(NSString *)contactValue WithContactType:(NSNumber *)contactType;
/** 获取可拨打的手机号码*/
+(NSString *)getAvailablePhoneNum:(NSString *)contactValue;
/** 获取可拨打的座机号码*/
+(NSString *)getAvailableTelePhoneNum:(NSString *)contactValue;
@end
