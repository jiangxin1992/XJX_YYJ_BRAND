//
//  YYOrderHelpNumTextCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/4/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderHelpNumTextCell.h"

@implementation YYOrderHelpNumTextCell

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
    NSString *titleInfo = [info objectAtIndex:1];
    NSArray *titleInfoArr = [titleInfo componentsSeparatedByString:@"|"];
    UILabel *numLabel = [self.contentView viewWithTag:10001];
    numLabel.text = [titleInfoArr objectAtIndex:0];
    numLabel.layer.cornerRadius = 9.5;
    numLabel.layer.masksToBounds = YES;
    numLabel.layer.borderWidth = 2;
    numLabel.layer.borderColor = [UIColor colorWithHex:@"ED6498"].CGColor;

    
    UILabel *titleLabel = [self.contentView viewWithTag:10002];
    titleLabel.text = [titleInfoArr objectAtIndex:1];
    
    UILabel *broderLabel = [self.contentView viewWithTag:10003];
    broderLabel.layer.borderWidth = 1;
    broderLabel.layer.borderColor = [UIColor colorWithHex:@"D3d3d3"].CGColor;
    broderLabel.layer.cornerRadius = 2.5;
    UILabel *infoLabel = [self.contentView viewWithTag:10004];
    infoLabel.text = [info objectAtIndex:2];
    NSInteger bottomValue = [[info objectAtIndex:3] integerValue];
    _spaceLayoutConstriant.constant = bottomValue;
}

+(float)heightCell:(NSArray*)info{
    NSString *txt = [info objectAtIndex:2];
    NSInteger bottomValue = [[info objectAtIndex:3] integerValue];

    float textHeight = getTxtHeight(SCREEN_WIDTH - 34-17-120 -20, txt, @{NSFontAttributeName:[UIFont systemFontOfSize:13]});
    return bottomValue +textHeight +20;
}
@end
