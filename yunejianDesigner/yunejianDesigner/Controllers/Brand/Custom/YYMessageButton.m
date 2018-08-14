//
//  YYMessageButton.m
//  Yunejian
//
//  Created by Apple on 15/10/29.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYMessageButton.h"

@implementation YYMessageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
static NSInteger numFontSize =15;
- (void)initButton:(NSString *)title{
    __weak UIView *_weakView = self;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    self.titleLabel.text = title;
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.titleLabel];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakView.mas_top);
        make.left.equalTo(_weakView.mas_left);
        make.bottom.equalTo(_weakView.mas_bottom);
        make.right.equalTo(_weakView.mas_right).with.offset(-24);
    }];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"connmsg_icon"];
    
    [self addSubview:self.imageView];
//    __weak UIView *_weakTitleView = self.titleLabel;

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(19);
        make.height.mas_equalTo(19);
        make.center.mas_equalTo(_weakView);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    _numberLabel.backgroundColor = [UIColor colorWithHex:@"ef4e31"];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.font = [UIFont boldSystemFontOfSize:11];
    _numberLabel.numberOfLines = 1;
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.layer.cornerRadius = numFontSize/2;
    _numberLabel.layer.masksToBounds = YES;
    __weak UIView *_weakImageView = self.imageView;

    [self addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakImageView.mas_top).with.offset(-numFontSize/2-3);
        make.width.equalTo(@(numFontSize));
        make.height.equalTo(@(numFontSize));
        make.right.equalTo(_weakImageView.mas_right).with.offset(numFontSize/2);
    }];
}
-(void)initBackButton
{
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"goBack_normal"];
    [self addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(11);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(_imageView.superview);
        make.left.mas_equalTo(15);
    }];
}

- (void)updateButtonNumber:(NSString *)nowNumber{
    //__weak UIView *_weakView = self;
    __weak UIView *_weakImageView = self.imageView;

    //nowNumber = @"99";
    if (nowNumber && ![nowNumber isEqualToString:@""]) {
        if([nowNumber isEqualToString:@"dot"]){
            _numberLabel.text = @"";
            _numberLabel.hidden = NO;
            self.imageView.hidden = NO;
            NSInteger dotSize = 8;
            _numberLabel.layer.cornerRadius = dotSize/2;
            [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_weakImageView.mas_top).with.offset(-dotSize/2);
                make.width.equalTo(@(dotSize));
                make.height.equalTo(@(dotSize));
                make.right.equalTo(_weakImageView.mas_right).with.offset((dotSize)/2);
            }];
        }else{
            CGSize numTxtSize = [nowNumber sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:6]}];
            NSInteger numTxtWidth = numTxtSize.width;
            if ([nowNumber length] >= 3) {
                _numberLabel.text = @"···";//[NSString stringWithFormat:@"%@",nowNumber];
            }else{
                numTxtWidth += numFontSize/2;
                _numberLabel.text = nowNumber;
            }
            _numberLabel.hidden = NO;
            self.imageView.hidden = NO;
            numTxtWidth = MAX(numTxtWidth, numFontSize);
            _numberLabel.layer.cornerRadius = numFontSize/2;
            
            [self.numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_weakImageView.mas_top).with.offset(-numFontSize/2-3);
                make.width.equalTo(@(numTxtWidth));
                make.height.equalTo(@(numFontSize));
                make.right.equalTo(_weakImageView.mas_right).with.offset((numTxtWidth)/2);
            }];
        }
    }else{
        _numberLabel.hidden = YES;
        self.imageView.hidden = NO;
//        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(_weakView.mas_right).with.offset(0);
//        }];

    }
}
@end
