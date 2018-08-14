//
//  YYGuideHandler.h
//  YunejianBuyer
//
//  Created by Apple on 16/11/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GuideType) {
    GuideTypeSettingDot = 1,
    GuideTypeHelpNewFlag = 2,
    GuideTypePersonalChat = 3,
    GuideTypeOpusSetting = 4,
    GuideTypeTabMe = 5
};
@interface YYGuideHandler : NSObject

+(void)showGuideView:(NSInteger)type parentView:(UIView *)parentView targetView:(UIView *)targetview;
+(void)markGuide:(NSInteger)type;
@end
