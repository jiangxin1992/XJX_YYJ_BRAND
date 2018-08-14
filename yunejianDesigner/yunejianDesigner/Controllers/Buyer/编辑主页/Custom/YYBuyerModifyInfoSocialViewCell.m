//
//  YYBuyerModifyInfoSocialViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyInfoSocialViewCell.h"
#import "YYBuyerSocialInfoModel.h"
@implementation YYBuyerModifyInfoSocialViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectHandler:(id)sender {
    
//    if(self.selectedValue){
//        self.selectedValue(self.valueLabel.text);
//    }
//    0 新浪微博，1 微信公众号，2 Facebook，3 Ins'
    if(self.selectedValue){
        NSString *valueStr = @"";
        if(_socialType == 0)
        {
            valueStr = [NSString stringWithFormat:@"Social_0=%@",self.valueLabel.text];
        }else if(_socialType == 1)
        {
            valueStr = [NSString stringWithFormat:@"Social_1=%@",self.valueLabel.text];
        }else if(_socialType == 2)
        {
            valueStr = [NSString stringWithFormat:@"Social_2=%@",self.valueLabel.text];
        }else if(_socialType == 3)
        {
            valueStr = [NSString stringWithFormat:@"Social_3=%@",self.valueLabel.text];
        }else
        {
            valueStr = [NSString stringWithFormat:@"webUrl=%@",self.valueLabel.text];
        }
        self.selectedValue(valueStr);
    }
}
-(void)updateUI{
    WeakSelf(ws);
    self.valueLabel.text = @"";
    for (YYBuyerSocialInfoModel *socialInfoModel in _socialArr) {
        if([socialInfoModel.socialType integerValue] == _socialType){
            ws.valueLabel.text = socialInfoModel.socialName;
            break;
        }
    }
}
@end
