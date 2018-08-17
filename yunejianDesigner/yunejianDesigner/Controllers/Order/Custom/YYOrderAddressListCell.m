//
//  YYOrderAddressListCell.m
//  Yunejian
//
//  Created by Apple on 15/10/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYOrderAddressListCell.h"

#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

@implementation YYOrderAddressListCell
-(void)updateUI{
    
//    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
//    if((_curModel.contactEmail == nil && _infoModel.contactEmail == nil) || ([_curModel.contactEmail isEqualToString:_infoModel.contactEmail] )){
////        self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
////        self.emailLabel.font = [UIFont boldSystemFontOfSize:15];
////        self.cityLabel.font = [UIFont boldSystemFontOfSize:15];
//        //self.backgroundColor = [UIColor colorWithHex:kDefaultImageColor];
//
//    }else{
////        self.nameLabel.font = [UIFont systemFontOfSize:15];
////        self.emailLabel.font = [UIFont systemFontOfSize:15];
////        self.cityLabel.font = [UIFont systemFontOfSize:15];
//        //self.backgroundColor = [UIColor whiteColor];
//
//    }
    self.nameLabel.text = self.infoModel.name;
    self.unregisterTiplabel.hidden = YES;
    CGFloat nameLabelSizeWidth = getWidthWithHeight(20, self.nameLabel.text, self.nameLabel.font);
    CGFloat width = 0;
    if(nameLabelSizeWidth>160.0f){
        width = 160.0f;
    }else{
        width = nameLabelSizeWidth;
    }
    [self.nameLabel setConstraintConstant:width forAttribute:NSLayoutAttributeWidth];
    
    if(self.infoModel.contactEmail){
        self.emailLabel.text = self.infoModel.contactEmail;
//        [self downloadLogoImageWithRelativePath:self.infoModel.logoPath andImageView:self.logoView];
        sd_downloadWebImageWithRelativePath(NO, self.infoModel.logoPath, self.logoView, kStyleColorImageCover, 0);
        if([self.infoModel.province isEqualToString:@""] && [self.infoModel.city isEqualToString:@""]){
            self.cityLabel.text = @"";
        }else{
            NSString *_nation = [LanguageManager isEnglishLanguage]?self.infoModel.nationEn:self.infoModel.nation;
            NSString *_province = [LanguageManager isEnglishLanguage]?self.infoModel.provinceEn:self.infoModel.province;
            NSString *_city = [LanguageManager isEnglishLanguage]?self.infoModel.cityEn:self.infoModel.city;
            self.cityLabel.text = [NSString stringWithFormat:@"(%@ %@ %@)",_nation,_province,_city];
        }
        self.nameLabel1.text = @"";
    }else{
//        sd_downloadWebImageWithRelativePath(NO, @"", self.logoView, kStyleColorImageCover, 0);
        UIImage *defaultImage = [UIImage imageNamed:@"buyer_icon"];//[UIImage imageWithColor:[UIColor colorWithHex:kDefaultImageColor] size:self.logoView.frame.size];
        self.logoView.image = defaultImage;
        self.emailLabel.text = @"";
        self.cityLabel.text = @"";
        self.unregisterTiplabel.hidden = NO;
        self.nameLabel1.text = self.infoModel.name;
        self.nameLabel.text = @"";
    }
}

//- (void)downloadLogoImageWithRelativePath:(NSString *)imageRelativePath andImageView:(SCGIFImageView *)imageView{
//    sd_downloadWebImageWithRelativePath(NO, imageRelativePath, imageView, kStyleColorImageCover, 0);
//}
@end
