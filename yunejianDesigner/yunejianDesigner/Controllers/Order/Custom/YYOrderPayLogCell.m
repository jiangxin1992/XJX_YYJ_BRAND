//
//  YYOrderPayLogCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/4/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderPayLogCell.h"

@implementation YYOrderPayLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCellInfo:(NSArray *)value{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _dotView.layer.cornerRadius = 2.5;
    _infoLabel.adjustsFontSizeToFitWidth = YES;
    _infoLabel.text = [value objectAtIndex:0];
}
@end
