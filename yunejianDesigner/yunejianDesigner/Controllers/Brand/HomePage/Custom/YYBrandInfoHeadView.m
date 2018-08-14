//
//  YYBuyerInfoHeadView.m
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYBrandInfoHeadView.h"

#import "SCLoopScrollView.h"
#import "UIImage+YYImage.h"
#import "SCGIFImageView.h"

#import "YYBrandHomeInfoModel.h"
#import "YYUser.h"

@interface YYBrandInfoHeadView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) SCLoopScrollView *scrollView;
@property (nonatomic, strong) SCGIFImageView *logoImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *chatBtn;

@property (nonatomic, strong) NSMutableArray *tmpImagArr;
@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) UIView *pageBarView;
@property (nonatomic,strong) UIView *lineLeft;
@property (nonatomic,strong) UIView *lineMiddle;
@property (nonatomic,strong) UIView *lineRight;

@end

@implementation YYBrandInfoHeadView

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
    [self CreateInfoView];
    [self CreateSelectBar];
}
-(void)CreateInfoView
{
    _infoView = [UIView getCustomViewWithColor:[UIColor colorWithRed:248.0f/255.0f green:248.0f/255.0f blue:248.0f/255.0f alpha:1]];
    [self addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    _scrollView = [[SCLoopScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 224)];
    [_infoView addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    self.pageControl = [[UIPageControl alloc] init];
    __weak SCLoopScrollView *weakScrollView = _scrollView;
    __weak UIView *weakView = self;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    [weakView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakScrollView.mas_bottom).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(300, 20));
        make.centerX.equalTo(weakScrollView.mas_centerX);
    }];
    _pageControl.hidden = YES;
    
    _logoImageView = [[SCGIFImageView alloc] init];
    [_infoView addSubview:_logoImageView];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.backgroundColor=[UIColor whiteColor];
    _logoImageView.layer.cornerRadius = 28.5;
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.height.width.mas_equalTo(57);
        make.top.mas_equalTo(_scrollView.mas_bottom).with.offset(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    _nameLabel = [UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:14.0f WithTextColor:_define_black_color WithSpacing:0];
    [_infoView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_logoImageView.mas_right).with.offset(IsPhone6_gt?15:5);
        make.centerY.mas_equalTo(_logoImageView.mas_centerY);
        make.right.mas_equalTo(-17);
    }];
    
    _chatBtn = [UIButton getCustomImgBtnWithImageStr:@"chat_icon" WithSelectedImageStr:nil];
    [_infoView addSubview:_chatBtn];
    [_chatBtn addTarget:self action:@selector(chatAction) forControlEvents:UIControlEventTouchUpInside];
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(_logoImageView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(55);
    }];
    
    
    _oprateBtn = [UIButton getCustomBtn];
    [_infoView addSubview:_oprateBtn];
    _oprateBtn.titleLabel.font = getFont(13.0f);
    [_oprateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_oprateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    _oprateBtn.layer.cornerRadius = 2.5;
    _oprateBtn.layer.masksToBounds = YES;
    _oprateBtn.layer.borderWidth = 1;
    [_oprateBtn addTarget:self action:@selector(oprateAction) forControlEvents:UIControlEventTouchUpInside];
    [_oprateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_chatBtn.mas_left).with.offset(0);
        make.centerY.mas_equalTo(_logoImageView);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(100);
    }];
    
}


