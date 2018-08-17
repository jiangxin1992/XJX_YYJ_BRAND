//
//  YYOriginalOrderDetailViewController.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/5.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderInfoModel,YYOrderTransStatusModel;

@interface YYOriginalOrderDetailViewController : UIViewController

@property (nonatomic, strong) YYOrderInfoModel *currentYYOrderInfoModel;

@property (nonatomic, strong) YYOrderTransStatusModel *currentYYOrderTransStatusModel;

@property (nonatomic, strong) NSMutableArray *menuData;

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;

-(void)updateUI;

@end
