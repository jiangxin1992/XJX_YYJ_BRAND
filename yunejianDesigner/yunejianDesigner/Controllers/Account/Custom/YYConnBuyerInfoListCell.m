//
//  YYConnBuyerListCell.m
//  Yunejian
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYConnBuyerInfoListCell.h"

#import "UIImage+Tint.h"
#import "UIImage+YYImage.h"

@implementation YYConnBuyerInfoListCell

-(void)updateUI{
   // self.imageView.layer.borderColor = [UIColor colorWithHex:kDefaultImageColor].CGColor;
   // self.imageView.layer.borderWidth = 1;
    //self.imageView.image = [UIImage imageNamed:@"buyer_icon"];
    if (_isModity == NO) {
        _oprateBtn.hidden = YES;
        _contentLayoutTopConstraint.constant = 18;
        if(!isFirstUpdate){
        [_buttomView layoutIfNeeded];
        [UIView animateWithDuration:1 animations:^{
            _bottomViewLayoutTopConstraint.constant = 115;
            [_buttomView layoutIfNeeded];
        }];
        }else{
            _bottomViewLayoutTopConstraint.constant = 115;
        }
        UIImage *defaultImage = [UIImage imageNamed:@"default_icon"];
        _buyerImageView.image = defaultImage;
        //sd_downloadWebImageWithRelativePath(NO, @"", _buyerImageView, kLogoCover, 0);
    }else{
        _oprateBtn.hidden = NO;
         _contentLayoutTopConstraint.constant = 30;
        if(!isFirstUpdate){
        [_buttomView layoutIfNeeded];
        [UIView animateWithDuration:1 animations:^{
            _bottomViewLayoutTopConstraint.constant = 0;
            [_buttomView layoutIfNeeded];
        }];
        }else{
           _bottomViewLayoutTopConstraint.constant = 0;
        }
        
        UIImage *defaultImage = [UIImage imageNamed:@"default_icon"];//[UIImage imageWithColor:[UIColor colorWithHex:@"FFFFFF"] size:_buyerImageView.frame.size];
        _buyerImageView.image = defaultImage;
    }
    
    if(!isFirstUpdate){
        isFirstUpdate = YES;
    }
    
    if(_buyermodel.logoPath != nil && ![_buyermodel.logoPath isEqualToString:@""]){
        sd_downloadWebImageWithRelativePath(NO, _buyermodel.logoPath, _buyerImageView, kLogoCover, 0);
    }else{

    }
    self.nameLabel.text = _buyermodel.buyerName;
    // self.emailLable.text = _buyermodel.email;
    
    NSString *_nation = [LanguageManager isEnglishLanguage]?_buyermodel.nationEn:_buyermodel.nation;
    NSString *_province = [LanguageManager isEnglishLanguage]?_buyermodel.provinceEn:_buyermodel.province;
    NSString *_city = [LanguageManager isEnglishLanguage]?_buyermodel.cityEn:_buyermodel.city;
    
    self.cityLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ %@%@",nil),_nation,_province,_city];
    

    UIImage *btnImage = nil;
    if([_buyermodel.status integerValue] == 1){
        btnImage = [UIImage imageNamed:@"conn_cancel_icon"] ;
    }else{
        btnImage = [UIImage imageNamed:@"conn_refuse_icon"] ;
    }
    self.oprateBtn.backgroundColor = [UIColor whiteColor];
    [self.oprateBtn setImage:btnImage forState:UIControlStateNormal];

}

- (IBAction)oprateBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:nil];
    }
}
@end
