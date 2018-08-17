//
//  YYOrderPayLogViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/7/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPaymentNoteModel.h"
@interface YYOrderPayLogViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusBtn;
@property (weak, nonatomic) IBOutlet UIView *redDotView;
@property (strong,nonatomic) YYPaymentNoteModel *noteModel;
@property (strong,nonatomic)UIImage *statusImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBtnWidthLayout;
-(void)updateUI;
@end
