//
//  UIButton+Custom.h
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Custom)

/**
 返回仅初始化的btn

 @return btn
 */
+(UIButton *)getCustomBtn;

/**
 返回自定义btn
 
 @param normalImageStr UIControlStateNormal下的标题的按钮image
 @param selectedImageStr UIControlStateSelected下的标题的按钮image
 @return btn
 */
+(UIButton *)getCustomImgBtnWithImageStr:(NSString *)normalImageStr WithSelectedImageStr:(NSString *)selectedImageStr;

/**
 * 创建带backimage 的自定义 btn
 */
/**
 返回自定义btn
 
 @param normalImageStr UIControlStateNormal下的标题的按钮backgroundImage
 @param selectedImageStr UIControlStateSelected下的标题的按钮backgroundImage
 @return btn
 */
+(UIButton *)getCustomBackImgBtnWithImageStr:(NSString *)normalImageStr WithSelectedImageStr:(NSString *)selectedImageStr;

/**
 返回自定义btn

 @param alignment UIControlContentHorizontalAlignment
 @param font 字体大小
 @param spacing 字间距
 @param normalTitle UIControlStateNormal下的标题
 @param normalColor UIControlStateNormal下的字体颜色
 @param selectedTitle UIControlStateSelected下的标题
 @param selectedColor UIControlStateSelected下的字体颜色
 @return btn
 */
+(UIButton *)getCustomTitleBtnWithAlignment:(NSInteger )alignment WithFont:(CGFloat )font WithSpacing:(CGFloat )spacing WithNormalTitle:(NSString *)normalTitle WithNormalColor:(UIColor *)normalColor WithSelectedTitle:(NSString *)selectedTitle WithSelectedColor:(UIColor *)selectedColor;

@end
