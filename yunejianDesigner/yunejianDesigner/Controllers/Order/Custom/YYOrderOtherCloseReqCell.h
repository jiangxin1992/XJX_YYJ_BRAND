//
//  YYOrderOtherCloseReqCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/3/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderInfoModel.h"
#import "YYOrderTransStatusModel.h"
@interface YYOrderOtherCloseReqCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *orderStatusBtn1;
@property (weak, nonatomic) IBOutlet UIButton *orderStatusBtn2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderStatusBtnWidthLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderStatusBtnWidthLayout2;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;

@property (nonatomic, strong) YYOrderInfoModel *currentYYOrderInfoModel;
@property (strong, nonatomic) YYOrderTransStatusModel *currentYYOrderTransStatusModel;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
-(void)updateUI;
@end
