//
//  YYOrderMoneyLogCell.h
//  Yunejian
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASProgressPopUpView.h"
#import "YYPaymentNoteListModel.h"
#import "YYOrderInfoModel.h"
#import "YYOrderTransStatusModel.h"

@interface YYOrderMoneyLogCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addLogBtn;
@property (weak, nonatomic) IBOutlet UILabel *hasMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *paymentInfoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentInfoViewBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *paylistShowBtn;

@property (nonatomic, strong) YYOrderInfoModel *currentYYOrderInfoModel;
@property (strong, nonatomic) YYOrderTransStatusModel *currentYYOrderTransStatusModel;
@property (nonatomic,strong) YYPaymentNoteListModel *paymentNoteList;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger moneyType;
@property (nonatomic,assign) NSInteger isPaylistShow;
-(void)updateUI;
+(float)cellHeight:(NSArray *)payNoteList tranStatus:(NSInteger)tranStatus isPaylistShow:(NSInteger)isPaylistShow;
@end
