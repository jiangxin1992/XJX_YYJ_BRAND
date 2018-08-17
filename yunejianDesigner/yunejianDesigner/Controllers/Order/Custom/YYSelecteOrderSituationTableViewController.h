//
//  YYSelecteOrderSituationTableViewController.h
//  Yunejian
//
//  Created by yyj on 15/8/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderSettingInfoModel.h"

@interface YYSelecteOrderSituationTableViewController : UITableViewController

@property(nonatomic,strong) NSString *currentSituation;

@property(nonatomic,strong) YYOrderSettingInfoModel *currentOrderSettingInfoModel;

@property(nonatomic,strong) SelectedValue selectedValue;

@end
