//
//  YYDiscountViewController.h
//  Yunejian
//
//  Created by yyj on 15/8/26.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderInfoModel.h"

typedef NS_ENUM(NSInteger, DiscountType) {
    DiscountTypeStylePrice = 60000,
    DiscountTypeTotalPrice = 60001
};


@interface YYDiscountViewController : UIViewController

@property(nonatomic,strong) YYOrderStyleModel *orderStyleModel;//款式打折
@property(nonatomic,assign) long seriesId;//款式打折时要用，离线包找图片要用这个

@property (strong, nonatomic) YYOrderInfoModel *currentYYOrderInfoModel;//部价打折


@property (assign, nonatomic) DiscountType currentDiscountType;

@property (assign, nonatomic) float originalTotalPrice;
@property (assign, nonatomic) float finalTotalPrice;

@property(nonatomic,strong)YellowPabelCallBack modifySuccess;
@property(nonatomic,strong)CancelButtonClicked cancelButtonClicked;

@end
