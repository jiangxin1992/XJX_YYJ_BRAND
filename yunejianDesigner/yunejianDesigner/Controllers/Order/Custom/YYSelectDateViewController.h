//
//  YYSelectDateViewController.h
//  Yunejian
//
//  Created by yyj on 15/8/19.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderOneInfoModel.h"
#import "YYOrderInfoModel.h"

@interface YYSelectDateViewController : UIViewController


@property (nonatomic,strong) YYOrderOneInfoModel *orderOneInfoModel;
@property (strong, nonatomic) YYOrderInfoModel *currentYYOrderInfoModel;

@property(nonatomic,strong) NSString *selectedDateString;

@property(nonatomic,assign) BOOL isBeginDate;

@end
