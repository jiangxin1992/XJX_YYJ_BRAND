//
//  YYBuyerInfoAboutTableViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerInfoAboutViewCell.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
@interface YYBuyerInfoAboutViewCell()
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;
@property (weak, nonatomic) IBOutlet UILabel *connBrandLabel;

@end

@implementation YYBuyerInfoAboutViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI{
    _descLabel.text = _homeInfoModel.introduction;
    NSString *_nation = [LanguageManager isEnglishLanguage]?_homeInfoModel.nationEn:_homeInfoModel.nation;
    NSString *_province = [LanguageManager isEnglishLanguage]?_homeInfoModel.provinceEn:_homeInfoModel.province;
    NSString *_city = [LanguageManager isEnglishLanguage]?_homeInfoModel.cityEn:_homeInfoModel.city;
    NSString *tempStr = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@ %@%@",nil),_nation,_province,_city];
    _addressLabel.text = [NSString stringWithFormat:@"%@ %@",tempStr,_homeInfoModel.addressDetail];
    float _addressLabelHeight = getTxtHeight(SCREEN_WIDTH-34, _descLabel.text, @{NSFontAttributeName:_descLabel.font});
    [_descLabel setConstraintConstant:_addressLabelHeight forAttribute:NSLayoutAttributeHeight];
    _webLabel.text = _homeInfoModel.webUrl;
    if(_homeInfoModel.copBrands && [_homeInfoModel.copBrands count] > 0){
        _connBrandLabel.text = [_homeInfoModel.copBrands componentsJoinedByString:@"，"];
        float _connBrandLabelHeight = getTxtHeight(SCREEN_WIDTH-34, _connBrandLabel.text, @{NSFontAttributeName:_connBrandLabel.font});
        [_connBrandLabel setConstraintConstant:_connBrandLabelHeight forAttribute:NSLayoutAttributeHeight];

    }else{
        _connBrandLabel.text = @"";
    }
}

+(float)cellHeight:(YYBuyerHomeInfoModel *)homeInfoModel{
    float _addressLabelHeight = getTxtHeight(SCREEN_WIDTH-34, homeInfoModel.introduction, @{NSFontAttributeName:[UIFont systemFontOfSize:12]});
    NSString *copBrands = [homeInfoModel.copBrands componentsJoinedByString:@"，"];
    float _connBrandLabelHeight = getTxtHeight(SCREEN_WIDTH-34, copBrands, @{NSFontAttributeName:[UIFont systemFontOfSize:12]});
    return 244+_addressLabelHeight+_connBrandLabelHeight;
}

@end
