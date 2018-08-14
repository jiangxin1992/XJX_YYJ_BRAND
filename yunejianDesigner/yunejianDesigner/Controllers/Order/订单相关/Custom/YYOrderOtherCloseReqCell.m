//
//  YYOrderOtherCloseReqCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderOtherCloseReqCell.h"

@implementation YYOrderOtherCloseReqCell

-(void)updateUI{
    _orderStatusBtn1.layer.cornerRadius = 2.5;
    _orderStatusBtn1.layer.masksToBounds = YES;
    _orderStatusBtn1.layer.borderColor = [UIColor colorWithHex:@"afafaf"].CGColor;
    _orderStatusBtn1.layer.borderWidth = 1;
    _orderStatusBtn2.layer.cornerRadius = 2.5;
    _orderStatusBtn2.layer.masksToBounds = YES;
    _orderStatusBtn2.layer.borderColor = [UIColor colorWithHex:@"afafaf"].CGColor;
    _orderStatusBtn2.layer.borderWidth = 1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _orderStatusBtn1.titleLabel.adjustsFontSizeToFitWidth = YES;
    _orderStatusBtn2.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    NSArray *tempArr = @[_titleLabel,_titleLabel1,_titleLabel2,_titleLabel3];
    for (int i = 0; i<tempArr.count; i++) {
        UILabel *tempLabel = tempArr[i];
        //行距设置
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:tempLabel.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:i==0?6:8];//行距的大小
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, tempLabel.text.length)];
        tempLabel.attributedText = attributedString;
    }
    
    if([LanguageManager isEnglishLanguage]){
        _orderStatusBtnWidthLayout1.constant = 150;
        _orderStatusBtnWidthLayout2.constant = 150;
    }else{
        _orderStatusBtnWidthLayout1.constant = 88;
        _orderStatusBtnWidthLayout2.constant = 88;
    }
}

- (IBAction)oprateBtnHandler1:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"agreeReqClose"]];
    }
}
- (IBAction)oprateBtnHandler2:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"refuseReqClose"]];
    }
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
