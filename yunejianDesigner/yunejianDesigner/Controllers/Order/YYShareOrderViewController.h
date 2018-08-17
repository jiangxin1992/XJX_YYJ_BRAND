//
//  YYShareOrderViewController.h
//  Yunejian
//
//  Created by yyj on 15/8/28.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderInfoModel.h"

@interface YYShareOrderViewController : UIViewController

@property(nonatomic,strong) CancelButtonClicked cancelButtonClicked;

@property (strong, nonatomic) YYOrderInfoModel *currentYYOrderInfoModel;

@end
