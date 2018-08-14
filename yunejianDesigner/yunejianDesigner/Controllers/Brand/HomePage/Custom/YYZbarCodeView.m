//
//  YYZbarCodeView.m
//  YunejianBuyer
//
//  Created by yyj on 2017/7/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYZbarCodeView.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

#import "regular.h"

#import "SCGIFImageView.h"

@interface YYZbarCodeView ()

@property (nonatomic, strong) UIImageView *mengban;
@property (nonatomic, strong) SCGIFImageView *zbar;//二维码

@end

@implementation YYZbarCodeView


#pragma mark - INIT
-(instancetype)initWithImageUrl:(NSString *)imageUrl WithNameStr:(NSString *)nameStr WithSuperViewController:(UIViewController *)currentVC{
    self = [super init];
    if(self){
        self.imageUrl = imageUrl;
        self.nameStr = nameStr;
        self.currentVC = currentVC;
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
-(void)PrepareUI{
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)]];
}
#pragma mark - SomeAction
-(void)UIConfig{
    //显示二维码
    if(self){
        _mengban=[UIImageView getImgWithImageStr:@"System_Transparent_Mask"];
        _mengban.contentMode=UIViewContentModeScaleToFill;
        [self addSubview:_mengban];
        [_mengban mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
        UIView *bottomView=[UIView getCustomViewWithColor:_define_black_color];
        [_mengban addSubview:bottomView];
        bottomView.userInteractionEnabled = YES;
        [bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NULLACTION)]];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(_mengban);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.height.mas_equalTo(297);
        }];
        
        UIView *backView=[UIView getCustomViewWithColor:_define_white_color];
        [bottomView addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(bottomView);
            make.left.mas_equalTo(4);
            make.right.mas_equalTo(-4);
            make.height.mas_equalTo(289);
        }];
        
        _zbar=[[SCGIFImageView alloc] init];
        [backView addSubview:_zbar];
        _zbar.contentMode = UIViewContentModeScaleAspectFit;
        [_zbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
            make.centerX.mas_equalTo(backView);
            make.height.width.mas_equalTo(123);
        }];
        
        if(![NSString isNilOrEmpty:_imageUrl])
        {
            sd_downloadWebImageWithRelativePath(NO, _imageUrl, _zbar, kLookBookCover, 0);
        }
        
        UILabel *namelabel=[UILabel getLabelWithAlignment:1 WithTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"微信号：%@",nil),_nameStr] WithFont:13.0f WithTextColor:[UIColor colorWithHex:kDefaultTitleColor_phone] WithSpacing:0];
        [backView addSubview:namelabel];
        [namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_zbar.mas_bottom).with.offset(8);
            make.centerX.mas_equalTo(backView);
        }];
        
        __block UIView *lastView=nil;
        NSArray *titleArr=@[NSLocalizedString(@"保存二维码",nil),NSLocalizedString(@"复制微信号",nil)];
        [titleArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *actionbtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.0f WithSpacing:0 WithNormalTitle:obj WithNormalColor:idx==0?_define_white_color:_define_black_color WithSelectedTitle:nil WithSelectedColor:nil];
            [backView addSubview:actionbtn];
            actionbtn.backgroundColor=idx==0?_define_black_color:_define_white_color;
            setBorder(actionbtn);
            if(!idx){
                //保存二维码
                [actionbtn addTarget:self action:@selector(saveWeixinPic:) forControlEvents:UIControlEventTouchUpInside];
            }else
            {
                //复制微信号
                [actionbtn addTarget:self action:@selector(copyWeixinName:) forControlEvents:UIControlEventTouchUpInside];
            }
            [actionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(47);
                make.right.mas_equalTo(-47);
                make.height.mas_equalTo(38);
                if(lastView)
                {
                    make.top.mas_equalTo(lastView.mas_bottom).with.offset(8);
                }else
                {
                    make.top.mas_equalTo(namelabel.mas_bottom).with.offset(13);
                }
            }];
            
            lastView=actionbtn;
        }];
    }
}

-(void)copyWeixinName:(UIButton *)btn
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _nameStr;
    
    [YYToast showToastWithTitle:NSLocalizedString(@"成功复制微信号",nil) andDuration:kAlertToastDuration];
    [_mengban removeFromSuperview];
}
-(void)saveWeixinPic:(UIButton *)btn
{
    if(_zbar.image)
    {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
            [_currentVC presentViewController:alertTitleCancel_Simple(NSLocalizedString(@"请在设备的“设置-隐私-照片”中允许访问照片",nil), ^{
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }) animated:YES completion:nil];
        }else
        {
            UIImageWriteToSavedPhotosAlbum(_zbar.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            [_mengban removeFromSuperview];
        }
    }
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
        
        [YYToast showToastWithTitle:NSLocalizedString(@"保存图片失败",nil) andDuration:kAlertToastDuration];
    }else{
        
        [YYToast showToastWithTitle:NSLocalizedString(@"保存图片成功",nil) andDuration:kAlertToastDuration];
    }
}

-(void)closeAction
{
    [self removeFromSuperview];
}

-(void)NULLACTION{}
@end
