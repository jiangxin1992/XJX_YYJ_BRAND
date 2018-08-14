//
//  UIButton+Custom.m
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)
+(UIButton *)getCustomTitleBtnWithAlignment:(NSInteger )alignment WithFont:(CGFloat )font WithSpacing:(CGFloat )spacing WithNormalTitle:(NSString *)normalTitle WithNormalColor:(UIColor *)normalColor WithSelectedTitle:(NSString *)selectedTitle WithSelectedColor:(UIColor *)selectedColor
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    if(normalTitle)
    {
        if(spacing)
        {
            [btn setAttributedTitle:[btn createAttributeString:normalTitle andFloat:@(spacing) WithColor:normalColor] forState:UIControlStateNormal];
        }else
        {
            [btn setTitle:normalTitle forState:UIControlStateNormal];
        }
    }
    
    if(normalColor)
    {
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
    }else
    {
        [btn setTitleColor:_define_black_color forState:UIControlStateNormal];
    }
    
    
    if(selectedTitle)
    {
        if(spacing)
        {
            [btn setAttributedTitle:[btn createAttributeString:selectedTitle andFloat:@(spacing) WithColor:selectedColor] forState:UIControlStateSelected];
        }else
        {
            [btn setTitle:selectedTitle forState:UIControlStateSelected];
        }
    }
    
    if(selectedColor)
    {
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    }else
    {
        [btn setTitleColor:_define_black_color forState:UIControlStateSelected];
    }
    
    
    btn.contentHorizontalAlignment=alignment;
    if(font)
    {
        btn.titleLabel.font=getFont(font);
    }
    
    return btn;
}
+(UIButton *)getCustomImgBtnWithImageStr:(NSString *)normalImageStr WithSelectedImageStr:(NSString *)selectedImageStr
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    if(normalImageStr){
        [btn setImage:[UIImage imageNamed:normalImageStr] forState:UIControlStateNormal];
    }
    
    if(selectedImageStr)
    {
        [btn setImage:[UIImage imageNamed:selectedImageStr] forState:UIControlStateSelected];
    }
    
    return btn;
}
+(UIButton *)getCustomBackImgBtnWithImageStr:(NSString *)normalImageStr WithSelectedImageStr:(NSString *)selectedImageStr
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    if(normalImageStr){
        [btn setBackgroundImage:[UIImage imageNamed:normalImageStr] forState:UIControlStateNormal];
    }
    
    if(selectedImageStr)
    {
        [btn setBackgroundImage:[UIImage imageNamed:selectedImageStr] forState:UIControlStateSelected];
    }
    return btn;
}
+(UIButton *)getCustomBtn
{
    return [UIButton buttonWithType:UIButtonTypeCustom];
}
/**
 * 设置字间距
 */
- (NSAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern WithColor:(UIColor *)color
{
    
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:str attributes:@{NSKernAttributeName : nsKern}];
    [attributedString addAttribute:NSForegroundColorAttributeName
     
                             value:color?color:_define_black_color
     
                             range:NSMakeRange(0, str.length)];
    return attributedString;
}

@end
