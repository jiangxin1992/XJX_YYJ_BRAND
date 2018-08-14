//
//  YYBuyerViewCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerViewCell.h"

@implementation YYBuyerViewCell

-(void)updateUI{
    if(_infoModel && _infoModel.logoPath != nil){
        sd_downloadWebImageWithRelativePath(NO, _infoModel.logoPath, _logoImageView, kLogoCover, 0);
    }else{
        sd_downloadWebImageWithRelativePath(NO, @"", _logoImageView, kLogoCover, 0);
    }
    _logoImageView.layer.borderColor = [UIColor colorWithHex:kDefaultImageColor].CGColor;
    _logoImageView.layer.borderWidth = 2;
    _logoImageView.layer.cornerRadius = 25;
    _logoImageView.layer.masksToBounds = YES;
    
    _brandNameLabel.text = _infoModel.buyerName;
    
    NSString *_nation = [LanguageManager isEnglishLanguage]?_infoModel.nationEn:_infoModel.nation;
    NSString *_province = [LanguageManager isEnglishLanguage]?_infoModel.provinceEn:_infoModel.province;
    NSString *_city = [LanguageManager isEnglishLanguage]?_infoModel.cityEn:_infoModel.city;
    
    _emailLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@ %@%@",nil),_nation,_province,_city];
}
- (IBAction)infoBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:nil];
    }
}
- (IBAction)cancelBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[]];
    }
}
-(void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        self.backgroundColor = [UIColor colorWithHex:@"efefef"];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
