//
//  YYBrandIntroductionViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandIntroductionViewCell.h"
@implementation YYBrandIntroductionViewCell
static NSInteger cellWidth = 0;

-(void)updateUI{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.3;
    paraStyle.hyphenationFactor = 0.9;
    NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                NSFontAttributeName: [UIFont systemFontOfSize: 12] };
    _brandDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _brandDescLabel.attributedText = [[NSAttributedString alloc] initWithString: _descStr attributes: attrDict];
}
+(float)HeightForCell:(NSString *)desc{
    if([desc isEqualToString:@""]){
        return 0.1;
    }
    cellWidth = SCREEN_WIDTH-24;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.3;
    paraStyle.hyphenationFactor = 0.9;
    NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                NSFontAttributeName: [UIFont systemFontOfSize: 12] };

    float textTotalHeight = getTxtHeight(cellWidth, desc, attrDict);
    return 90+textTotalHeight;
}
@end
