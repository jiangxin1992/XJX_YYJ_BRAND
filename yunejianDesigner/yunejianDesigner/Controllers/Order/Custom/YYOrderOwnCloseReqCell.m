//
//  YYOrderOwnCloseReqCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderOwnCloseReqCell.h"

@implementation YYOrderOwnCloseReqCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI{
    _orderStatusBtn.layer.cornerRadius = 2.5;
    _orderStatusBtn.layer.masksToBounds = YES;
    if([_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]>0){
        NSInteger day = [_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]/24;
        NSInteger hours = [_currentYYOrderInfoModel.autoCloseHoursRemains integerValue]%24;
        NSString *timerStr = [NSString stringWithFormat:NSLocalizedString(@"%ld天%ld小时",nil),(long)day,(long)hours];
        NSString *tipStr = [NSString stringWithFormat:NSLocalizedString(@"剩余 %@，对方未处理，交易将自动取消",nil),timerStr];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: tipStr];
        NSRange range = [tipStr rangeOfString:timerStr];
        if (range.location != NSNotFound) {
            [attributedStr addAttribute:  NSFontAttributeName value: [UIFont boldSystemFontOfSize:14] range:range];
        }
        _timerTipLabel.attributedText = attributedStr;
        //_timerTipLabel.text =
    }else{
        _timerTipLabel.text = @"";
    }
}

- (IBAction)oprateBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"cancelReqClose"]];
    }
}
@end
