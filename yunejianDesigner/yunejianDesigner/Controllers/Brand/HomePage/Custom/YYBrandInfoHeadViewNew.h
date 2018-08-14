//
//  YYBuyerInfoHeadView.h
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYBrandHomeInfoModel;

@interface YYBrandInfoHeadViewNew : UIView

-(instancetype)initWithHomeInfoModel:(YYBrandHomeInfoModel *)infoModel WithBlock:(void(^)(NSString *type ,NSInteger index))block;

@property (nonatomic,assign) BOOL isHomePage;

@property (nonatomic, strong) YYBrandHomeInfoModel *infoModel;

@property(nonatomic,copy) void (^block)(NSString *type ,NSInteger index);

@property (nonatomic, strong) UIButton *oprateBtn;

-(void)SetData;

-(void)reloadData;

@end
