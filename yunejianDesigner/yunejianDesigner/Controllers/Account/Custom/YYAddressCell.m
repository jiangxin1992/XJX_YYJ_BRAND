//
//  YYAddressCell.m
//  Yunejian
//
//  Created by yyj on 15/7/16.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYAddressCell.h"
#import "YYOrderBuyerAddress.h"

@interface YYAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation YYAddressCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if(highlighted){
        self.backgroundColor = [UIColor colorWithHex:@"efefef"];
    }else{
        self.backgroundColor = [UIColor colorWithHex:@"FFFFFF"];
    }
}

- (void)updateUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _phoneLabel.adjustsFontSizeToFitWidth = YES;
    if (_address) {
        _phoneLabel.textColor = [UIColor blackColor];
        _receiveLabel.textColor = [UIColor blackColor];
        [self updateAddressLabel:@"000000"];
        _receiveLabel.text = _address.receiverName;
        _phoneLabel.text = _address.receiverPhone;
    }else{
        _phoneLabel.textColor = [UIColor blackColor];
        _receiveLabel.textColor = [UIColor blackColor];
        _addressLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.backgroundColor = [UIColor colorWithHex:@"FFFFFF"];
        _addressLabel.text = @"";
        _receiveLabel.text = @"";
        _phoneLabel.text = @"";
    }
    
}

+(NSString *)getAddressStr:(YYAddress *)address{
    if(address == nil){
        return @" ";
    }
    NSString *nationStr = [LanguageManager isEnglishLanguage]?address.nationEn:address.nation;
    NSString *provinceStr = [LanguageManager isEnglishLanguage]?address.provinceEn:address.province;
    NSString *cityStr = [LanguageManager isEnglishLanguage]?address.cityEn:address.city;
    if(address.defaultShipping){
        
        return [NSString stringWithFormat:NSLocalizedString(@"[默认]%@ %@%@%@ %@",nil),nationStr,getProvince(provinceStr), [NSString isNilOrEmpty:cityStr]?@"":cityStr, [NSString isNilOrEmpty:address.street]?@"":address.street, address.detailAddress];
    }else{
        return [NSString stringWithFormat:NSLocalizedString(@"%@ %@%@%@ %@",nil),nationStr,getProvince(provinceStr), [NSString isNilOrEmpty:cityStr]?@"":cityStr, [NSString isNilOrEmpty:address.street]?@"":address.street, address.detailAddress];
    }
}

-(void)updateAddressLabel:(NSString *)colorStr{
    NSString *showAddress = [YYAddressCell getAddressStr:_address];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.3;
    NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                NSFontAttributeName: [UIFont systemFontOfSize: 13],NSForegroundColorAttributeName:[UIColor colorWithHex:colorStr] };
    NSMutableAttributedString *addressAttrStr = [[NSMutableAttributedString alloc] initWithString:showAddress attributes:attrDict];
    NSRange range = [showAddress rangeOfString:NSLocalizedString(@"[默认]",nil)];
    if(range.location != NSNotFound ){
        [addressAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"ed6498"] range:range];
    }
    _addressLabel.attributedText = addressAttrStr;
}

+(float)getCellHeight:(YYAddress *)address{
    NSString *showAddress = [YYAddressCell getAddressStr:address];
    NSInteger cellWidth = SCREEN_WIDTH - 17- 17;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.3;
    NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                NSFontAttributeName: [UIFont systemFontOfSize: 13] };
    float txtHeight = getTxtHeight(cellWidth, showAddress, attrDict);
    return 95 + txtHeight - 29;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            ((UIView *)[subView.subviews firstObject]).backgroundColor = [UIColor colorWithHex:@"5d5d5d"];
            ((UIView *)[subView.subviews firstObject]).layer.contents = (id)[UIImage imageNamed:@"styledelete_icon"].CGImage;
            ((UIView *)[subView.subviews firstObject]).layer.contentsGravity = kCAGravityCenter;
            ((UIView *)[subView.subviews firstObject]).layer.contentsScale = [UIScreen mainScreen].scale;
        }
    }
}

@end
