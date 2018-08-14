//
//  YYOrderColseProgressCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/4/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderColseProgressCell.h"

@implementation YYOrderColseProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI{
    UIView *lineView = nil;
    UILabel *titleLabel = nil;
    UILabel *progressNumLabel = nil;
    UIColor *color = nil;
    for (NSInteger i=1; i<=3; i++) {
        titleLabel= [self valueForKey:[NSString stringWithFormat:@"titleLabel%ld",i]];
        titleLabel.text = [_titleArr objectAtIndex:(i-1)];
        progressNumLabel= [self valueForKey:[NSString stringWithFormat:@"progressNumLabel%ld",i]];
        progressNumLabel.layer.cornerRadius = 10;
        progressNumLabel.layer.borderWidth = 2
        ;
        if(i<=_progressValue){
            color = [UIColor colorWithHex:@"ed6498"];
            titleLabel.textColor = [UIColor colorWithHex:@"919191"];
        }else{
            color = [UIColor colorWithHex:@"d3d3d3"];
            titleLabel.textColor = [UIColor colorWithHex:@"d3d3d3"];

        }
        progressNumLabel.layer.borderColor = color.CGColor;
        progressNumLabel.textColor= color;
        if(i > 1){
            lineView = [self valueForKey:[NSString stringWithFormat:@"progressLine%ld",(i-1)]];
            lineView.backgroundColor = color;
        }
    }
}
@end
