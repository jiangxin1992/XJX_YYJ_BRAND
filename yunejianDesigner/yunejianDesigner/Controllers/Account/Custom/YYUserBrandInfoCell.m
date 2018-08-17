//
//  YYUserBrandInfoCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/7/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYUserBrandInfoCell.h"

#import "UIImage+Tint.h"

@implementation YYUserBrandInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUI{
    
    _modifyButton.titleLabel.font = [UIFont systemFontOfSize:[LanguageManager isEnglishLanguage]?12.0f:15.0f];
    _modifyButton.layer.borderWidth = 1;
    _modifyButton.layer.cornerRadius = 2.5;
    _modifyButton.layer.masksToBounds = YES;
    if ([YYCurrentNetworkSpace isNetwork]
        && _userInfo) {
        _modifyButton.alpha = 1;
        //[_modifyButton setTitleColor:[UIColor colorWithHex:@"47a3dc"] forState:UIControlStateNormal];
    }else{
        _modifyButton.alpha = 2;
        //[_modifyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    NSString *titleStr = NSLocalizedString(@"品牌",nil);
    //NSString *btnStr = @"验证品牌信息";
    NSString *btnWaitingStr = NSLocalizedString(@"品牌正在审核中，请耐心等待",nil);
    NSString *tipStr = NSLocalizedString(@"请在 30 天内完成品牌信息验证",nil);
    NSString *rufuseTipStr = NSLocalizedString(@"审核被拒,请重新验证品牌信息",nil);
    
    _keyLabel.text = titleStr;
//    _valueLabel.text = _userInfo.brandName;
//    //_userInfo.status = @"305";
    if([_userInfo.status integerValue] == YYReqStatusCode305 || [_userInfo.status integerValue] == YYReqStatusCode301){
        _modifyButton.alpha = 1;
    }else{
        _modifyButton.alpha = 2;
    }
    [_keyLabel setAdjustsFontSizeToFitWidth:YES];
    [_tipLabel setAdjustsFontSizeToFitWidth:YES];

    if([_userInfo.status integerValue] == YYReqStatusCode305){
        //_keyLabel.text = tipStr;
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: tipStr];
        NSRange range = [tipStr rangeOfString:@"30"];
        if (range.location != NSNotFound) {
            [attributedStr addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithHex:@"ef4e31"] range: NSMakeRange(range.location, 2)];
        }
        _keyLabel.attributedText = attributedStr;
        _tipLabel.text = NSLocalizedString(@"未验证的品牌账号将被锁定",nil);
    }else if([_userInfo.status integerValue] == YYReqStatusCode300){
        _keyLabel.text = btnWaitingStr;
        _tipLabel.text = NSLocalizedString(@"未通过验证的品牌账号将被锁定",nil);
    }else if([_userInfo.status integerValue] == YYReqStatusCode301){
        _keyLabel.text = rufuseTipStr;
        _tipLabel.text = NSLocalizedString(@"未通过验证的品牌账号将被锁定",nil);
    }
    
    if(_modifyButton.alpha == 2){
        _modifyButton.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
        _modifyButton.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
        [_modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIImage *unenableimg = [[UIImage imageNamed:@"infobrandverify_icon"] imageWithTintColor:[UIColor whiteColor]];
        [_modifyButton setImage:unenableimg forState:UIControlStateNormal];
        [_modifyButton setImage:unenableimg forState:UIControlStateHighlighted];

    }else{
        _modifyButton.layer.borderColor = [UIColor blackColor].CGColor;
        _modifyButton.backgroundColor = [UIColor whiteColor];
        [_modifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_modifyButton setImage:[UIImage imageNamed:@"infobrandverify_icon"] forState:UIControlStateNormal];
    }
}

- (IBAction)buttonClicked:(id)sender{
    if (_modifyButtonClicked && _modifyButton.alpha == 1) {
        _modifyButtonClicked(_userInfo);
    }
}

@end
