//
//  YYOrderOwnCloseReqCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/3/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderInfoModel.h"
#import "YYOrderTransStatusModel.h"
@interface YYOrderOwnCloseReqCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timerTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderStatusBtn;

@property (nonatomic, strong) YYOrderInfoModel *currentYYOrderInfoModel;
@property (strong, nonatomic) YYOrderTransStatusModel *currentYYOrderTransStatusModel;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
-(void)updateUI;
@end
