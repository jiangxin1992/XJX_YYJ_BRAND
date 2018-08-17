//
//  YYOrderModifyViewController.h
//  Yunejian
//
//  Created by yyj on 15/8/18.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYSalesManListModel,YYOrderInfoModel;

typedef void (^CloseButtonClicked)();

@interface YYOrderModifyViewController : UIViewController

@property (nonatomic, assign) BOOL isCreatOrder;
@property (nonatomic, assign) BOOL isReBuildOrder;//区分创建订单类型中的（rebuild）
@property (nonatomic, assign) BOOL isAppendOrder;//isCreatOrder no  时候起作用

@property (nonatomic, strong) YYOrderInfoModel *currentYYOrderInfoModel;

@property (nonatomic, strong) YYSalesManListModel *salesManListModel;

@property (nonatomic, strong) CloseButtonClicked closeButtonClicked;
@property (nonatomic, strong) ModifySuccess modifySuccess;
@property (nonatomic, strong) UpdateInterface updateBlock;

@end
