//
//  YYLogisticsDetailCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYExpressItemModel;

@interface YYLogisticsDetailCell : UITableViewCell

@property (nonatomic, strong) YYExpressItemModel *expressItemModel;
@property (nonatomic, assign) BOOL newestExpress;

- (void)updateUI;

@end
