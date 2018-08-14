//
//  UILabel+Custom.h
//  DDAY
//
//  Created by yyj on 16/7/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DD_Custom)

/**
 返回自定义label

 @param alignment textAlignment
 @param title text
 @param font font
 @param textColor textColor
 @param spacing 字间距
 @return label
 */
+(UILabel *)getLabelWithAlignment:(NSInteger )alignment WithTitle:(NSString *)title WithFont:(CGFloat )font WithTextColor:(UIColor *)textColor WithSpacing:(CGFloat )spacing;

/**
 获取设定字间距的attributedString

 @param str 设定内容text
 @param nsKern 字距调整
 @return attributedString
 */
- (NSAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern;

@end
