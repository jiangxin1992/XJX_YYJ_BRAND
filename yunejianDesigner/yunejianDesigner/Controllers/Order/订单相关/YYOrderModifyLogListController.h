//
//  YYOrderModifyLogListController.h
//  Yunejian
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYStylesAndTotalPriceModel.h"
#import "YYOrderInfoModel.h"
@interface YYOrderModifyLogListController : UIViewController
@property (strong, nonatomic) YYStylesAndTotalPriceModel *stylesAndTotalPriceModel;
@property (strong, nonatomic) YYOrderInfoModel *currentYYOrderInfoModel;
@property(nonatomic,strong) NSString *currentOrderLogo;

@end
