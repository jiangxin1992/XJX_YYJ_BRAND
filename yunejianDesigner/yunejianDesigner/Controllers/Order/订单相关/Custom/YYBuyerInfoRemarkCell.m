//
//  YYBuyerInfoRemarkCell.m
//  Yunejian
//
//  Created by Apple on 15/10/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYBuyerInfoRemarkCell.h"

#import "UIImage+YYImage.h"

@implementation YYBuyerInfoRemarkCell
-(void)updateUI:(NSArray*)info{
    
    if([LanguageManager isEnglishLanguage]){
        _orderCodeWidthLayout.constant = 85;
        _orderCreateWidthLayout.constant = 85;
        _orderRemarkWidthLayout.constant = 85;
        _orderCreatePersonWidthLayout.constant = 85;
        _orderCreateOccasionWidthLayout.constant = 85;
    }else{
        _orderCodeWidthLayout.constant = 70;
        _orderCreateWidthLayout.constant = 70;
        _orderRemarkWidthLayout.constant = 70;
        _orderCreatePersonWidthLayout.constant = 70;
        _orderCreateOccasionWidthLayout.constant = 70;
    }
    
    self.orderCodeLabel.text = [info objectAtIndex:0];
    self.orderCreateTimerLabel.text = [info objectAtIndex:1];
    self.orderCreatePersonLabel.text = [info objectAtIndex:3];
    self.orderCreateOccasionLabel.text = [info objectAtIndex:4];
    NSString *remarkStr = [info objectAtIndex:2];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.1;
    NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                NSFontAttributeName: [UIFont systemFontOfSize: 12] };
    self.orderRemarkLabel.attributedText = [[NSAttributedString alloc] initWithString: remarkStr attributes: attrDict];
//    self.orderRemarkLabel.backgroundColor = [UIColor redColor];

//    self.txtView.backgroundColor = [UIColor colorWithHex:kDefaultImageColor];
}
+(NSInteger) getCellHeight:(NSString *)desc{
    NSInteger txtWidth = SCREEN_WIDTH - 34-70;
    NSInteger textHeight = 0;
    if([NSString isNilOrEmpty:desc]){
        textHeight = 16;
    }else{
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineHeightMultiple = 1.1;
        NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                    NSFontAttributeName: [UIFont systemFontOfSize: 12] };
        
        textHeight = getTxtHeight(txtWidth, desc, attrDict);
        // textHeight = getTxtHeight(txtWidth, desc, @{NSFontAttributeName:[UIFont systemFontOfSize:15]});
    }
    return 142 +13 + textHeight;
}
@end
