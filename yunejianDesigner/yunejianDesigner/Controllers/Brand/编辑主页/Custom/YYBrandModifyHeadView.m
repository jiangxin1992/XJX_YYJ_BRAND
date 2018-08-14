//
//  YYBrandModifyHeadView.m
//  yunejianDesigner
//
//  Created by yyj on 2017/2/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYBrandModifyHeadView.h"

@implementation YYBrandModifyHeadView

-(instancetype)initWithTitle:(NSString *)title;
{
    self=[super init];
    if(self){
        self.backgroundColor = _define_white_color;
        UIView *downline = [UIView getCustomViewWithColor:_define_black_color];
        [self addSubview:downline];
        [downline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(2);
        }];
        
        UILabel *titleLabel = [UILabel getLabelWithAlignment:0 WithTitle:title WithFont:16.0f WithTextColor:_define_black_color WithSpacing:0];
        [self addSubview:titleLabel];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(16);
            make.bottom.mas_equalTo(-15);
        }];
    }
    return self;
}

@end
