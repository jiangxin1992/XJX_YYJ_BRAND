//
//  YYBuyerModifyCellSubmitViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyCellSubmitViewCell.h"

#import "regular.h"

@interface YYBuyerModifyCellSubmitViewCell()
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
@implementation YYBuyerModifyCellSubmitViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _saveBtn.layer.cornerRadius = 2.5;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [regular dismissKeyborad];
}

- (IBAction)saveBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"save"]];
    }
}
@end
