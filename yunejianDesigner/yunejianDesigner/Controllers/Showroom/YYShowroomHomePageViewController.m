//
//  YYShowroomHomePageViewController.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomHomePageViewController.h"

#import <WebKit/WebKit.h>
#import "YYShowroomBrandHeadView.h"
#import "YYMessageButton.h"

#import "YYShowroomBrandListModel.h"
#import "YYShowroomHomePageModel.h"
#import "YYShowroomApi.h"
#import "MBProgressHUD.h"
#import <MJRefresh.h>
#import "YYNavView.h"

@interface YYShowroomHomePageViewController ()<WKNavigationDelegate>

@property (nonatomic ,strong) YYNavView *navView;
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIView *container;
@property (nonatomic ,strong) YYShowroomBrandHeadView *headView;
@property (nonatomic ,strong) UIView *middleView;
@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic, strong) WKWebView *infoAboutWebview;

@property (nonatomic ,strong) YYShowroomHomePageModel *homePageModel;
@property (nonatomic ,strong) YYShowroomBrandListModel *ShowroomBrandListModel;
@end

@implementation YYShowroomHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageShowroomHomePage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageShowroomHomePage];
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
    
    _navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"Showroom主页",nil) WithSuperView: self.view haveStatusView:YES];
    
    UIButton *backBtn = [UIButton getCustomImgBtnWithImageStr:@"goBack_normal" WithSelectedImageStr:nil];
    [_navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(GoBack:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(-1);
    }];
}

