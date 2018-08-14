//
//  YYMessagePersonalCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYMessagePersonalCell.h"

@implementation YYMessagePersonalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _logoImageView.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 23.5;
    _logoImageView.layer.borderWidth = 1;
    
    _timerLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.brandNameLabel.text = self.chatModel.oppositeName;
    self.msgContentLabel.text = self.chatModel.content;
    self.timerLabel.text = getShowDateByFormatAndTimeInterval(@"yy/MM/dd",[self.chatModel.createTime stringValue]);
    if(self.chatModel && self.chatModel.oppositeURL != nil){
        sd_downloadWebImageWithRelativePath(NO, self.chatModel.oppositeURL,_logoImageView, kLogoCover, 0);
    }else{
        sd_downloadWebImageWithRelativePath(NO, @"",_logoImageView, kLogoCover, 0);
    }

}
@end
