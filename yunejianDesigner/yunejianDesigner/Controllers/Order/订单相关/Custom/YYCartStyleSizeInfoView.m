//
//  YYCartStyleSizeInfoView.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYCartStyleSizeInfoView.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"
#import "YYShoppingStyleSizeInputView.h"

// 接口

// 分类
#import "UIImage+YYImage.h"
#import "UITextField+YYRectForBounds.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderOneColorModel.h"
#import "YYOrderSizeModel.h"
#import "YYOrderStyleModel.h"

@interface YYCartStyleSizeInfoView() <YYTableCellDelegate>

@property (nonatomic, strong) SCGIFImageView *sizeColorImage;
@property (nonatomic, strong) UIView *detailInfoView;
@property (nonatomic, strong) UILabel *sizeColorNameLabel;
@property (nonatomic, strong) UILabel *tradePriceLabel;
@property (nonatomic, strong) YYShoppingStyleSizeInputView *inputView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UILabel *receivedLabel;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, assign) NSInteger sizeStock;

@end

@implementation YYCartStyleSizeInfoView

#pragma mark - --------------生命周期--------------
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self UIConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
- (void)PrepareUI{}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self CreateContentSubViews];
}
-(void)CreateContentSubViews{
    WeakSelf(ws);
    if(_sizeColorImage == nil){
        _sizeColorImage = [[SCGIFImageView alloc] init];
        _sizeColorImage.contentMode = UIViewContentModeScaleAspectFit;
        _sizeColorImage.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
        _sizeColorImage.layer.borderWidth = 1;
        [self addSubview:_sizeColorImage];
        [_sizeColorImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(17);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
            make.centerY.mas_equalTo(0);
        }];
    }

    if(!_sizeNameLabel){
        _sizeNameLabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [self addSubview:_sizeNameLabel];
        CGFloat centerX_Width = (SCREEN_WIDTH - 2*(_isReceived?184:170))/2.f;
        [_sizeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(centerX_Width);
            make.centerY.mas_equalTo(0);
        }];
    }
    
    if (!self.detailInfoView) {
        self.detailInfoView = [[UIView alloc] init];
        self.detailInfoView.backgroundColor = _define_white_color;
        [self addSubview:self.detailInfoView];
        [self.detailInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(ws.sizeColorImage.mas_right).with.offset(5);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(ws.sizeNameLabel.mas_left).with.offset(-10);
        }];
    }

    if(!_sizeColorNameLabel){
        _sizeColorNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
        [self.detailInfoView addSubview:_sizeColorNameLabel];
        [_sizeColorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }

    if (!self.tradePriceLabel) {
        self.tradePriceLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.0f WithTextColor:_define_black_color WithSpacing:0];
        [self.detailInfoView addSubview:self.tradePriceLabel];
        [self.tradePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.sizeColorNameLabel.mas_bottom).with.offset(2);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }

    if(!_numLabel){
        _numLabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:12.0f WithTextColor:nil WithSpacing:0];
        [self addSubview:_numLabel];
        CGFloat centerX_Width = (SCREEN_WIDTH - 2*(_isReceived?114:62))/2.f;
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(centerX_Width);
            make.centerY.mas_equalTo(0);
        }];
    }

    if(!_receivedLabel){
        _receivedLabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:13.0f WithTextColor:[UIColor colorWithHex:@"ED6498"] WithSpacing:0];
        [self addSubview:_receivedLabel];
        CGFloat centerX_Width = (SCREEN_WIDTH - 2*45)/2.f;
        [_receivedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(centerX_Width);
            make.centerY.mas_equalTo(0);
        }];
        _receivedLabel.hidden = YES;
    }
    
    if(_deleteBtn == nil){
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setImage:[UIImage imageNamed:@"styleclose_icon"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteSizeDate) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-17);
            make.width.mas_equalTo(22);
            make.height.mas_equalTo(22);
            make.centerY.mas_equalTo(0);
        }];
        _deleteBtn.hidden = YES;
    }
    
    if (!self.inputView) {
        self.inputView = [[YYShoppingStyleSizeInputView alloc] init];
        [self addSubview:self.inputView];
        [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.equalTo(ws.deleteBtn.mas_left).with.offset(-17);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(183);
        }];
        self.sizeStock = INT_MAX;
        self.inputView.minCount = 0;
        self.inputView.maxCount = self.sizeStock;
        self.inputView.value = 0;
        self.inputView.delegate = self;
        [self.inputView setTextFieldDidEndEditingBlock:^(YYShoppingStyleSizeInputView *inputView) {
            if (inputView.value > ws.sizeStock) {
                [YYToast showToastWithTitle:[NSString stringWithFormat:NSLocalizedString(@"目前该尺码最大库存数为%ld，请重新输入", nil), ws.sizeStock] andDuration:kAlertToastDuration];
                inputView.value = ws.sizeStock;
            }
        }];
    }
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    if(_isModifyNow){
        _numLabel.hidden = YES;
        _deleteBtn.hidden = NO;
        
        if ([self useStockControl]) {
            self.sizeStock = [self.orderSizeModel.stock integerValue];
        }
        self.inputView.maxCount = self.sizeStock;
        self.inputView.value = [self.orderSizeModel.amount integerValue] < 0 ? 0 : [self.orderSizeModel.amount integerValue];
        self.inputView.index = self.indexPath.row;

        [_sizeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            CGFloat left = IsPhone6_gt?140:107;
            CGFloat width = (SCREEN_WIDTH-178) - left;
            make.left.mas_equalTo(left);
            make.width.mas_equalTo(width);
            make.centerY.mas_equalTo(0);
        }];

    }else{
        _numLabel.hidden = NO;
        _deleteBtn.hidden = YES;
        
        CGFloat sizeNameCenterX_Width = (SCREEN_WIDTH - 2*(_isReceived?184:170))/2.f;
        [_sizeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(sizeNameCenterX_Width);
            make.centerY.mas_equalTo(0);
        }];
    }
    
    //最左边颜色部份
    NSString *colorValue = _orderOneColorModel.value;
    if (colorValue) {
        if ([colorValue hasPrefix:@"#"]
            && [colorValue length] == 7) {
            //16进制的色值
            UIColor *color = [UIColor colorWithHex:[colorValue substringFromIndex:1]];
            UIImage *colorImage = [UIImage imageWithColor:color size:CGSizeMake(25, 25)];
            _sizeColorImage.image = colorImage;
        }else{
            sd_downloadWebImageWithRelativePath(NO, colorValue, _sizeColorImage, kStyleColorImageCover, 0);
        }
    }else{
        UIColor *color = [UIColor clearColor];
        UIImage *colorImage = [UIImage imageWithColor:color size:CGSizeMake(25, 25)];
        _sizeColorImage.image = colorImage;
    }
    
    self.tradePriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f", [self.orderOneColorModel.originalPrice floatValue]], [self.orderOneColorModel.curType integerValue]);

    _numLabel.textColor = _define_black_color;
    if([_orderSizeModel.amount integerValue] == -1){
        _numLabel.text = @"0";
    }else{
        if([_isColorSelect boolValue]){
            if(_isModifyNow){
                self.inputView.value = [self.orderSizeModel.amount integerValue];
                _numLabel.text = [_orderSizeModel.amount stringValue];
            }else{
                self.inputView.value = 0;
                _numLabel.text = @"--";
                _numLabel.textColor = [UIColor colorWithHex:@"ef4e31"];
            }
        }else{
            self.inputView.value = [self.orderSizeModel.amount integerValue];
            _numLabel.text = [_orderSizeModel.amount stringValue];
        }
    }
    _sizeColorNameLabel.text = _orderOneColorModel.name;

    CGFloat numCenterX_Width = (SCREEN_WIDTH - 2*(_isReceived?114:62))/2.f;
    [_numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(numCenterX_Width);
    }];

    CGFloat receivedCenterX_Width = (SCREEN_WIDTH - 2*45)/2.f;
    [_receivedLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(receivedCenterX_Width);
    }];

    _receivedLabel.hidden = !_isReceived;
    if(!_receivedLabel.hidden){
        _receivedLabel.text = [[NSString alloc] initWithFormat:@"%ld",[_orderSizeModel.received integerValue]];
    }
}

#pragma mark - --------------Setter----------------------
-(void)setInputBoxHide:(BOOL)ishide{
    self.inputView.hidden = ishide;
}

#pragma mark - --------------系统代理----------------------

#pragma mark - -------------自定义代理----------------------
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas {
    if (self.delegate) {
        [self.delegate btnClick:self.indexPath.row section:self.indexPath.section andParmas:parmas];
    }
}

#pragma mark - --------------自定义响应----------------------

#pragma mark - --------------自定义方法----------------------
-(void)deleteSizeDate{
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"0"]];
    }
}

- (BOOL)useStockControl {
    if ([self.orderStyleMedel.stockEnabled boolValue] && (!self.orderStyleMedel.dateRange || !self.orderStyleMedel.dateRange.start)) {
        return YES;
    }
    return NO;
}

#pragma mark - --------------other----------------------

@end
