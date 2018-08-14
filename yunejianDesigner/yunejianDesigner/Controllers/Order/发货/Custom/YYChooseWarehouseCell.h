//
//  YYChooseWarehouseCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYWarehouseModel;

@interface YYChooseWarehouseCell : UITableViewCell

@property (nonatomic, strong) YYWarehouseModel *warehouseModel;

@property (nonatomic, strong) UIView *bottomLine;

- (void)updateUI;

@end
