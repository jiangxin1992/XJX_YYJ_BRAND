//
//  YYTypeButton.m
//  Yunejian
//
//  Created by yyj on 2017/1/1.
//  Copyright © 2017年 yyj. All rights reserved.
//

#import "YYTypeButton.h"

@implementation YYTypeButton

+(YYTypeButton *)getCustomTitleBtnWithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithSpacing:(CGFloat )_spacing WithNormalTitle:(NSString *)_normalTitle WithNormalColor:(UIColor *)_normalColor WithSelectedTitle:(NSString *)_selectedTitle WithSelectedColor:(UIColor *)_selectedColor
{
    YYTypeButton *btn=[YYTypeButton buttonWithType:UIButtonTypeCustom];
    
    if(_normalTitle)
    {
        [btn setTitle:_normalTitle forState:UIControlStateNormal];
    }
    if(_normalColor)
    {
        [btn setTitleColor:_normalColor forState:UIControlStateNormal];
    }else
    {
        [btn setTitleColor:_define_black_color forState:UIControlStateNormal];
    }
    
    if(_selectedTitle)
    {
        [btn setTitle:_selectedTitle forState:UIControlStateSelected];
    }
    
    if(_selectedColor)
    {
        [btn setTitleColor:_selectedColor forState:UIControlStateSelected];
    }else
    {
        [btn setTitleColor:_define_black_color forState:UIControlStateSelected];
    }
    
    btn.contentHorizontalAlignment=_alignment;
    if(_font)
    {
        btn.titleLabel.font=getFont(_font);
    }
    
    return btn;
}
+(YYTypeButton *)getCustomImgBtnWithImageStr:(NSString *)_normalImageStr WithSelectedImageStr:(NSString *)_selectedImageStr
{
    YYTypeButton *btn=[YYTypeButton buttonWithType:UIButtonTypeCustom];
    if(_normalImageStr){
        [btn setImage:[UIImage imageNamed:_normalImageStr] forState:UIControlStateNormal];
    }
    
    if(_selectedImageStr)
    {
        [btn setImage:[UIImage imageNamed:_selectedImageStr] forState:UIControlStateSelected];
    }
    
    return btn;
}
@end
