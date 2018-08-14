//
//  YYStepViewCell.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYStepViewCell.h"

@interface YYStepViewCell()

@property (nonatomic, assign) StepStyle style;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *firstTitleLabel;
@property (nonatomic, strong) UILabel *secondTitleLabel;
@property (nonatomic, strong) UILabel *thirdTitleLabel;
@property (nonatomic, strong) UILabel *fourthTitleLabel;
@property (nonatomic, strong) UIView *firstStepView;
@property (nonatomic, strong) UIView *secondStepView;
@property (nonatomic, strong) UIView *thirdStepView;
@property (nonatomic, strong) UIView *fourthStepView;
@property (nonatomic, strong) UILabel *firstNumLabel;
@property (nonatomic, strong) UILabel *secondNumLabel;
@property (nonatomic, strong) UILabel *thirdNumLabel;
@property (nonatomic, strong) UILabel *fourthNumLabel;

@end

@implementation YYStepViewCell

- (instancetype)initWithStepStyle:(StepStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.style = style;
        self.contentView.backgroundColor = _define_white_color;
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = _define_black_color;
        [self.contentView addSubview:self.lineView];
        __weak typeof (self)weakSelf = self;
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.equalTo(weakSelf.contentView.mas_top).with.offset(55);
            make.left.equalTo(weakSelf.contentView.mas_left).with.offset(10);
            make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-10);
        }];
        
        self.firstTitleLabel = [[UILabel alloc] init];
        self.firstTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.firstTitleLabel.font = [UIFont systemFontOfSize:13];
        self.secondTitleLabel = [[UILabel alloc] init];
        self.secondTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.secondTitleLabel.font = [UIFont systemFontOfSize:13];
        self.thirdTitleLabel = [[UILabel alloc] init];
        self.thirdTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.thirdTitleLabel.font = [UIFont systemFontOfSize:13];
        self.fourthTitleLabel = [[UILabel alloc] init];
        self.fourthTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.fourthTitleLabel.font = [UIFont systemFontOfSize:13];
        self.firstStepView = [[UIView alloc] init];
        self.firstStepView.backgroundColor = _define_white_color;
        self.secondStepView = [[UIView alloc] init];
        self.secondStepView.backgroundColor = _define_white_color;
        self.thirdStepView = [[UIView alloc] init];
        self.thirdStepView.backgroundColor = _define_white_color;
        self.fourthStepView = [[UIView alloc] init];
        self.fourthStepView.backgroundColor = _define_white_color;
        self.firstNumLabel = [[UILabel alloc] init];
        self.firstNumLabel.text = @"1";
        self.firstNumLabel.textAlignment = NSTextAlignmentCenter;
        self.firstNumLabel.font = [UIFont systemFontOfSize:14];
        self.firstNumLabel.layer.cornerRadius = 11.5;
        self.firstNumLabel.layer.masksToBounds = YES;
        self.secondNumLabel = [[UILabel alloc] init];
        self.secondNumLabel.text = @"2";
        self.secondNumLabel.textAlignment = NSTextAlignmentCenter;
        self.secondNumLabel.font = [UIFont systemFontOfSize:14];
        self.secondNumLabel.layer.cornerRadius = 11.5;
        self.secondNumLabel.layer.masksToBounds = YES;
        self.thirdNumLabel = [[UILabel alloc] init];
        self.thirdNumLabel.text = @"3";
        self.thirdNumLabel.textAlignment = NSTextAlignmentCenter;
        self.thirdNumLabel.font = [UIFont systemFontOfSize:14];
        self.thirdNumLabel.layer.cornerRadius = 11.5;
        self.thirdNumLabel.layer.masksToBounds = YES;
        self.fourthNumLabel = [[UILabel alloc] init];
        self.fourthNumLabel.text = @"4";
        self.fourthNumLabel.textAlignment = NSTextAlignmentCenter;
        self.fourthNumLabel.font = [UIFont systemFontOfSize:14];
        self.fourthNumLabel.layer.cornerRadius = 11.5;
        self.fourthNumLabel.layer.masksToBounds = YES;
        [self.firstStepView addSubview:self.firstNumLabel];
        [self.secondStepView addSubview:self.secondNumLabel];
        [self.firstNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.firstStepView).with.insets(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
        [self.secondNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.secondStepView).with.insets(UIEdgeInsetsMake(8, 8, 8, 8));
        }];
        
        [self.contentView addSubview:self.firstTitleLabel];
        [self.contentView addSubview:self.firstStepView];
        [self.contentView addSubview:self.secondTitleLabel];
        [self.contentView addSubview:self.secondStepView];
        
        [self.firstTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).with.offset(20);
            make.left.equalTo(weakSelf.contentView.mas_left).with.offset(10);
        }];
        [self.secondTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.firstTitleLabel.mas_top);
            make.left.equalTo(weakSelf.firstTitleLabel.mas_right).with.offset(-20);
            make.width.equalTo(weakSelf.firstTitleLabel.mas_width);
        }];
        [self.firstStepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(39);
            make.height.mas_equalTo(39);
            make.centerX.equalTo(weakSelf.firstTitleLabel.mas_centerX);
            make.centerY.equalTo(weakSelf.lineView.mas_centerY);
        }];
        [self.secondStepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(39);
            make.height.mas_equalTo(39);
            make.centerX.equalTo(weakSelf.secondTitleLabel.mas_centerX);
            make.centerY.equalTo(weakSelf.lineView.mas_centerY);
        }];
        
        switch (self.style) {
            case StepStyleThreeStep: {
                [self.thirdStepView addSubview:self.thirdNumLabel];
                [self.contentView addSubview:self.thirdTitleLabel];
                [self.contentView addSubview:self.thirdStepView];
                
                [self.thirdNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.thirdStepView).with.insets(UIEdgeInsetsMake(8, 8, 8, 8));
                }];
                [self.thirdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.secondTitleLabel.mas_top);
                    make.left.equalTo(weakSelf.secondTitleLabel.mas_right).with.offset(-20);
                    make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-10);
                    make.width.equalTo(weakSelf.firstTitleLabel.mas_width);
                }];
                [self.thirdStepView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(39);
                    make.height.mas_equalTo(39);
                    make.centerX.equalTo(weakSelf.thirdTitleLabel.mas_centerX);
                    make.centerY.equalTo(weakSelf.lineView.mas_centerY);
                }];
                break;
            }
                
            case StepStyleFourStep: {
                [self.thirdStepView addSubview:self.thirdNumLabel];
                [self.fourthStepView addSubview:self.fourthNumLabel];
                [self.contentView addSubview:self.thirdTitleLabel];
                [self.contentView addSubview:self.fourthTitleLabel];
                [self.contentView addSubview:self.thirdStepView];
                [self.contentView addSubview:self.fourthStepView];
                
                [self.thirdNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.thirdStepView).with.insets(UIEdgeInsetsMake(8, 8, 8, 8));
                }];
                [self.fourthNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(weakSelf.fourthStepView).with.insets(UIEdgeInsetsMake(8, 8, 8, 8));
                }];
                [self.thirdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.secondTitleLabel.mas_top);
                    make.left.equalTo(weakSelf.secondTitleLabel.mas_right).with.offset(-20);
                    make.width.equalTo(weakSelf.firstTitleLabel.mas_width);
                }];
                [self.thirdStepView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(39);
                    make.height.mas_equalTo(39);
                    make.centerX.equalTo(weakSelf.thirdTitleLabel.mas_centerX);
                    make.centerY.equalTo(weakSelf.lineView.mas_centerY);
                }];
                [self.fourthTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(weakSelf.thirdTitleLabel.mas_top);
                    make.left.equalTo(weakSelf.thirdTitleLabel.mas_right).with.offset(-20);
                    make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-10);
                    make.width.equalTo(weakSelf.firstTitleLabel.mas_width);
                }];
                [self.fourthStepView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(39);
                    make.height.mas_equalTo(39);
                    make.centerX.equalTo(weakSelf.fourthTitleLabel.mas_centerX);
                    make.centerY.equalTo(weakSelf.lineView.mas_centerY);
                }];
                break;
            }
                
            default:
                break;
        }
    }
    return self;
}

