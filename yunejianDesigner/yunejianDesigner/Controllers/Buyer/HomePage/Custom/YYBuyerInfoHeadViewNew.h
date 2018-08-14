//
//  YYBuyerInfoHeadView.h
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYBuyerHomeInfoModel;

@interface YYBuyerInfoHeadViewNew : UIView

-(instancetype)initWithHomeInfoModel:(YYBuyerHomeInfoModel *)infoModel WithBlock:(void(^)(NSString *type ,NSInteger index))block;

@property (nonatomic,assign) BOOL isHomePage;

@property (nonatomic, strong) YYBuyerHomeInfoModel *infoModel;

@property(nonatomic,copy) void (^block)(NSString *type ,NSInteger index);

-(void)SetData;

@end
