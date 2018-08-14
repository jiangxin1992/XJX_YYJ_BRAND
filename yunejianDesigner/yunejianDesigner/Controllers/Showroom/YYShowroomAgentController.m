//
//  YYShowroomAgentController.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomAgentController.h"

#import <MessageUI/MFMailComposeViewController.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

#import "YYShowroomInfoByDesignerModel.h"
#import "YYNavView.h"

@interface YYShowroomAgentController ()

@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIView *container;
@property (nonatomic ,strong) YYNavView *navView;

@property (nonatomic ,strong) UIButton *removeBtn;

@property (nonatomic ,strong) UIView *statusView;
@property (nonatomic ,strong) UILabel *statusLabel;
@property (nonatomic ,strong) UIView *contentView;

@property (nonatomic ,strong) UIButton *actionBtn;

@property (strong ,nonatomic) UIImageView *mengban;
@property (strong ,nonatomic) UIImageView *zbar;

@end

@implementation YYShowroomAgentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageShowroomAgent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageShowroomAgent];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData{}
-(void)PrepareUI{
    self.view.backgroundColor = _define_white_color;

    _navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"代理Showroom",nil) WithSuperView:self.view haveStatusView:YES];
    
    _removeBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:IsPhone6_gt?15.0f:13.0f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"解除代理",nil) WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    
    [_navView addSubview:_removeBtn];
    if([_showroomInfoByDesignerModel.status isEqualToString:@"AGREE"]){
        _removeBtn.hidden = NO;
    }else{
        _removeBtn.hidden = YES;
    }
    
    [_removeBtn addTarget:self action:@selector(ShowWechat2Dbarcode) forControlEvents:UIControlEventTouchUpInside];
    [_removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(25);
        make.centerY.mas_equalTo(_navView);
    }];
    UIButton *backBtn = [UIButton getCustomImgBtnWithImageStr:@"goBack_normal" WithSelectedImageStr:nil];
    [_navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(GoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(-1);
    }];
}
#pragma mark - UIConfig
-(void)UIConfig{
    [self CreateScrollView];
    [self CreateStatusView];
    [self CreateContentView];
    
//    _actionBtn = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:15.0f WithSpacing:0 WithNormalTitle:@"去邮箱中处理" WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
//    [_container addSubview:_actionBtn];
//    _actionBtn.backgroundColor = _define_black_color;
//    [_actionBtn addTarget:self action:@selector(dealAction) forControlEvents:UIControlEventTouchUpInside];
//    if([_showroomInfoByDesignerModel.status isEqualToString:@"INIT"]){
//        _actionBtn.hidden = NO;
//    }else{
//        _actionBtn.hidden = YES;
//    }
//    [_actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(12);
//        make.right.mas_equalTo(-12);
//        make.height.mas_equalTo(40);
//        make.top.mas_equalTo(_contentView.mas_bottom).with.offset(42);
//    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_navView.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(0);
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(_contentView.mas_bottom).with.offset(-40);
    }];
}
-(void)CreateScrollView
{
    _scrollView=[[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    _container = [UIView new];
    [_scrollView addSubview:_container];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
}
-(void)CreateStatusView
{
    _statusView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"f8f8f8"]];
    [_container addSubview:_statusView];
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    //AGREE 已同意(代理中) INIT 待同意
    NSString *_statusStr = @"";
    NSString *_tipStr = @"";
    BOOL _haveTipView = NO;
    if([_showroomInfoByDesignerModel.status isEqualToString:@"AGREE"]){
        
        _statusStr = NSLocalizedString(@"状态：代理中",nil);
        _tipStr = @"";
        _haveTipView = NO;
    }else if([_showroomInfoByDesignerModel.status isEqualToString:@"INIT"]){
        
        _statusStr = NSLocalizedString(@"状态：待同意",nil);
        _tipStr = NSLocalizedString(@"（请至主账号邮箱中处理）",nil);
        _haveTipView = YES;
    }
    _statusLabel = [UILabel getLabelWithAlignment:0 WithTitle:_statusStr WithFont:15.0f WithTextColor:[UIColor colorWithHex:@"ED6498"] WithSpacing:0];
    [_statusView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.centerY.mas_equalTo(_statusView);
    }];
    
    UIView *_tipView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EF4E31"]];
    [_statusView addSubview:_tipView];
    [_tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_statusLabel.mas_right).with.offset(0);
        make.top.mas_equalTo(_statusLabel);
        make.width.height.mas_equalTo(6);
    }];
    _tipView.hidden = !_haveTipView;
    _tipView.layer.masksToBounds = YES;
    _tipView.layer.cornerRadius = 3;
    
    UILabel *tipLabel = [UILabel getLabelWithAlignment:0 WithTitle:_tipStr WithFont:14.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [_statusView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_statusLabel.mas_right).with.offset(10);
        make.centerY.mas_equalTo(_statusLabel);
    }];
    

    
}
-(void)CreateContentView
{
    _contentView = [UIView getCustomViewWithColor:nil];
    [_container addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_statusView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
    }];
    
    UIView *lastView = nil;
    for (int i=0; i<2; i++) {
        UILabel *titleLabel = [UILabel getLabelWithAlignment:0 WithTitle:i?NSLocalizedString(@"销售",nil):NSLocalizedString(@"Showroom 名称",nil) WithFont:15.0f WithTextColor:[UIColor colorWithHex:@"A2A2A2"] WithSpacing:0];
        [_contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            if(lastView){
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(27);
            }else{
                make.top.mas_equalTo(27);
            }
        }];
        
        UILabel *contentLabel = [UILabel getLabelWithAlignment:0 WithTitle:i?[_showroomInfoByDesignerModel getSalesStr]:_showroomInfoByDesignerModel.showroomName WithFont:15.0f WithTextColor:nil WithSpacing:0];
        [_contentView addSubview:contentLabel];
        if(i)
        {
            contentLabel.numberOfLines = 0;
        }
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(9);
            make.left.right.mas_equalTo(titleLabel);
            if(lastView)
            {
                make.bottom.mas_equalTo(0);
            }
        }];
        
        lastView = contentLabel;
    }

}
#pragma mark - SomeAction
-(void)dealAction{
    
}

