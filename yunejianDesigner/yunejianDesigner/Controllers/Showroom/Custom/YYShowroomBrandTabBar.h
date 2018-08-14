//
//  YYShowroomBrandTabBar.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYShowroomBrandTabBar : UIView

//左-1 中0 右1 
-(instancetype)initWithSuperView:(UIView *)superView WithBlock:(void(^)(NSInteger type))clickBlock;

@property (nonatomic,copy) void (^clickBlock)(NSInteger type);
@property (nonatomic,strong) UIView *superView;

@end
