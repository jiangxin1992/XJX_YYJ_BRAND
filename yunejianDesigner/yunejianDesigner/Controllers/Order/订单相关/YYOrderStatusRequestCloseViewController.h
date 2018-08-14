//
//  YYOrderStatusRequestCloseViewController.h
//  Yunejian
//
//  Created by Apple on 16/1/24.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderInfoModel;

@interface YYOrderStatusRequestCloseViewController : UIViewController

@property(nonatomic,strong)ModifySuccess modifySuccess;
@property(nonatomic,strong)CancelButtonClicked cancelButtonClicked;
@property (strong, nonatomic) YYOrderInfoModel *currentYYOrderInfoModel;

@end
