//
//  YYBuyerInfoHeadView.m
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYBrandInfoHeadViewNew.h"

#import "SCGIFImageView.h"
#import "SCGIFButtonView.h"
#import "UIImage+YYImage.h"

#import "YYBrandHomeInfoModel.h"

@interface YYBrandInfoHeadViewNew()<UIScrollViewDelegate>

@property (nonatomic, strong) SCGIFButtonView *albumImg;

@property (nonatomic, strong) SCGIFImageView *logoImageView;

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UILabel *brandNameLabel;
@property (nonatomic, strong) UIImageView *connedIcon;
@property (nonatomic, strong) UILabel *designerNameLabel;

@property (nonatomic,strong) UIView *pageBarView;
@property (nonatomic,strong) UIView *lineLeft;
@property (nonatomic,strong) UIView *lineRight;

@end

@implementation YYBrandInfoHeadViewNew

-(instancetype)initWithHomeInfoModel:(YYBrandHomeInfoModel *)infoModel WithBlock:(void(^)(NSString *type ,NSInteger index))block
{
    self=[super init];
    if(self)
    {
        _infoModel=infoModel;
        _block=block;
        [self SomePrepare];
        [self UIConfig];
        [self SetData];
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
    self.backgroundColor = [UIColor whiteColor];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateSelectBar];
    [self CreateInfoView];
}
-(void)CreateInfoView
{
    _albumImg = [[SCGIFButtonView alloc] init];
    [self addSubview:_albumImg];
    [_albumImg addTarget:self action:@selector(showLookBookPics:) forControlEvents:UIControlEventTouchUpInside];
    [_albumImg setAdjustsImageWhenHighlighted:NO];
    _albumImg.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
    _albumImg.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _albumImg.clipsToBounds = YES;
    [_albumImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(190);
    }];
    
    _infoView = [UIView getCustomViewWithColor:_define_white_color];
    [self addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(_albumImg.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(_pageBarView.mas_top).with.offset(0);
    }];
    
    _brandNameLabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [_infoView addSubview:_brandNameLabel];
    [_brandNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(31);
        make.centerX.mas_equalTo(_infoView);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    _connedIcon = [UIImageView getImgWithImageStr:@"conned_icon"];
    [_infoView addSubview:_connedIcon];
    [_connedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_brandNameLabel.mas_right).with.offset(10);
        make.height.width.mas_equalTo(14);
        make.centerY.mas_equalTo(_brandNameLabel);
    }];
    _connedIcon.hidden = YES;
    
    _designerNameLabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:13.0f WithTextColor:_define_black_color WithSpacing:0];
    [_infoView addSubview:_designerNameLabel];
    [_designerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(-17);
        make.left.mas_equalTo(17);
    }];
    //chat_icon
    _oprateBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    [_infoView addSubview:_oprateBtn];
    //    27 82
    //    [_oprateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_oprateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    //    [_oprateBtn setImage:[UIImage imageNamed:@"chat_icon"] forState:UIControlStateNormal];
    //    [_oprateBtn setTitleColor:_define_black_color forState:UIControlStateNormal];
    _oprateBtn.layer.cornerRadius = 2.0f;
    _oprateBtn.layer.masksToBounds = YES;
    _oprateBtn.layer.borderWidth = 1;
    [_oprateBtn addTarget:self action:@selector(oprateAction) forControlEvents:UIControlEventTouchUpInside];
    [_oprateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(27);
        make.width.mas_equalTo(82);
        make.centerX.mas_equalTo(_infoView);
        make.top.mas_equalTo(_designerNameLabel.mas_bottom).with.offset(11);
    }];
    
    _logoImageView = [[SCGIFImageView alloc] init];
    [self addSubview:_logoImageView];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _logoImageView.backgroundColor=[UIColor whiteColor];
    setBorderCustom(_logoImageView, 1, [UIColor colorWithHex:@"F8F8F8"]);
    _logoImageView.layer.cornerRadius = 35;
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(_albumImg.mas_bottom).with.offset(25);
        make.height.width.mas_equalTo(70);
    }];
    
    UIView *downView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_infoView addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    UIView *downLineView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"d3d3d3"]];
    [_infoView addSubview:downLineView];
    [downLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(downView.mas_top).with.offset(0);
    }];
}


