//
//  YYOrderBuyerReceivedCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderBuyerReceivedCell.h"

@implementation YYOrderBuyerReceivedCell

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
    if([_currentYYOrderInfoModel.autoReceivedHoursRemains integerValue]>-1){
        NSInteger day = [_currentYYOrderInfoModel.autoReceivedHoursRemains integerValue]/24;
        NSInteger hours = [_currentYYOrderInfoModel.autoReceivedHoursRemains integerValue]%24;
        _timerTipLabel.text = [NSString stringWithFormat:NSLocalizedString(@"剩余%ld天%ld小时",nil),(long)day,(long)hours];
    }else{
        _timerTipLabel.text = @"";
    }
    

}
- (IBAction)oprateBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"status"]];
    }
}

@end
