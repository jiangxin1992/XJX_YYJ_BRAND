//
//  YYDeliverDoneTotalPriceCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/4.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYStylesAndTotalPriceModel;

@interface YYDeliverDoneTotalPriceCell : UITableViewCell

@property (nonatomic, strong) YYStylesAndTotalPriceModel *stylesAndTotalPriceModel;//原总数
@property (nonatomic, strong) YYStylesAndTotalPriceModel *nowStylesAndTotalPriceModel;//现总数
@property (nonatomic, strong) NSNumber *curType;//货币类型

-(void)updateUI;

@end
