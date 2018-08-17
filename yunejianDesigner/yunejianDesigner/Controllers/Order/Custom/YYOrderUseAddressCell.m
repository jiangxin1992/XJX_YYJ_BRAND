//
//  YYOrderUseAddressCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderUseAddressCell.h"

#import "UIView+UpdateAutoLayoutConstraints.h"

@implementation YYOrderUseAddressCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeAddressHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:nil];
    }
}

-(void)updateUI{    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImageView *flagImgView = [self.contentView viewWithTag:10002];
    UILabel *addTipLabel = [self.contentView viewWithTag:10003];
    if (_buyerAddress) {
        NSString *showAddress = [self getAddressStr:_buyerAddress];
        //_addressLabel.text = showAddress;
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 8;
        NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                    NSFontAttributeName: [UIFont systemFontOfSize: 12] };
        
        _addressLabel.attributedText = [[NSAttributedString alloc] initWithString: showAddress attributes: attrDict];
        float txtheight = getTxtHeight(SCREEN_WIDTH-57, showAddress, attrDict);
        txtheight = MIN(38, txtheight);
        [_addressLabel setConstraintConstant:txtheight forAttribute:NSLayoutAttributeHeight];
        _receiveLabel.text = _buyerAddress.receiverName;
        _phoneLabel.text = _buyerAddress.receiverPhone;
        addTipLabel.text = @"";;
        flagImgView.hidden = NO;
    }else{
        _addressLabel.text = @"";
        _receiveLabel.text = @"";
        _phoneLabel.text = @"";
        addTipLabel.text = NSLocalizedString(@"添加收货地址",nil);
        flagImgView.hidden = YES;
    }

}

-(NSString *)getAddressStr:(YYOrderBuyerAddress *)address{
    if(address == nil){
        return @" ";
    }
    NSString *nationStr = [LanguageManager isEnglishLanguage]?address.nationEn:address.nation;
    NSString *provinceStr = [LanguageManager isEnglishLanguage]?address.provinceEn:address.province;
    NSString *cityStr = [LanguageManager isEnglishLanguage]?address.cityEn:address.city;
    if([address.defaultShipping integerValue] > 0){
        return [NSString stringWithFormat:NSLocalizedString(@"[默认]%@ %@%@%@ %@",nil),nationStr,getProvince(provinceStr), [NSString isNilOrEmpty:cityStr]?@"":cityStr, [NSString isNilOrEmpty:address.street]?@"":address.street, address.detailAddress];
    }else{
        return [NSString stringWithFormat:NSLocalizedString(@"%@ %@%@%@ %@",nil),nationStr,getProvince(provinceStr), [NSString isNilOrEmpty:cityStr]?@"":cityStr, [NSString isNilOrEmpty:address.street]?@"":address.street, address.detailAddress];
    }
}


@end
