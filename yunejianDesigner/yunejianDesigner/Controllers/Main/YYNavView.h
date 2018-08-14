//
//  YYNavView.h
//  YunejianBuyer
//
//  Created by yyj on 2017/6/2.
//  Copyright © 2017年 Apple. All rights reserved.
//
//自定义导航栏
#import <UIKit/UIKit.h>

@interface YYNavView : UIView

/**
 初始化方法

 @param title 标题
 @param superView 父视图
 @param haveStatusView 是否有状态栏
 @return ...
 */
-(instancetype)initWithTitle:(NSString *)title WithSuperView:(UIView *)superView haveStatusView:(BOOL )haveStatusView;

/**
  初始化方法

 @param title 标题
 @return ...
 */
-(instancetype)initWithTitle:(NSString *)title;

/**
 标题
 */
@property (nonatomic,strong) NSString *navTitle;

/**
 标题label
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 让self消失或显示（Animation）

 @param isHide 是否消失
 */
-(void)setAnimationHide:(BOOL )isHide;

@end
