//
//  YYConnInfoListCell.m
//  Yunejian
//
//  Created by Apple on 15/12/1.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYConnInfoListCell.h"

@implementation YYConnInfoListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI{
    self.imageView.layer.borderColor = [UIColor colorWithHex:kDefaultImageColor].CGColor;
    self.imageView.layer.borderWidth = 1;
    //self.imageView.image = [UIImage imageNamed:@"buyer_icon"];
    if(_buyermodel.logoPath != nil && ![_buyermodel.logoPath isEqualToString:@""]){
        sd_downloadWebImageWithRelativePath(NO, _buyermodel.logoPath, _buyerImageView, kLogoCover, 0);
    }else{
        UIImage *defaultImage = [UIImage imageNamed:@"default_icon"];//[UIImage imageWithColor:[UIColor colorWithHex:@"FFFFFF"] size:_buyerImageView.frame.size];
        _buyerImageView.image = defaultImage;
       // sd_downloadWebImageWithRelativePath(NO, @"", _buyerImageView, kLogoCover, 0);
    }
    self.nameLabel.text = _buyermodel.buyerName;
    self.emailLable.text = _buyermodel.email;
    
    NSString *_nation = [LanguageManager isEnglishLanguage]?_buyermodel.nationEn:_buyermodel.nation;
    NSString *_province = [LanguageManager isEnglishLanguage]?_buyermodel.provinceEn:_buyermodel.province;
    NSString *_city = [LanguageManager isEnglishLanguage]?_buyermodel.cityEn:_buyermodel.city;
    
    self.cityLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ %@%@",nil),_nation,_province,_city];

    if([_buyermodel.status integerValue] == 0){
        [self.oprateBtn setTitle:NSLocalizedString(@"— 取消邀请",nil) forState:UIControlStateNormal];
    }else if([_buyermodel.status integerValue] == 1){
        [self.oprateBtn setTitle:NSLocalizedString(@"— 解除合作",nil) forState:UIControlStateNormal];
    }
}

- (IBAction)oprateBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:nil];
    }
}
@end
