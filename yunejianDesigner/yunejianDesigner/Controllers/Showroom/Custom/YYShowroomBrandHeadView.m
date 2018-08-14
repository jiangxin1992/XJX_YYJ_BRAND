//
//  YYShowroomBrandHeadView.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomBrandHeadView.h"

#import "SCGIFImageView.h"
#import "SCGIFButtonView.h"

#import "YYShowroomBrandListModel.h"

@interface YYShowroomBrandHeadView()

@property (strong ,nonatomic) SCGIFImageView *adBackImg;
@property (strong ,nonatomic) SCGIFImageView *userHeadButton;
@property (strong ,nonatomic) UILabel *userNameLabel;
@property (strong ,nonatomic) UIView *bottomLine;
@end

@implementation YYShowroomBrandHeadView
#pragma mark - init
-(instancetype)initWithBlock:(void (^)(NSString *))block
{
    self = [super init];
    if(self)
    {
        _block = block;
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
-(void)PrepareUI
{
    self.backgroundColor = _define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    _adBackImg = [[SCGIFImageView alloc] init];
    [self addSubview:_adBackImg];
    _adBackImg.contentMode = UIViewContentModeScaleAspectFill;
    _adBackImg.clipsToBounds = YES;
    _adBackImg.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
    [_adBackImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-(kIPhoneX?45:65));
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(floor((324.0f/750.0f)*SCREEN_WIDTH));
    }];

    _userHeadButton = [[SCGIFImageView alloc] init];
    [self addSubview:_userHeadButton];
    _userHeadButton.backgroundColor = _define_white_color;
    _userHeadButton.contentMode = UIViewContentModeScaleAspectFit;
    setBorderCustom(_userHeadButton, 3, nil);
    _userHeadButton.userInteractionEnabled=YES;
    [_userHeadButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick)]];
    [_userHeadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_adBackImg.mas_bottom).with.offset(21);
        make.width.height.mas_equalTo(100);
        make.centerX.mas_equalTo(_userHeadButton.superview);
    }];
    
    _userNameLabel = [UILabel getLabelWithAlignment:1 WithTitle:@"" WithFont:16.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(_userHeadButton.mas_bottom).with.offset(12);
    }];
    
    _bottomLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"efefef"]];
    [self addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
    }];
}
#pragma mark - Setter
-(void)setShowroomBrandListModel:(YYShowroomBrandListModel *)ShowroomBrandListModel
{
    _ShowroomBrandListModel = ShowroomBrandListModel;
    
    if(_ShowroomBrandListModel && ![NSString isNilOrEmpty:_ShowroomBrandListModel.pic]){
        sd_downloadWebImageWithRelativePath(NO, _ShowroomBrandListModel.pic, _adBackImg, kLookBookImage, 0);
    }else{
        sd_downloadWebImageWithRelativePath(NO, @"", _adBackImg, kLookBookImage, 0);
    }
    
    if(_ShowroomBrandListModel && ![NSString isNilOrEmpty:_ShowroomBrandListModel.logo]){
        
        sd_downloadWebImageWithRelativePath(NO, _ShowroomBrandListModel.logo, _userHeadButton, kBuyerCardImage, 0);
    }else{
        
        sd_downloadWebImageWithRelativePath(NO, @"", _userHeadButton, kBuyerCardImage, 0);
    }
    
    _userNameLabel.text = _ShowroomBrandListModel.name;
}
#pragma mark - SomeAction
-(void)bottomIsHide:(BOOL )ishide
{
    if(_bottomLine)
    {
        _bottomLine.hidden = ishide;
    }
}

-(void)headClick{
    if(_block)
    {
        _block(@"headclick");
    }
}

@end
