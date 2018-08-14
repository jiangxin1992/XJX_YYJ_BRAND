//
//  YYBuyerModifyInfoTxtViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandModifyInfoTxtViewCell.h"

@implementation YYBrandModifyInfoTxtViewCell

-(void)downlineIsHide:(BOOL )ishide
{
    _downline.hidden = ishide;
}

- (IBAction)selectHandler:(id)sender {
    if([self.titleLabel.text isEqualToString:NSLocalizedString(@"网站",nil)])
    {
        if(self.selectedValue){
            self.selectedValue([[NSString alloc] initWithFormat:@"webUrl=%@",self.valueLabel.text]);
        }
    }else if([self.titleLabel.text isEqualToString:NSLocalizedString(@"详细地址",nil)])
    {
        if(self.selectedValue){
            self.selectedValue([[NSString alloc] initWithFormat:@"addressDetail=%@",self.valueLabel.text]);
        }
    }
    else if([self.titleLabel.text isEqualToString:NSLocalizedString(@"列举三个合作买手店",nil)])
    {
        if(self.selectedValue){
            self.selectedValue(@"");
        }
    }else if([self.titleLabel.text isEqualToString:NSLocalizedString(@"品牌简介",nil)])
    {
        if(self.selectedValue){
            self.selectedValue([[NSString alloc] initWithFormat:@"brandIntroduction=%@",self.valueLabel.text]);
        }
    }else
    {
        if(self.selectedValue){
            self.selectedValue(@"");
        }
    }
}
#pragma mark - other
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