- (void)updateUI {
    NSArray *numberLabels = nil;
    NSArray *titleLabels = nil;
    self.firstTitleLabel.text = self.firtTitle;
    self.secondTitleLabel.text = self.secondTitle;
    self.thirdTitleLabel.text = self.thirdTitle;
    if (self.style == StepStyleFourStep) {
        self.fourthTitleLabel.text = self.fourthTitle;
        numberLabels = @[self.firstNumLabel, self.secondNumLabel, self.thirdNumLabel, self.fourthNumLabel];
        titleLabels = @[self.firstTitleLabel, self.secondTitleLabel, self.thirdTitleLabel, self.fourthTitleLabel];
    } else if (self.style == StepStyleThreeStep) {
        numberLabels = @[self.firstNumLabel, self.secondNumLabel, self.thirdNumLabel];
        titleLabels = @[self.firstTitleLabel, self.secondTitleLabel, self.thirdTitleLabel];
    }
    [numberLabels enumerateObjectsUsingBlock:^(UILabel *numberLabel, NSUInteger idx, BOOL *stop) {
        UILabel *titleLabel = titleLabels[idx];
        if (idx <= self.currentStep) {
            titleLabel.textColor = _define_black_color;
            numberLabel.layer.borderColor = _define_black_color.CGColor;
            numberLabel.layer.borderWidth = 4;
            numberLabel.backgroundColor = _define_black_color;
            numberLabel.textColor = _define_white_color;
        } else {
            titleLabel.textColor = [UIColor colorWithHex:@"919191"];
            numberLabel.layer.borderColor = [UIColor colorWithHex:@"919191"].CGColor;
            numberLabel.layer.borderWidth = 1;
            numberLabel.backgroundColor = _define_white_color;
            numberLabel.textColor = [UIColor colorWithHex:@"919191"];
        }
    }];
}

@end
