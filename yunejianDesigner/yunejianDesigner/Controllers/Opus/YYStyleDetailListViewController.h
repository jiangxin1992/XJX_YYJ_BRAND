//
//  YYStyleDetailListViewController.h
//  Yunejian
//
//  Created by yyj on 15/7/26.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOpusSeriesModel,YYOrderInfoModel;

@interface YYStyleDetailListViewController : UIViewController

@property(nonatomic,assign) NSInteger designerId;//设计师ID
//修改订单部分
@property (nonatomic, assign)BOOL isModifyOrder;
@property (strong, nonatomic) YYOrderInfoModel *currentYYOrderInfoModel;

@end