-(void)CreateSelectBar
{
    _pageBarView = [UIView getCustomViewWithColor:_define_white_color];
    [self addSubview:_pageBarView];
    [_pageBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
        
    }];
    
    NSArray *titleArr=@[NSLocalizedString(@"品牌系列",nil)
                        ,NSLocalizedString(@"关于品牌",nil)];
    __block UIView *lastView=nil;
    [titleArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *SwitchBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.0f WithSpacing:0 WithNormalTitle:obj WithNormalColor:_define_black_color WithSelectedTitle:obj WithSelectedColor:_define_black_color];
        [_pageBarView addSubview:SwitchBtn];
        SwitchBtn.backgroundColor=_define_white_color;
        SwitchBtn.tag=100+idx;
        [SwitchBtn addTarget:self action:@selector(SwitchAction:) forControlEvents:UIControlEventTouchUpInside];
        [SwitchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastView)
            {
                make.left.mas_equalTo(lastView.mas_right).with.offset(0);
                make.width.mas_equalTo(lastView);
            }else
            {
                make.left.mas_equalTo(0);
            }
            if(idx == titleArr.count-1)
            {
                make.right.mas_equalTo(0);
            }
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-1);
        }];
        if(idx == 0)
        {
            SwitchBtn.selected=YES;
            if(!_lineLeft)
            {
                [SwitchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
                [SwitchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                _lineLeft=[UIView getCustomViewWithColor:_define_black_color];
                [SwitchBtn addSubview:_lineLeft];
                [_lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.right.mas_equalTo(-25);
                    make.height.mas_equalTo(2);
                    make.width.mas_equalTo(56);
                }];
            }
            _lineLeft.hidden=NO;
        }else
        {
            SwitchBtn.selected=NO;
            if(!_lineRight)
            {
                [SwitchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
                [SwitchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                _lineRight=[UIView getCustomViewWithColor:_define_black_color];
                [SwitchBtn addSubview:_lineRight];
                [_lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.left.mas_equalTo(25);
                    make.height.mas_equalTo(2);
                    make.width.mas_equalTo(56);
                }];
            }
            _lineRight.hidden=YES;
        }
        
        lastView=SwitchBtn;
    }];
    
    UIView *bottomLine=[UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_pageBarView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
}
#pragma mark - SomeAction

-(void)SwitchAction:(UIButton *)btn
{
    NSInteger selectIdx=btn.tag-100;
    NSArray *SwitchBtnArr = @[[_pageBarView viewWithTag:100],[_pageBarView viewWithTag:101]];
    [SwitchBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(selectIdx==idx)
        {
            obj.selected=YES;
            if(idx==0)
            {
                _lineLeft.hidden=NO;
            }else
            {
                _lineRight.hidden=NO;
            }
        }else
        {
            obj.selected=NO;
            if(!idx)
            {
                _lineLeft.hidden=YES;
            }else
            {
                _lineRight.hidden=YES;
            }
        }
    }];
    if(_block){
        _block(@"switch",selectIdx);
    }
}
-(void)reloadData
{
    [self updateOprateBtnState];
}
-(void)updateOprateBtnState{
    if(_oprateBtn && _infoModel){
        if(_isHomePage){
            _oprateBtn.hidden = YES;
        }else{
            _oprateBtn.hidden = NO;
            _oprateBtn.backgroundColor =[UIColor clearColor];
            if([_infoModel.connectStatus integerValue] == kConnStatus){
                
                [_oprateBtn setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
                [_oprateBtn setTitle:NSLocalizedString(@"添加品牌",nil) forState:UIControlStateNormal];
                [_oprateBtn setImage:[UIImage imageNamed:@"brandadd_homepage_icon"] forState:UIControlStateNormal];
                _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"000000"].CGColor;
                
            }else if([_infoModel.connectStatus integerValue] == kConnStatus0 || [_infoModel.connectStatus integerValue] == kConnStatus2){
                
                [_oprateBtn setTitleColor:[UIColor colorWithHex:@"58c776"] forState:UIControlStateNormal];
                [_oprateBtn setTitle:NSLocalizedString(@"已经邀请_short",nil) forState:UIControlStateNormal];
                [_oprateBtn setImage:[UIImage imageNamed:@"brandwait_homepage_icon"] forState:UIControlStateNormal];
                _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"58c776"].CGColor;
                
            }else if([_infoModel.connectStatus integerValue] == kConnStatus1){
                
                [_oprateBtn setImage:[UIImage imageNamed:@"chat_homepage_icon"] forState:UIControlStateNormal];
                [_oprateBtn setTitle:NSLocalizedString(@"发送私信",nil) forState:UIControlStateNormal];
                [_oprateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _oprateBtn.layer.borderColor = [UIColor blackColor].CGColor;
                
                _connedIcon.hidden = NO;
                
            }
        }
    }
}
-(void)oprateAction
{
    if(_block){
        _block(@"oprate",0);
    }
}
-(void)showLookBookPics:(SCGIFButtonView *)btn
{
    if(_block){
        _block(@"show_pics",0);
    }
}
#pragma mark - SetData

-(void)SetData
{
    if(_infoModel){
        
        [self updateOprateBtnState];
        
        NSString *logoPath = _infoModel.logoPath;
        if([NSString isNilOrEmpty:logoPath]){
            _logoImageView.image = [UIImage imageNamed:@"default_head_icon"];
        }else{
            sd_downloadWebImageWithRelativePath(NO, logoPath, _logoImageView, kLogoCover, 0);
        }
        
        NSString *albumImgPath = [_infoModel getStoreImgCover];
        
        if([NSString isNilOrEmpty:albumImgPath]){
            [_albumImg setImage:[UIImage imageNamed:@"no_albumImg"] forState:UIControlStateNormal];
        }else{
            sd_downloadWebImageWithRelativePath(YES, albumImgPath, _albumImg, kLookBookCover,UIViewContentModeScaleAspectFit);
        }
        
        _brandNameLabel.text = _infoModel.brandName;
        
        _designerNameLabel.text = _infoModel.designerName;
    }else{
        _oprateBtn.hidden = YES;
        _logoImageView.image = [UIImage imageNamed:@"default_head_icon"];
        [_albumImg setImage:[UIImage imageNamed:@"no_albumImg"] forState:UIControlStateNormal];
        _brandNameLabel.text = @"";
        _designerNameLabel.text = @"";
    }
}


@end
