//
//  YYAlert.h
//  Yunejian
//
//  Created by yyj on 15/7/9.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYToast : UIView

/**
 显示toast在window上

 @param title 显示的内容
 @param durationInMillis 显示时常（毫秒）
 */
+ (void)showToastWithTitle:(NSString *)title andDuration:(NSUInteger)durationInMillis;

/**
 显示toast在制定view上

 @param view 显示toast的父控件。nil的话就显示在window上
 @param title 显示的内容
 @param durationInMillis 显示时常（毫秒）
 */
+ (void)showToastWithView:(UIView *)view title:(NSString *)title andDuration:(NSUInteger)durationInMillis;

@end
