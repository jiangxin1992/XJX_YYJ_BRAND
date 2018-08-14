//
//  YYChooseLogisticsCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYExpressCompanyModel;

@interface YYChooseLogisticsCell : UITableViewCell

@property (nonatomic, strong) YYExpressCompanyModel *expressCompanyModel;

@property (nonatomic, assign) BOOL isHideBottomLine;

-(void)updateUI;

@end
