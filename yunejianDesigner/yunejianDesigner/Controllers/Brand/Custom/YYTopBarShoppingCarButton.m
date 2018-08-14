//
//  YYTopBarShoppingCarButton.m
//  Yunejian
//
//  Created by yyj on 15/7/24.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYTopBarShoppingCarButton.h"

#import "UIImage+YYImage.h"

@interface YYTopBarShoppingCarButton ()

@property(nonatomic,strong) UILabel *numberLabel;

@end

@implementation YYTopBarShoppingCarButton
static NSInteger numFontSize =15;
- (void)initButton{

    UILabel *numberLabel = [[UILabel alloc] init];
    self.numberLabel = numberLabel;
    _numberLabel.hidden = YES;
    _numberLabel.backgroundColor = [UIColor colorWithHex:@"ef4e31"];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.font = [UIFont boldSystemFontOfSize:11];
    _numberLabel.numberOfLines = 1;
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.layer.cornerRadius = numFontSize/2;
    _numberLabel.layer.masksToBounds = YES;
    UIImage *image = [UIImage imageNamed:@"topcar_icon"];//22  17
    [self setImage:image forState:UIControlStateNormal];


    [self setImage:[image imageByApplyingAlpha:0.6] forState:UIControlStateHighlighted];


    [self addSubview:numberLabel];
    //__weak UIView *_weakView = self;

    CGFloat self_x_p = 11;
    if(self.isRight){
        self_x_p = 24;
    }

    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(self_x_p));
        make.centerY.equalTo(@(-11.5));
        make.height.equalTo(@(numFontSize));
        make.width.equalTo(@(numFontSize/2));
    }];

}
- (void)initCircleButton{

    UILabel *numberLabel = [[UILabel alloc] init];
    self.numberLabel = numberLabel;
    _numberLabel.hidden = YES;
    _numberLabel.backgroundColor = [UIColor colorWithHex:@"ef4e31"];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.font = [UIFont boldSystemFontOfSize:11];
    _numberLabel.numberOfLines = 1;
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.layer.cornerRadius = numFontSize/2;
    _numberLabel.layer.masksToBounds = YES;
    UIImage *image = [UIImage imageNamed:@"topcar_circle_icon"];//22  17
    [self setImage:image forState:UIControlStateNormal];


    [self setImage:[image imageByApplyingAlpha:0.6] forState:UIControlStateHighlighted];


    [self addSubview:numberLabel];
    //__weak UIView *_weakView = self;
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(11));
        make.centerY.equalTo(@(-11.5));
        make.height.equalTo(@(numFontSize));
        make.width.equalTo(@(numFontSize/2));
    }];

}
- (void)updateButtonNumber:(NSString *)nowNumber{
    //nowNumber = @"991";
    if (nowNumber && [nowNumber integerValue] > 0) {
        _numberLabel.hidden = NO;
        CGSize numTxtSize = [nowNumber sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:6]}];
        NSInteger numTxtWidth = numTxtSize.width;
        if ([nowNumber length] >= 3) {
            _numberLabel.text = @"···";//[NSString stringWithFormat:@" %@",nowNumber];
        }else{
            _numberLabel.text = nowNumber;
            numTxtWidth += numFontSize/2;
        }
        numTxtWidth = MAX(numTxtWidth, numFontSize);
        [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(numTxtWidth));
        }];
    }else{
        _numberLabel.hidden = YES;
    }
}

@end
