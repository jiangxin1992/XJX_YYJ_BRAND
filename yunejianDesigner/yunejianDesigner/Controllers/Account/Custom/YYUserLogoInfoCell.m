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
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeLogoHandler:(id)sender {
    if(self.delegate != nil ){
        [self.delegate handlerBtnClick:sender];
    }
}

- (IBAction)settingBtnHandler:(id)sender {
    if(self.delegate != nil){
        [self.delegate settingBtnClick:sender];
    }
}



@end
