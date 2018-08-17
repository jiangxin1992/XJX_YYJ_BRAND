//
//  YYBuyerInfoHeadView.m
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYBuyerInfoHeadViewNew.h"

#import "SCGIFImageView.h"
#import "SCGIFButtonView.h"
#import "UIImage+YYImage.h"

#import "YYBuyerHomeInfoModel.h"
#import "YYUser.h"

@interface YYBuyerInfoHeadViewNew()

@property (nonatomic, strong) SCGIFButtonView *albumImg;

@property (nonatomic, strong) SCGIFImageView *logoImageView;

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *connedIcon;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *oprateBtn;

@end

@implementation YYBuyerInfoHeadViewNew

-(instancetype)initWithHomeInfoModel:(YYBuyerHomeInfoModel *)infoModel WithBlock:(void(^)(NSString *type ,NSInteger index))block
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
        make.right.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_albumImg.mas_bottom).with.offset(0);
    }];
    
    _nameLabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [_infoView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(31);
        make.centerX.mas_equalTo(_infoView);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    _connedIcon = [UIImageView getImgWithImageStr:@"conned_icon"];
    [_infoView addSubview:_connedIcon];
    [_connedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nameLabel.mas_right).with.offset(10);
        make.height.width.mas_equalTo(14);
        make.centerY.mas_equalTo(_nameLabel);
    }];
    _connedIcon.hidden = YES;
    
    _locationLabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:13.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [_infoView addSubview:_locationLabel];
    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(-17);
        make.left.mas_equalTo(17);
    }];
    //chat_icon
    _oprateBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    [_infoView addSubview:_oprateBtn];
    //    27 82
    [_oprateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_oprateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
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
        make.top.mas_equalTo(_locationLabel.mas_bottom).with.offset(11);
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


#pragma mark - SomeAction
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
        if(_isHomePage){
            _oprateBtn.hidden = YES;
        }else{
            _oprateBtn.hidden = NO;
            _oprateBtn.backgroundColor =[UIColor clearColor];
            if([_infoModel.connectStatus integerValue] == kConnStatus){
                //                [_oprateBtn setImage:[UIImage imageNamed:@"conn_invite1_icon"] forState:UIControlStateNormal];
                [_oprateBtn setImage:[UIImage imageNamed:@"brandadd_homepage_icon"] forState:UIControlStateNormal];
                [_oprateBtn setTitle:NSLocalizedString(@"邀请合作",nil) forState:UIControlStateNormal];
                [_oprateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _oprateBtn.layer.borderColor = [UIColor blackColor].CGColor;
            }else if([_infoModel.connectStatus integerValue] == kConnStatus0 || [_infoModel.connectStatus integerValue] == kConnStatus2){
                //                [_oprateBtn setImage:[UIImage imageNamed:@"conn_inviteing1_icon"] forState:UIControlStateNormal];
                [_oprateBtn setImage:[UIImage imageNamed:@"brandwait_homepage_icon"] forState:UIControlStateNormal];
                [_oprateBtn setTitle:NSLocalizedString(@"已经邀请_short",nil) forState:UIControlStateNormal];
                [_oprateBtn setTitleColor:[UIColor colorWithHex:@"58c77d"] forState:UIControlStateNormal];
                _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"58c77d"].CGColor;
            }else if([_infoModel.connectStatus integerValue] == kConnStatus1){
                
                [_oprateBtn setImage:[UIImage imageNamed:@"chat_homepage_icon"] forState:UIControlStateNormal];
                [_oprateBtn setTitle:NSLocalizedString(@"发送私信",nil) forState:UIControlStateNormal];
                [_oprateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                _oprateBtn.layer.borderColor = [UIColor blackColor].CGColor;
                
                _connedIcon.hidden = NO;
            }
        }
        
        
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
        
        
        _nameLabel.text = _infoModel.name;
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        NSString *nationStr = @"";
        NSString *provinceStr = @"";
        NSString *cityStr = @"";
        if([_infoModel.nationId integerValue]){
            nationStr = [LanguageManager isEnglishLanguage]?_infoModel.nationEn:_infoModel.nation;
            [tempArr addObject:nationStr];
        }
        if([_infoModel.provinceId integerValue]){
            provinceStr = [LanguageManager isEnglishLanguage]?_infoModel.provinceEn:_infoModel.province;
            [tempArr addObject:provinceStr];
        }
        if([_infoModel.cityId integerValue]){
            cityStr = [LanguageManager isEnglishLanguage]?_infoModel.cityEn:_infoModel.city;
            [tempArr addObject:cityStr];
        }
        NSString *_locationLabelStr = [tempArr componentsJoinedByString:@" "];
        _locationLabel.text = _locationLabelStr;
    }else{
        _oprateBtn.hidden = YES;
        _logoImageView.image = [UIImage imageNamed:@"default_head_icon"];
        [_albumImg setImage:[UIImage imageNamed:@"no_albumImg"] forState:UIControlStateNormal];
        _nameLabel.text = @"";
        _locationLabel.text = @"";
    }
    
}
@end
