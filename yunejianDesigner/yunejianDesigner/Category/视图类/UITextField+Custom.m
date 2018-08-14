//
//  UITextField+Custom.m
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UITextField+Custom.h"

@implementation UITextField (Custom)
+(UITextField *)getTextFieldWithPlaceHolder:(NSString *)placeHolder WithAlignment:(NSInteger )alignment WithFont:(CGFloat )font WithTextColor:(UIColor *)textColor WithLeftView:(UIView *)leftView WithRightView:(UIView *)rightView WithSecureTextEntry:(BOOL )isSecure
{
    UITextField *textfield=[[UITextField alloc] init];
    if(textColor){
        textfield.textColor=textColor;
    }else
    {
        textfield.textColor=_define_black_color;
    }
    if(placeHolder){
        textfield.placeholder=placeHolder;
    }
    if(font){
        textfield.font=getFont(font);
    }
    if(leftView){
        textfield.leftViewMode=UITextFieldViewModeAlways;
        textfield.leftView=leftView;
    }
    if(rightView){
        textfield.rightViewMode=UITextFieldViewModeAlways;
        textfield.rightView=rightView;
    }
    if(isSecure)
    {
        textfield.secureTextEntry=isSecure;
    }else
    {
        textfield.secureTextEntry=NO;
    }
    textfield.textAlignment=alignment;
    UIView *dibu=[[UIView alloc] init];
    [textfield addSubview:dibu];
    dibu.backgroundColor=[UIColor blackColor];
    [dibu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(textfield.mas_bottom);
    }];
    return textfield;
}
+(UITextField *)getTextFieldWithPlaceHolder:(NSString *)placeHolder WithAlignment:(NSInteger )alignment WithFont:(CGFloat )font WithTextColor:(UIColor *)textColor WithLeftWidth:(CGFloat )leftWidth WithRightWidth:(CGFloat )rightWidth WithSecureTextEntry:(BOOL )isSecure HaveBorder:(BOOL )haveBorder WithBorderColor:(UIColor *)color
{
    UITextField *textfield=[[UITextField alloc] init];
    if(textColor){
        textfield.textColor=textColor;
    }else
    {
        textfield.textColor=_define_black_color;
    }
    if(placeHolder){
        textfield.placeholder=placeHolder;
    }
    if(font){
        textfield.font=getFont(font);
    }
    if(leftWidth){
        textfield.leftViewMode=UITextFieldViewModeAlways;
        UIView *_leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, leftWidth, 10)];
        textfield.leftView=_leftView;
    }
    if(rightWidth){
        textfield.rightViewMode=UITextFieldViewModeAlways;
        UIView *_rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, rightWidth, 10)];
        textfield.rightView=_rightView;
    }
    if(isSecure)
    {
        textfield.secureTextEntry=isSecure;
    }else
    {
        textfield.secureTextEntry=NO;
    }
    textfield.textAlignment=alignment;
    
    if(haveBorder)
    {
        textfield.layer.masksToBounds=YES;
        textfield.layer.borderWidth=1;
        if(color)
        {
            textfield.layer.borderColor=[color CGColor];
        }else
        {
            textfield.layer.borderColor=[_define_black_color CGColor];
        }
    }
    //    UIView *dibu=[[UIView alloc] init];
    //    [_textfield addSubview:dibu];
    //    dibu.backgroundColor=[UIColor blackColor];
    //    [dibu mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.and.right.mas_equalTo(0);
    //        make.height.mas_equalTo(1);
    //        make.bottom.mas_equalTo(_textfield.mas_bottom);
    //    }];
    
    return textfield;
}
@end
