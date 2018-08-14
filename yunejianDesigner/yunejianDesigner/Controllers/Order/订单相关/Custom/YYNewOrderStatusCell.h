//
//  YYOrderStatusCell.h
//  Yunejian
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderStatusView.h"
#import "YYOrderInfoModel.h"
#import "YYOrderTransStatusModel.h"
#import "CommonMacro.h"

@interface YYNewOrderStatusCell : UITableViewCell{
    //YYOrderStatusView *statusView;
    NSInteger uiStatus;//0意向单  1
    NSInteger progress;
}
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusStartTipView;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet UILabel *oprateTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UIButton *dealCloseBtn;
//@property (weak, nonatomic) IBOutlet UILabel *statusTipLabel;
//@property (weak, nonatomic) IBOutlet UILabel *statusStartTipLabel;
//@property (weak, nonatomic) IBOutlet UILabel *caneltip;
//@property (weak, nonatomic) IBOutlet UIView *statusStartTipView;
//@property (weak, nonatomic) IBOutlet UIView *cancelView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusTipLayoutConstraint;

//@property (weak, nonatomic) IBOutlet UIView *statusViewContainer;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerLayoutLeftConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipLabelLayoutTopConstraint;
//@property (weak, nonatomic) IBOutlet UIButton *oprateBtn;
//@property (weak, nonatomic) IBOutlet UIButton *oprateBtn1;
- (IBAction)opreteBtnHandler:(id)sender;
//- (IBAction)opreteBtnHandler1:(id)sender;

@property (nonatomic, strong) YYOrderInfoModel *currentYYOrderInfoModel;
@property (strong, nonatomic) YYOrderTransStatusModel *currentYYOrderTransStatusModel;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
-(void)updateUI;
+(float)cellHeight:(NSInteger)tranStatus;

@end
