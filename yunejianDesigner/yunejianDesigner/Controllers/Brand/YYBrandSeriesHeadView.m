//
//  YYBrandSeriesHeadView.m
//  yunejianDesigner
//
//  Created by yyj on 2018/1/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYBrandSeriesHeadView.h"

@interface YYBrandSeriesHeadView()

@property (nonatomic,strong) UIButton *addToCartButton;
@property (nonatomic,strong) UIButton *cancelAddToCartButton;
@property (nonatomic,strong) UIButton *sureAddToCartButton;

@end

@implementation YYBrandSeriesHeadView

#pragma mark - --------------生命周期--------------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    self.backgroundColor = _define_white_color;
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    _addToCartButton = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"加入购物车", nil) WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:_addToCartButton];
    [_addToCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(40);
    }];
    _addToCartButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_addToCartButton addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    _addToCartButton.backgroundColor = _define_black_color;
    _addToCartButton.layer.masksToBounds = YES;
    _addToCartButton.layer.cornerRadius = 3.0f;

    _cancelAddToCartButton = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"取消", nil) WithNormalColor:_define_black_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:_cancelAddToCartButton];
    [_cancelAddToCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(_addToCartButton);
    }];
    _cancelAddToCartButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_cancelAddToCartButton addTarget:self action:@selector(cancelAddToCart:) forControlEvents:UIControlEventTouchUpInside];
    _cancelAddToCartButton.backgroundColor = _define_white_color;
    _cancelAddToCartButton.layer.masksToBounds = YES;
    _cancelAddToCartButton.layer.cornerRadius = 3.0f;
    _cancelAddToCartButton.layer.borderColor = _define_black_color.CGColor;
    _cancelAddToCartButton.layer.borderWidth = 1;

    _sureAddToCartButton = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self addSubview:_sureAddToCartButton];
    [_sureAddToCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(_addToCartButton);
        make.width.mas_equalTo(_cancelAddToCartButton);
        make.left.mas_equalTo(_cancelAddToCartButton.mas_right).with.offset(12);
    }];
    _sureAddToCartButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_sureAddToCartButton addTarget:self action:@selector(sureToAddToCart:) forControlEvents:UIControlEventTouchUpInside];
    _sureAddToCartButton.backgroundColor = _define_black_color;
    _sureAddToCartButton.layer.masksToBounds = YES;
    _sureAddToCartButton.layer.cornerRadius = 3.0f;
    
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    if(_isSelect){
        _addToCartButton.hidden = YES;
        _cancelAddToCartButton.hidden = NO;
        _sureAddToCartButton.hidden = NO;
    }else{
        _addToCartButton.hidden = NO;
        if(self.orderDueCompareResult == NSOrderedAscending){
            _addToCartButton.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
        }else{
            _addToCartButton.backgroundColor = _define_black_color;
        }
        _cancelAddToCartButton.hidden = YES;
        _sureAddToCartButton.hidden = YES;
    }

    if(!_selectCount){
        [_sureAddToCartButton setTitle:NSLocalizedString(@"未选择", nil) forState:UIControlStateNormal];
        _sureAddToCartButton.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
    }else{
        [_sureAddToCartButton setTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"确定加入(%ld)", nil),_selectCount] forState:UIControlStateNormal];
        _sureAddToCartButton.backgroundColor = _define_black_color;
    }
}
#pragma mark - --------------请求数据----------------------
-(void)RequestData{}

#pragma mark - --------------自定义响应----------------------
//加入购物车
- (void)addToCart:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"addToCart"]];
    }
}
//取消购物车
- (void)cancelAddToCart:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"cancelAddToCart"]];
    }
}
//确认加入
- (void)sureToAddToCart:(id)sender {
    if (self.delegate) {
        if(_selectCount){
            [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"sureToAddToCart"]];
        }
    }
}

#pragma mark - --------------自定义方法----------------------

#pragma mark - --------------other----------------------


@end
