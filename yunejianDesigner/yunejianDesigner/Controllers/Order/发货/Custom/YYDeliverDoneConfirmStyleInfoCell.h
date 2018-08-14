//
//  YYDeliverDoneConfirmStyleInfoCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderStyleModel;

@interface YYDeliverDoneConfirmStyleInfoCell : UITableViewCell

@property (nonatomic, strong) YYOrderStyleModel *orderStyleModel;

@property (nonatomic, assign) BOOL isFirstCell;

-(void)updateUI;

@end
