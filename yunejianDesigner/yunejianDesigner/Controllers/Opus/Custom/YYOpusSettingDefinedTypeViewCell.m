//
//  YYOpusSettingDefinedTypeViewCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOpusSettingDefinedTypeViewCell.h"

@implementation YYOpusSettingDefinedTypeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI{
    NSString *colorStr = nil;
    if(_type == 0){
        _tipLabel.text = NSLocalizedString(@"只给这些买手店看",nil);
        _titleLabel.text = NSLocalizedString(@"白名单",nil);
        _statusImageView.image = [UIImage imageNamed:@"green_hook_img"];
        if(_type == _selectedType){
            _lineView.hidden = NO;
        }else{
            _lineView.hidden = YES;
        }
        colorStr = @"58C776";
    }else{
        _tipLabel.text = NSLocalizedString(@"不给这些买手店看",nil);
        _titleLabel.text = NSLocalizedString(@"黑名单",nil);
        _statusImageView.image = [UIImage imageNamed:@"red_hook_img"];
        _lineView.hidden = NO;
        colorStr = @"ef4e31";
    }
    if(_type == _selectedType){
        [_statusBtn setImage:[UIImage imageNamed:@"hide_arrow_icon"] forState:UIControlStateNormal];
        _statusImageView.hidden = NO;
        _selectedInfoLabel.hidden = NO;
        NSString *selectedCountStr = [NSString stringWithFormat:@"%ld",(long)_selectedCount];
        NSString *selectedInfo = [NSString stringWithFormat:NSLocalizedString(@"%@个已选中",nil),selectedCountStr];
        NSRange range = [selectedInfo rangeOfString:selectedCountStr];
        NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:selectedInfo attributes:@{NSFontAttributeName:_selectedInfoLabel.font}];
        if(range.location != NSNotFound){
            [mutableAttributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:colorStr]} range:range];
        }
        _selectedInfoLabel.attributedText = mutableAttributedStr;
    }else{
        [_statusBtn setImage:[UIImage imageNamed:@"show_arrow_icon"] forState:UIControlStateNormal];
        _statusImageView.hidden = YES;
        _selectedInfoLabel.hidden = YES;
    }
}
- (IBAction)selectedHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:0 section:_type andParmas:@[@"selectedtype"]];
    }
}
@end
