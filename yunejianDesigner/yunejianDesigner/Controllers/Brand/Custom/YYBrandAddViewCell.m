//
//  YYBrandAddViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/2/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandAddViewCell.h"

#import "UIImage+Tint.h"

@implementation YYBrandAddViewCell
-(void)updateUI{
    _addBtn.layer.cornerRadius = 2.5;
//    UIImage *icon = [UIImage imageNamed:@"addbrand_icon"];
//    [_addBtn setImage:[icon imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [_addBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    [_addBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    _addImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _addImageView.layer.borderWidth = 1;
    _addImageView.layer.cornerRadius = 25;
    _addImageView.layer.masksToBounds = YES;
}
- (IBAction)addBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"addBrand"]];
    }
}
-(void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        _addBtn.backgroundColor = [UIColor colorWithHex:@"efefef"];
    }else{
        _addBtn.backgroundColor = [UIColor whiteColor];
    }
}
@end
