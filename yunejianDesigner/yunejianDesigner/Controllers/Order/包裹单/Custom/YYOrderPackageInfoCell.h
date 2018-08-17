//
//  YYOrderPackageInfoCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/27.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderPackageStatModel;

@interface YYOrderPackageInfoCell : UITableViewCell

@property (nonatomic, strong) YYOrderPackageStatModel *orderPackageStatModel;

@property (nonatomic,copy) void (^cellClickBlock)(void);

-(void)updateUI;

+(CGFloat)cellHeight;

@end
