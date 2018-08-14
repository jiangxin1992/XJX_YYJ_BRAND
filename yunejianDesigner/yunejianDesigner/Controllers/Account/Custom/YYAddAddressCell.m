//
//  YYAddAddressCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/2/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYAddAddressCell.h"

@implementation YYAddAddressCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:nil];
    }
}

-(void)updateUI{
    _addBtn.layer.cornerRadius = 2.5;
    _addBtn.layer.masksToBounds = YES;
}
@end
