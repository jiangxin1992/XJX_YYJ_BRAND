//
//  UILabel+Custom.m
//  DDAY
//
//  Created by yyj on 16/7/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel (DD_Custom)

+(UILabel *)getLabelWithAlignment:(NSInteger )alignment WithTitle:(NSString *)title WithFont:(CGFloat )font WithTextColor:(UIColor *)textColor WithSpacing:(CGFloat )spacing
{
    UILabel *label=[[UILabel alloc] init];
    label.textAlignment=alignment;
    if(title)
    {
        if(spacing)
        {
            [label setAttributedText:[label createAttributeString:title andFloat:@(spacing)]];
        }else
        {
            label.text=title;
        }
    }
    if(textColor)
    {
        label.textColor=textColor;
    }else
    {
        label.textColor=_define_black_color;
    }

    if(font)
    {
        label.font=getFont(font);
    }
    return label;
}

/**
 * 设置字间距
 */
- (NSAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern
{
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:str attributes:@{NSKernAttributeName : nsKern}];
    return attributedString;
}

@end
