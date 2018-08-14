//
//  YYOrderDetailSectionHead.h
//  Yunejian
//
//  Created by Apple on 15/8/17.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderOneInfoModel.h"

@interface YYOrderDetailSectionHead : UITableViewCell

@property(nonatomic,strong) YYOrderOneInfoModel *orderOneInfoModel;

@property(nonatomic,assign) BOOL isHiddenSelectDateView;//是否隐藏选择日期视图

- (void)updateUI;

@end
