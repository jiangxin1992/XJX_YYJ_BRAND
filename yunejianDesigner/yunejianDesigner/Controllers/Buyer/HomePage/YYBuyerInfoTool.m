//
//  YYBuyerInfoTool.m
//  yunejianDesigner
//
//  Created by yyj on 2017/2/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYBuyerInfoTool.h"

@implementation YYBuyerInfoTool

+(BOOL)isNilOrEmptyWithContactValue:(NSString *)contactValue WithContactType:(NSNumber *)contactType
{
    //根绝权限判断
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
+(NSString *)getAvailableTelePhoneNum:(NSString *)contactValue
{
//    NSString *availablePhoneNum = @"+86-0574-62158093";
    NSArray *tempArr = [contactValue componentsSeparatedByString:@" "];
    NSString *local = nil;
    NSString *phone = nil;
    if(tempArr.count>1)
    {
        phone = tempArr[1];
        NSArray *tempLocalArr = [tempArr[0] componentsSeparatedByString:@"+"];
        if(tempLocalArr.count>1)
        {
            if(![tempArr[0] isEqualToString:@"+86"])
            {
                local = tempArr[0];
            }
        }
    }else if(tempArr.count==1)
    {
        phone = tempArr[0];
    }
    
    if(![NSString isNilOrEmpty:phone])
    {
        if(![NSString isNilOrEmpty:local])
        {
            return [[NSString alloc] initWithFormat:@"%@-%@",local,phone];
        }else
        {
            return phone;
        }
    }
    return nil;
}
+(NSString *)getAvailablePhoneNum:(NSString *)contactValue
{
    NSArray *tempArr = [contactValue componentsSeparatedByString:@" "];
    NSString *local = nil;
    NSString *phone = nil;
    if(tempArr.count>1)
    {
        phone = tempArr[1];
        NSArray *tempLocalArr = [tempArr[0] componentsSeparatedByString:@"+"];
        if(tempLocalArr.count>1)
        {
            local = tempArr[0];
        }
    }else if(tempArr.count==1)
    {
        phone = tempArr[0];
    }
    
    if(![NSString isNilOrEmpty:phone])
    {
        if(![NSString isNilOrEmpty:local])
        {
            return [[NSString alloc] initWithFormat:@"%@%@",local,phone];
        }else
        {
            return phone;
        }
    }
    return nil;
}
@end
