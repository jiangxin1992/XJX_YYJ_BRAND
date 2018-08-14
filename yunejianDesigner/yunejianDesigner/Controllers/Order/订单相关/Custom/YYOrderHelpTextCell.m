//
//  YYOrderHelpTextCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/4/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderHelpTextCell.h"
@implementation YYOrderHelpTextCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)updateCellInfo:(NSArray*)info{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLabel = [self.contentView viewWithTag:10001];
    
    
    NSString *infoStr = [info objectAtIndex:1];
    NSArray * infoStrArr = [infoStr componentsSeparatedByString:@"\n"];//
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.paragraphSpacing = ([infoStrArr count] > 0 ?6:0);
    paraStyle.lineSpacing = 4;
    NSDictionary *attrDict = @{ NSKernAttributeName: @(0),
                                NSParagraphStyleAttributeName: paraStyle
                                };
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString: infoStr attributes: attrDict];
    //titleLabel.text = [info objectAtIndex:1];
    _bottomLayoutConstraint.constant = [[info objectAtIndex:2] integerValue];
}

+(float)heightCell:(NSArray*)info{
    NSString *txt = [info objectAtIndex:1];
    NSArray * infoStrArr = [txt componentsSeparatedByString:@"\n"];//
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.paragraphSpacing = ([infoStrArr count] > 0 ?6:0);
    paraStyle.lineSpacing = 4;
    NSDictionary *attrDict = @{ NSKernAttributeName: @(0),NSFontAttributeName:[UIFont systemFontOfSize:13],
                                NSParagraphStyleAttributeName: paraStyle
                                };
    NSInteger bottomValue = [[info objectAtIndex:2] integerValue];
    float textHeight = getTxtHeight(SCREEN_WIDTH - 34*2, txt, attrDict);
    return textHeight + bottomValue;
}
@end
