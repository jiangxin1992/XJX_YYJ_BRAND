//
//  YYOpusSettingDefinedBuyerViewCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOpusSettingDefinedBuyerViewCell.h"

@implementation YYOpusSettingDefinedBuyerViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_type == 0){
        [_statusBtn setImage:[UIImage imageNamed:@"opus_selected_green_icon"] forState:UIControlStateSelected];
    }else{
        [_statusBtn setImage:[UIImage imageNamed:@"opus_selected_red_icon"] forState:UIControlStateSelected];
    }
}
@end
