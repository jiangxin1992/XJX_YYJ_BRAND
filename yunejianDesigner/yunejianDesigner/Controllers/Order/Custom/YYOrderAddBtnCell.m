//
//  YYOrderAddBtnCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderAddBtnCell.h"

@implementation YYOrderAddBtnCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI{
    [_oprateBtn setTitle:_btnStr forState:UIControlStateNormal];
    _oprateBtn.layer.cornerRadius = 2.5;
    _oprateBtn.layer.masksToBounds = YES;
}
- (IBAction)oprateBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:nil];
    }
}
@end
