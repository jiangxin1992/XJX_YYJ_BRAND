//
//  YYChooseLogisticsViewController.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYExpressCompanyModel;

@interface YYChooseLogisticsViewController : UIViewController

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;

@property(nonatomic,copy) void (^chooseLogisticsSelectBlock)(YYExpressCompanyModel *expressCompanyModel);

@end