#pragma mark *显示微信二维码
-(void)ShowWechat2Dbarcode
{
    //显示二维码
    _mengban=[UIImageView getImgWithImageStr:@"System_Transparent_Mask"];
    _mengban.contentMode=UIViewContentModeScaleToFill;
    [self.view.window addSubview:_mengban];
    [_mengban addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)]];
    _mengban.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    UIView *bottomView=[UIView getCustomViewWithColor:_define_black_color];
    [_mengban addSubview:bottomView];
    bottomView.userInteractionEnabled = YES;
    [bottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NULLACTION)]];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_mengban);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
    }];
    
    UIView *backView=[UIView getCustomViewWithColor:_define_white_color];
    [bottomView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(4, 4, 4, 4));
    }];
    
    UILabel *titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:NSLocalizedString(@"如需解除代理，请联系小助手",nil) WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [backView addSubview:titleLabel];
    titleLabel.numberOfLines = 2;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(17);
    }];
    
    UIView *line = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"d3d3d3"]];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(14);
        make.centerX.mas_equalTo(backView);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(47);
        make.right.mas_equalTo(-47);
    }];
    
    _zbar=[UIImageView getImgWithImageStr:@"weixincode_img"];
    [backView addSubview:_zbar];
    [_zbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).with.offset(18);
        make.centerX.mas_equalTo(backView);
        make.height.width.mas_equalTo(123);
    }];
    
    UILabel *namelabel=[UILabel getLabelWithAlignment:1 WithTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"微信号：%@",nil),@"yunejianhelper"] WithFont:13.0f WithTextColor:[UIColor colorWithHex:kDefaultTitleColor_phone] WithSpacing:0];
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
            [actionbtn addTarget:self action:@selector(saveWeixinPic) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            //复制微信号
            [actionbtn addTarget:self action:@selector(copyWeixinName) forControlEvents:UIControlEventTouchUpInside];
        }
        [actionbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(47);
            make.right.mas_equalTo(-47);
            make.height.mas_equalTo(38);
            if(lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(8);
                make.bottom.mas_equalTo(-15);
            }else
            {
                make.top.mas_equalTo(namelabel.mas_bottom).with.offset(13);
            }
        }];
        
        lastView=actionbtn;
    }];
}
-(void)copyWeixinName
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = @"yunejianhelper";
    
    [YYToast showToastWithTitle:NSLocalizedString(@"成功复制微信号",nil) andDuration:kAlertToastDuration];
    [_mengban removeFromSuperview];
}
-(void)saveWeixinPic
{
    if(_zbar.image)
    {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        
        if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
            [self presentViewController:alertTitleCancel_Simple(NSLocalizedString(@"请在设备的“设置-隐私-照片”中允许访问照片",nil), ^{
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
-(void)closeAction
{
    [_mengban removeFromSuperview];
}
-(void)NULLACTION{}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if(error != NULL){
        
        [YYToast showToastWithTitle:NSLocalizedString(@"保存图片失败",nil) andDuration:kAlertToastDuration];
    }else{
        
        [YYToast showToastWithTitle:NSLocalizedString(@"保存图片成功",nil) andDuration:kAlertToastDuration];
    }
}

-(void)GoBack:(id)sender {
    if(_cancelButtonClicked)
    {
        _cancelButtonClicked();
    }
}
#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
