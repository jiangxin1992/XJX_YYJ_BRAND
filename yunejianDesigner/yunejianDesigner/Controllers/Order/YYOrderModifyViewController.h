//
//  YYOrderModifyViewController.h
//  Yunejian
//
//  Created by yyj on 15/8/18.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYSalesManListModel,YYBuyerModel,YYOrderInfoModel;

typedef void (^CloseButtonClicked)();

@interface YYOrderModifyViewController : UIViewController

@property (assign, nonatomic) BOOL isCreatOrder;
@property (assign, nonatomic) BOOL isReBuildOrder;//区分创建订单类型中的（rebuild）
@property (assign, nonatomic) BOOL isAppendOrder;//isCreatOrder no  时候起作用

@property (strong, nonatomic) YYOrderInfoModel *currentYYOrderInfoModel;

@property (nonatomic,strong) YYSalesManListModel *salesManListModel;

@property (strong, nonatomic) YYBuyerModel *buyerModel;//买手店地址
@property (strong, nonatomic) YYOrderBuyerAddress *nowBuyerAddress;//新增地址

@property (strong, nonatomic) CloseButtonClicked closeButtonClicked;
@property (strong, nonatomic) ModifySuccess modifySuccess;
@property (strong, nonatomic) UpdateInterface updateBlock;

@end
