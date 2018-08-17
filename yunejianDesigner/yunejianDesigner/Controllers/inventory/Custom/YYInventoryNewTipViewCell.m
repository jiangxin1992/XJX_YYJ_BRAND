//
//  YYInventoryNewTipViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/8/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYInventoryNewTipViewCell.h"

@implementation YYInventoryNewTipViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_currentType == 0){
        [_cellBtn setImage:[UIImage imageNamed:@"newhelp_icon"] forState: UIControlStateNormal];
        [_cellBtn setTitle:NSLocalizedString(@"我是新手",nil) forState: UIControlStateNormal];
    }else if(_currentType == 1){
        [_cellBtn setImage:[UIImage imageNamed:@"addcar_icon"] forState: UIControlStateNormal];
        [_cellBtn setTitle:NSLocalizedString(@"我要补货",nil) forState: UIControlStateNormal];

    }else if(_currentType == 2){
        [_cellBtn setImage:[UIImage imageNamed:@"addcar_icon"] forState: UIControlStateNormal];
        [_cellBtn setTitle:NSLocalizedString(@"我的库存",nil) forState: UIControlStateNormal];

    }
    [_cellBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];

}
- (IBAction)newTipHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"newHelpOrAdd"] ];
    }
    
}
@end