-(void)CreateSelectBar
{
    _pageBarView = [UIView getCustomViewWithColor:_define_white_color];
    [self addSubview:_pageBarView];
    [_pageBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_infoView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    NSArray *titleArr=@[NSLocalizedString(@"关于品牌",nil)
                        ,NSLocalizedString(@"品牌系列",nil)
                        ,NSLocalizedString(@"联系品牌",nil)];
    __block UIView *lastView=nil;
    [titleArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *SwitchBtn=[UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.0f WithSpacing:0 WithNormalTitle:obj WithNormalColor:_define_black_color WithSelectedTitle:obj WithSelectedColor:_define_black_color];
        [_pageBarView addSubview:SwitchBtn];
        SwitchBtn.backgroundColor=_define_white_color;
        if(!idx){
            [SwitchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, [LanguageManager isEnglishLanguage]?8:0)];
        }else if(idx == 2){
            [SwitchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, [LanguageManager isEnglishLanguage]?3:0, 0, 0)];
        }
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
            [SwitchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            SwitchBtn.selected=YES;
            [SwitchBtn setEnlargeEdgeWithTop:0 right:20 bottom:0 left:0 ];
            if(!_lineLeft)
            {
                _lineLeft=[UIView getCustomViewWithColor:_define_black_color];
                [SwitchBtn addSubview:_lineLeft];
                [_lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.height.mas_equalTo(2);
                    make.width.mas_equalTo(56);
                }];
            }
            _lineLeft.hidden=NO;
        }else if(idx == 1)
        {
            [SwitchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            SwitchBtn.selected=NO;
            if(!_lineMiddle)
            {
                _lineMiddle=[UIView getCustomViewWithColor:_define_black_color];
                [SwitchBtn addSubview:_lineMiddle];
                [_lineMiddle mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.centerX.mas_equalTo(SwitchBtn);
                    make.height.mas_equalTo(2);
                    make.width.mas_equalTo(56);
                }];
            }
            _lineMiddle.hidden=YES;
        }else
        {
            [SwitchBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            SwitchBtn.selected=NO;
            [SwitchBtn setEnlargeEdgeWithTop:0 right:0 bottom:0 left:20 ];
            if(!_lineRight)
            {
                _lineRight=[UIView getCustomViewWithColor:_define_black_color];
                [SwitchBtn addSubview:_lineRight];
                [_lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(0);
                    make.left.mas_equalTo(0);
                    make.height.mas_equalTo(2);
                    make.width.mas_equalTo(56);
                }];
            }
            _lineRight.hidden=YES;
        }
        
        lastView=SwitchBtn;
    }];
    
    UIView *bottomLine=[UIView getCustomViewWithColor:[UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1]];
    [_pageBarView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
}
#pragma mark - SomeAction
-(void)oprateAction
{
    if(_block){
        _block(@"oprate",0);
    }
}
-(void)chatAction
{
    if(_block){
        _block(@"chat",0);
    }
}
-(void)SwitchAction:(UIButton *)btn
{
    NSInteger selectIdx=btn.tag-100;
    NSArray *SwitchBtnArr = @[[_pageBarView viewWithTag:100],[_pageBarView viewWithTag:101],[_pageBarView viewWithTag:102]];
    [SwitchBtnArr enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(selectIdx==idx)
        {
            obj.selected=YES;
            if(idx==0)
            {
                _lineLeft.hidden=NO;
            }else if(idx==1)
            {
                _lineMiddle.hidden=NO;
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
            }else if(idx==1)
            {
                _lineMiddle.hidden=YES;
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
#pragma mark - SetData

-(void)SetData
{
    if(_infoModel)
    {
        if(_infoModel.indexPics)
        {
            if(_infoModel.indexPics.count)
            {
                _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 224);
                _scrollView.hidden = NO;
                if(!_tmpImagArr)
                {
                    _tmpImagArr = [[NSMutableArray alloc] initWithCapacity:_infoModel.indexPics.count];
                }else
                {
                    [_tmpImagArr removeAllObjects];
                }
                [_infoModel.indexPics enumerateObjectsUsingBlock:^(NSString * imageName, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *_imageRelativePath = imageName;
                    NSString *imgInfo = [NSString stringWithFormat:@"%@%@|%@",_imageRelativePath,kLookBookImage,@""];
                    [_tmpImagArr addObject:imgInfo];
                }];
                
                if(_infoModel.indexPics.count>1)
                {
                    _pageControl.numberOfPages = _infoModel.indexPics.count;
                    _pageControl.currentPage = 0;
                    _pageControl.hidden = NO;
                }else
                {
                    _pageControl.numberOfPages = _infoModel.indexPics.count;
                    _pageControl.currentPage = 0;
                    _pageControl.hidden = YES;
                }
                
                _scrollView.images = _tmpImagArr;
                [_scrollView show:^(NSInteger index) {
                    
                } finished:^(NSInteger index) {
                    _pageControl.currentPage = index;
                }];
            }else
            {
                _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
                _scrollView.hidden = YES;
                _scrollView.images = @[];
            }
        }else
        {
            _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            _scrollView.hidden = YES;
            _scrollView.images = @[];
        }
        
        if(_isHomePage)
        {
            if(_chatBtn)
            {
                _chatBtn.hidden = YES;
            }
            if(_oprateBtn)
            {
                _oprateBtn.hidden = YES;
            }
        }else
        {
            if(_oprateBtn){
                if([_infoModel.connectStatus integerValue] == YYUserConnStatusNone){
                    
                    [_oprateBtn setBackgroundColor:[UIColor colorWithHex:@"FFFFFF"]];
                    [_oprateBtn setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
                    [_oprateBtn setTitle:NSLocalizedString(@"添加品牌",nil) forState:UIControlStateNormal];
                    [_oprateBtn setImage:[UIImage imageNamed:@"brandadd_icon"] forState:UIControlStateNormal];
                    _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"000000"].CGColor;
                    
                    _chatBtn.hidden = YES;
                    [_chatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(20);
                    }];
                    
                }else if([_infoModel.connectStatus integerValue] == YYUserConnStatusInvite || [_infoModel.connectStatus integerValue] == YYUserConnStatusBeInvited){
                    
                    [_oprateBtn setBackgroundColor:[UIColor colorWithHex:@"FFFFFF"]];
                    [_oprateBtn setTitleColor:[UIColor colorWithHex:@"58c776"] forState:UIControlStateNormal];
                    [_oprateBtn setTitle:NSLocalizedString(@"已经邀请_short",nil) forState:UIControlStateNormal];
                    [_oprateBtn setImage:[UIImage imageNamed:@"brandwait_icon"] forState:UIControlStateNormal];
                    _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"58c776"].CGColor;
                    
                    _chatBtn.hidden = YES;
                    [_chatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(20);
                    }];
                    
                }else if([_infoModel.connectStatus integerValue] == YYUserConnStatusConnected){
                    
                    [_oprateBtn setBackgroundColor:[UIColor colorWithHex:@"58c776"]];
                    [_oprateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [_oprateBtn setTitle:NSLocalizedString(@"已经合作",nil) forState:UIControlStateNormal];
                    [_oprateBtn setImage:[UIImage imageNamed:@"brandconn_icon"] forState:UIControlStateNormal];
                    _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"58c776"].CGColor;
                    
                    _chatBtn.hidden = NO;
                    [_chatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(55);
                    }];
                    
                }
            }
        }
        
        if(_isHomePage)
        {
            _nameLabel.text = _infoModel.brandName;
        }else
        {
            if(![NSString isNilOrEmpty:_infoModel.brandName])
            {
                _nameLabel.text = _infoModel.brandName;
            }else
            {
                _nameLabel.text = @"";
            }
        }
        
        NSString *_logoPath = _infoModel.logoPath;
        sd_downloadWebImageWithRelativePath(NO, _logoPath, _logoImageView, kLogoCover, 0);
    }else
    {
        _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        _scrollView.hidden = YES;
        _scrollView.images = @[];
        _nameLabel.text = @"";
        sd_downloadWebImageWithRelativePath(NO, @"", _logoImageView, kLogoCover, 0);
    }
    [self updateLabelLength];
    
}
-(void)reloadData
{
    if(_isHomePage)
    {
        if(_chatBtn)
        {
            _chatBtn.hidden = YES;
        }
        if(_oprateBtn)
        {
            _oprateBtn.hidden = YES;
        }
    }else
    {
        if(_oprateBtn){
            if([_infoModel.connectStatus integerValue] == YYUserConnStatusNone){
                
                [_oprateBtn setBackgroundColor:[UIColor colorWithHex:@"FFFFFF"]];
                [_oprateBtn setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
                [_oprateBtn setTitle:NSLocalizedString(@"添加品牌",nil) forState:UIControlStateNormal];
                [_oprateBtn setImage:[UIImage imageNamed:@"brandadd_icon"] forState:UIControlStateNormal];
                _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"000000"].CGColor;
                
                _chatBtn.hidden = YES;
                [_chatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(20);
                }];
                
            }else if([_infoModel.connectStatus integerValue] == YYUserConnStatusInvite || [_infoModel.connectStatus integerValue] == YYUserConnStatusBeInvited){
                
                [_oprateBtn setBackgroundColor:[UIColor colorWithHex:@"FFFFFF"]];
                [_oprateBtn setTitleColor:[UIColor colorWithHex:@"58c776"] forState:UIControlStateNormal];
                [_oprateBtn setTitle:NSLocalizedString(@"已经邀请_short",nil) forState:UIControlStateNormal];
                [_oprateBtn setImage:[UIImage imageNamed:@"brandwait_icon"] forState:UIControlStateNormal];
                _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"58c776"].CGColor;
                
                _chatBtn.hidden = YES;
                [_chatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(20);
                }];
                
            }else if([_infoModel.connectStatus integerValue] == YYUserConnStatusConnected){
                
                [_oprateBtn setBackgroundColor:[UIColor colorWithHex:@"58c776"]];
                [_oprateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [_oprateBtn setTitle:NSLocalizedString(@"已经合作",nil) forState:UIControlStateNormal];
                [_oprateBtn setImage:[UIImage imageNamed:@"brandconn_icon"] forState:UIControlStateNormal];
                _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"58c776"].CGColor;
                
                _chatBtn.hidden = NO;
                [_chatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(55);
                }];
                
            }
        }
    }
    [self updateLabelLength];
}
-(void)updateLabelLength{
    CGFloat _bianju = 0;
    if(_oprateBtn.hidden){
        //状态按钮隐藏状态
        if(_chatBtn.hidden){
            //chat按钮隐藏状态
            _bianju = -17;
        }else{
            //chat按钮显示状态
            _bianju = -60;
        }
    }else{
        if(_chatBtn.hidden){
            //chat按钮隐藏状态
            _bianju = -125;
        }else{
            //chat按钮显示状态
            _bianju = -160;
        }
    }
    [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bianju);
    }];
}
//-(void)setIsHomePage:(BOOL)isHomePage{
//    _isHomePage = isHomePage;
//    
//    if(!_isHomePage)
//    {
//        _chatBtn.hidden = NO;
//        _oprateBtn.hidden = NO;
//        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-155);
//        }];
//    }else{
//        _chatBtn.hidden = YES;
//        _oprateBtn.hidden = YES;
//        [_nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-17);
//        }];
//    }
//}
@end
