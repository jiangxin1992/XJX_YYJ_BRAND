//
//  YYNavView.m
//  YunejianBuyer
//
//  Created by yyj on 2017/6/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYNavView.h"

#define YY_ANIMATE_DURATION 0.2 //动画持续时间

@interface YYNavView ()

@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic,assign) BOOL haveStatusView;

@property (nonatomic,strong) UIView *superView;

@end

@implementation YYNavView
#pragma mark - INIT
-(instancetype)initWithTitle:(NSString *)title WithSuperView:(UIView *)superView haveStatusView:(BOOL )haveStatusView{
    self = [super init];
    if(self){
        
        _navTitle = title;
        _superView = superView;
        _haveStatusView = haveStatusView;
        
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title
{
    CGFloat width = 0;
    if(_isPad){
        width = 180;
    }else{
        if(IsPhone6_gt){
            width = 180;
        }else{
            width = 130;
        }
    }
    self = [super initWithFrame:CGRectMake(0, 0, width, 40)];
    if(self){
        
        _navTitle = title;
        
        _titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:_navTitle WithFont:17.0f WithTextColor:nil WithSpacing:0];
        [self addSubview:_titleLabel];
        _titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{
    _isAnimation = NO;
}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig{
    [_superView addSubview:self];
    self.backgroundColor = _define_white_color;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if(_haveStatusView){
            make.top.mas_equalTo(kStatusBarHeight);
            make.height.mas_equalTo(kNavigationBarHeight);
        }else{
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(kStatusBarAndNavigationBarHeight);
        }
    }];
    
    UIView *_bottomview = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"d3d3d3"]];
    [self addSubview:_bottomview];
    [_bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    _titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:_navTitle WithFont:18.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:_titleLabel];
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    _titleLabel.minimumScaleFactor = 0.6;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-1);
        make.centerX.mas_equalTo(self);
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(44);
    }];
}
-(void)setAnimationHide:(BOOL )isHide{
    if(self){
        if(isHide){
            //消失
            if(!self.hidden && !_isAnimation){
                _isAnimation = YES;
                self.alpha = 1.0f;
                [UIView animateWithDuration:YY_ANIMATE_DURATION animations:^{
                    self.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    _isAnimation = NO;
                    self.hidden = YES;
                }];
            }
        }else{
            //出现
            if(self.hidden && !_isAnimation){
                _isAnimation = YES;
                self.hidden = NO;
                self.alpha = 0.0f;
                [UIView animateWithDuration:YY_ANIMATE_DURATION animations:^{
                    self.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    _isAnimation = NO;
                    self.hidden = NO;
                }];
            }
        }
    }
}
-(void)setNavTitle:(NSString *)navTitle{
    _navTitle = navTitle;
    if(_titleLabel){
        _titleLabel.text = _navTitle;
    }
}
@end
