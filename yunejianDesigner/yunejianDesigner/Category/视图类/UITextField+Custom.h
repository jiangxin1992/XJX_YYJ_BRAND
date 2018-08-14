//
//  UITextField+Custom.h
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Custom)

/**
 返回自定义textField

 @param placeHolder placeholder
 @param alignment textAlignment
 @param font font
 @param textColor textColor
 @param leftView leftView
 @param rightView rightView
 @param isSecure 是否加密
 @return textField
 */
+(UITextField *)getTextFieldWithPlaceHolder:(NSString *)placeHolder WithAlignment:(NSInteger )alignment WithFont:(CGFloat )font WithTextColor:(UIColor *)textColor WithLeftView:(UIView *)leftView WithRightView:(UIView *)rightView WithSecureTextEntry:(BOOL )isSecure;

/**
 返回自定义textField

 @param placeHolder placeholder
 @param alignment textAlignment
 @param font font
 @param textColor textColor
 @param leftWidth leftView 宽度
 @param rightWidth rightWidth 宽度
 @param isSecure 是否加密
 @param haveBorder 是否有底部line
 @param color 底部line颜色
 @return textField
 */
+(UITextField *)getTextFieldWithPlaceHolder:(NSString *)placeHolder WithAlignment:(NSInteger )alignment WithFont:(CGFloat )font WithTextColor:(UIColor *)textColor WithLeftWidth:(CGFloat )leftWidth WithRightWidth:(CGFloat )rightWidth WithSecureTextEntry:(BOOL )isSecure HaveBorder:(BOOL )haveBorder WithBorderColor:(UIColor *)color;

@end
