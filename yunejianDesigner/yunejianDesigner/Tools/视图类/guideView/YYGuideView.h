//
//  YYGuideView.h
//  YunejianBuyer
//
//  Created by Apple on 16/11/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GuideViewDirection) {
    GuideViewDirectionTop = 0,
    GuideViewDirectionBottom = 1
};
@interface YYGuideView : UIView
- (void)showInView:(UIView *)view targetView:(UIView *)targetview tipStr:(NSString *)tipStr direction:(NSInteger)direction gap:(NSInteger)gap;
@end
