//
//  YYDetailContentAdaptiveView.m
//  YunejianBuyer
//
//  Created by yyj on 2017/7/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYDetailContentAdaptiveView.h"

#import "regular.h"
#import "SCGIFImageView.h"

@interface YYDetailContentAdaptiveView()

@property (nonatomic,strong) UILabel *keyLabel;
@property (nonatomic,strong) UILabel *valueLabel;

@end

@implementation YYDetailContentAdaptiveView
#pragma mark - INIT
-(instancetype)initWithKey:(NSString *)key Value:(NSString *)value IsValueLineNum:(NSInteger )lineNum{
    self = [super init];
    if(self){
        _key = key;
        _value = value;
        _lineNum = lineNum;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData{}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig{
    _keyLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:13.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self addSubview:_keyLabel];
    [_keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(70);
    }];
    
    _valueLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:_valueLabel];
    _valueLabel.numberOfLines = _lineNum;
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(86);
        make.top.mas_equalTo(_keyLabel);
        make.right.mas_equalTo(-17);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark - updateUI
-(void)updateUI{
    _keyLabel.text = _key;
    _valueLabel.text = _value;
    
    BOOL keyIsNull = [NSString isNilOrEmpty:_key];
    BOOL valueIsNull = [NSString isNilOrEmpty:_value];
    if(keyIsNull){
        if(valueIsNull){
            [self keyLabelBottom:YES];
            [self valueLabelBottom:NO];
        }else{
            [self keyLabelBottom:NO];
            [self valueLabelBottom:YES];
        }
    }else{
        if(valueIsNull){
            [self keyLabelBottom:YES];
            [self valueLabelBottom:NO];
        }else{
            [self keyLabelBottom:NO];
            [self valueLabelBottom:YES];
        }
    }
}
#pragma mark - SomeAction
-(void)keyLabelBottom:(BOOL)isBottom{
    [_keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(70);
        if(isBottom){
            make.bottom.mas_equalTo(0);
        }
    }];
}
-(void)valueLabelBottom:(BOOL)isBottom{
    [_valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(86);
        make.top.mas_equalTo(_keyLabel);
        make.right.mas_equalTo(-17);
        if(isBottom){
            make.bottom.mas_equalTo(0);
        }
    }];
}
@end
