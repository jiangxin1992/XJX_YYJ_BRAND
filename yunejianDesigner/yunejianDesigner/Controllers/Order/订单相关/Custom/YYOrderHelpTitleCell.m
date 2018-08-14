//
//  YYOrderHelpTitleCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/4/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderHelpTitleCell.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
@implementation YYOrderHelpTitleCell

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
   // titleLabel.adjustsFontSizeToFitWidth = YES;
    NSString *txt = [info objectAtIndex:1];
    titleLabel.text = txt;
}

+(float)heightCell:(NSArray*)info{
    NSString *txt = [info objectAtIndex:1];
    float textHeight = getTxtHeight(SCREEN_WIDTH - 34*2, txt, @{NSFontAttributeName:[UIFont systemFontOfSize:15]});
    return 30+textHeight;
}
@end