#pragma mark - RequestData
-(void)RequestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeakSelf(ws);
    [YYShowroomApi getShowroomHomePageInfoWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYShowroomHomePageModel *homePageModel, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        if(rspStatusAndMessage.status == kCode100){
            
            _homePageModel = homePageModel;
            
            YYShowroomBrandListModel *tempModel=[[YYShowroomBrandListModel alloc] init];
            tempModel.logo = _homePageModel.logo;
            tempModel.name = _homePageModel.name;
            tempModel.pic = _homePageModel.pic;
            _ShowroomBrandListModel = tempModel;
            
            [self CreateSubView];
            
        }else{
            
            [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
        [_scrollView.mj_header endRefreshing];
        [_scrollView.mj_footer endRefreshing];
    }];
}
#pragma mark - UIConfig
-(void)UIConfig{
    
    [self CreateScrollView];
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
-(void)CreateSubView
{
    [self CreateHeadView];
    [self CreateMiddleView];
    [self CreateBottomView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_navView.mas_bottom).with.offset(0);
        make.bottom.mas_equalTo(0);
        // 让scrollview的contentSize随着内容的增多而变化
        make.bottom.mas_equalTo(_bottomView.mas_bottom).with.offset(0);
    }];
}
-(void)CreateHeadView
{
    _headView = [[YYShowroomBrandHeadView alloc] initWithBlock:nil];
    [_container addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(floor((324.0f/750.0f)*SCREEN_WIDTH)+54);
    }];
    [_headView bottomIsHide:YES];
    _headView.ShowroomBrandListModel = _ShowroomBrandListModel;
}
-(void)CreateMiddleView
{
    UIView *line = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"efefef"]];
    [_container addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headView.mas_bottom).with.offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    _middleView = [UIView getCustomViewWithColor:nil];
    [_container addSubview:_middleView];
    if([self haveMiddleView])
    {
        [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).with.offset(0);
            make.left.right.mas_equalTo(0);
        }];
        
        UILabel *titleLabel = [UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"活动",nil) WithFont:14.0f WithTextColor:[UIColor colorWithHex:@"a2a2a2"] WithSpacing:0];
        [_middleView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        
        UILabel *adTitleLabel = [UILabel getLabelWithAlignment:0 WithTitle:[_homePageModel getTitleStr] WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [_middleView addSubview:adTitleLabel];
        adTitleLabel.font=[UIFont boldSystemFontOfSize:13.0f];
        [adTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            
            if(![NSString isNilOrEmpty:[_homePageModel getTitleStr]])
            {
                make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(11);
            }else
            {
                make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(0);
            }
        }];
        
        
        UILabel *timeLabel = [UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [_middleView addSubview:timeLabel];
        NSString *value = @"";
        if(_homePageModel.adEndTime&&_homePageModel.adStartTime)
        {
            NSString *formatter = @"yyyy.MM.dd";
            value = [[NSString alloc] initWithFormat:@"%@ - %@",getTimeStr([_homePageModel.adStartTime longLongValue]/1000, formatter),getTimeStr([_homePageModel.adEndTime longLongValue]/1000, formatter)];
        }
        timeLabel.text = value;
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if(_homePageModel.adEndTime&&_homePageModel.adStartTime)
            {
                make.top.mas_equalTo(adTitleLabel.mas_bottom).with.offset(11);
            }else
            {
                make.top.mas_equalTo(adTitleLabel.mas_bottom).with.offset(0);
            }
            make.left.mas_equalTo(37);
            make.right.mas_equalTo(-15);
        }];
        
        if(_homePageModel.adEndTime&&_homePageModel.adStartTime)
        {
            UIImageView *timeicon = [UIImageView getImgWithImageStr:@"Showroom_time"];
            [_middleView addSubview:timeicon];
            timeicon.contentMode = UIViewContentModeScaleAspectFit;
            [timeicon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(17);
                make.centerY.mas_equalTo(timeLabel);
                make.width.height.mas_equalTo(16);
            }];
        }
        
        
        UILabel *addressLabel = [UILabel getLabelWithAlignment:0 WithTitle:_homePageModel.adAddress WithFont:13.0f WithTextColor:nil WithSpacing:0];
        [_middleView addSubview:addressLabel];
        addressLabel.numberOfLines = 0;
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if(_homePageModel.adEndTime&&_homePageModel.adStartTime)
            {
                make.top.mas_equalTo(timeLabel.mas_bottom).with.offset(11);
            }else
            {
                make.top.mas_equalTo(timeLabel.mas_bottom).with.offset(0);
            }
            make.left.mas_equalTo(37);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-15);
        }];
        
        if(_homePageModel.adAddress)
        {
            UIImageView *addressicon = [UIImageView getImgWithImageStr:@"Showroom_address"];
            [_middleView addSubview:addressicon];
            addressicon.contentMode = UIViewContentModeScaleAspectFit;
            [addressicon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(17);
                make.centerY.mas_equalTo(addressLabel);
                make.height.mas_equalTo(20);
                make.width.mas_equalTo(13);
            }];
        }
        
    }else
    {
        [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).with.offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
    }
}
-(void)CreateBottomView
{
    _bottomView = [UIView getCustomViewWithColor:nil];
    [_container addSubview:_bottomView];
    if(![NSString isNilOrEmpty:_homePageModel.brief])
    {
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_middleView.mas_bottom).with.offset(0);
            make.left.right.mas_equalTo(0);
        }];
        
        UILabel *titleLabel = [UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"简介",nil) WithFont:14.0f WithTextColor:[UIColor colorWithHex:@"a2a2a2"] WithSpacing:0];
        [_bottomView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        
        _infoAboutWebview=[[WKWebView alloc] init];
        [_bottomView addSubview:_infoAboutWebview];
        _infoAboutWebview.userInteractionEnabled=NO;
        _infoAboutWebview.navigationDelegate = self;
        [_infoAboutWebview sizeToFit];
        [_infoAboutWebview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(12);
            make.height.mas_equalTo(0);
            make.bottom.mas_equalTo(-30);
        }];
        
        NSString *htmlStr = getHTMLStringWithContent_phone(_homePageModel.brief, @"13px/19px", @"#000000");
        [_infoAboutWebview loadHTMLString:htmlStr baseURL:nil];
        
    }else
    {
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_middleView.mas_bottom).with.offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
    }
}
#pragma mark - SomeAction
-(void)GoBack:(id)sender {
    if(_cancelButtonClicked)
    {
        _cancelButtonClicked();
    }
}
-(BOOL)haveMiddleView
{
    BOOL _haveVlaue = NO;
    if(![NSString isNilOrEmpty:_homePageModel.adAddress])
    {
        _haveVlaue = YES;
    }else if(![NSString isNilOrEmpty:[_homePageModel getTitleStr]])
    {
        _haveVlaue = YES;
    }else if(_homePageModel.adEndTime&&_homePageModel.adStartTime)
    {
        _haveVlaue = YES;
    }
    return _haveVlaue;
}
#pragma mark - WKNavigationDelegate

//加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.body.offsetHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        CGFloat height = 0;
        if(![NSString isNilOrEmpty:_homePageModel.brief])
        {
            height = floor([result doubleValue])+2;
        }else
        {
            height = 0;
        }
        [webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
//        CGFloat _height = CGRectGetMaxY(_retailerNameBackView.frame) + 30;
//        _cellblock(@"height",_height);
    }];
}
#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
