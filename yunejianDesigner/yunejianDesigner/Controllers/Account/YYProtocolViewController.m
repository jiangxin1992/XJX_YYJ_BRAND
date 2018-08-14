//
//  YYProtocolViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/11/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYProtocolViewController.h"
#import "YYNavigationBarViewController.h"
#import "YYBaseWebView.h"

@interface YYProtocolViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet YYBaseWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeightLayout;

@end

@implementation YYProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self LoadingWebview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageProtocol];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageProtocol];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{

    _navHeightLayout.constant = kStatusBarAndNavigationBarHeight-20.f;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = _nowTitle;
    [_containerView insertSubview:navigationBarViewController.view atIndex:0];
    __weak UIView *_weakContainerView = _containerView;
    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(_weakContainerView.mas_left);
        make.bottom.equalTo(_weakContainerView.mas_bottom);
        make.right.equalTo(_weakContainerView.mas_right);
    }];
    
    WeakSelf(ws);
    __block YYNavigationBarViewController *blockVc = navigationBarViewController;
    
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            [ws cancelClicked:nil];
            blockVc = nil;
        }
    }];
    _webView.backgroundColor = _define_white_color;
}
#pragma mark - SomeAction
- (IBAction)cancelClicked:(id)sender{
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}
-(void)LoadingWebview{
    //    隐私权保护声明 secrecyAgreement/ 服务协议 serviceAgreement
    NSString *url = nil;
    if([_protocolType isEqualToString:@"secrecyAgreement"])
    {
        if([LanguageManager isEnglishLanguage]){
            url = @"http://cdn2.ycosystem.com/yej-tb/static/secrecyAgreement_en.html";
        }else{
            url = @"https://scdn2.ycosystem.com/yej-tb/static/secrecyAgreement.html";
        }
        
    }else if([_protocolType isEqualToString:@"serviceAgreement"])
    {
        if([LanguageManager isEnglishLanguage]){
            url = @"http://cdn2.ycosystem.com/yej-tb/static/serviceAgreement_en.html";
        }else{
            url = @"https://scdn2.ycosystem.com/yej-tb/static/serviceAgreement.html";
        }
    }
    if(![NSString isNilOrEmpty:url])
    {
        _webView.urlString = url;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
