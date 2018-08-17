//
//  YYUserLogoInfoCell.m
//  Yunejian
//
//  Created by Apple on 15/9/22.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYUserLogoInfoCell.h"

@implementation YYUserLogoInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)changeLogoHandler:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(handlerBtnClick:)]){
        [self.delegate handlerBtnClick:sender];
    }
}

- (IBAction)settingBtnHandler:(id)sender {
    if(self.delegate && [self.delegate respondsToSelector:@selector(settingBtnClick:)]){
        [self.delegate settingBtnClick:sender];
    }
}



@end
