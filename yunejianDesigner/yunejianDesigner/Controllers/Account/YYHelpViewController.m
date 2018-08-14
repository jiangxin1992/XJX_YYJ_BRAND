//
//  YYHelpViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/12.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYHelpViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"

// 自定义视图
#import "YYBaseWebView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

@interface YYHelpViewController()

@property (weak, nonatomic) IBOutlet YYBaseWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation YYHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = NSLocalizedString(@"返回",nil);
    navigationBarViewController.nowTitle = IsPhone6_gt?NSLocalizedString(@"帮助中心•设计师",nil):NSLocalizedString(@"帮助中心",nil);
    [_containerView addSubview:navigationBarViewController.view];
    __weak UIView *_weakContainerView = _containerView;
    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakContainerView.mas_top);
        make.left.equalTo(_weakContainerView.mas_left);
        make.bottom.equalTo(_weakContainerView.mas_bottom);
        make.right.equalTo(_weakContainerView.mas_right);
    }];
    
    WeakSelf(ws);
    __block YYNavigationBarViewController *blockVc = navigationBarViewController;
    
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            if(ws.webView.canGoBack){
                [ws.webView goBack];
            }else{
                if(ws.cancelButtonClicked){
                    ws.cancelButtonClicked();
                }
                blockVc = nil;
            }
        }
    }];
    
    popWindowAddBgView(self.view);
    
    NSString *_weburl = @"";
    NSString *_kLastYYServerURL = [[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL];
    //字条串是否包含有某字符串
    if ([_kLastYYServerURL containsString:@"show.ycofoundation.com"]) {
        //展示
        _weburl = @"http://mshow.ycosystem.com/helpCenter?user=0&noTitle=true";
    }else if ([_kLastYYServerURL containsString:@"test.ycosystem.com"]){
        //测试
        _weburl = @"http://mt.ycosystem.com/helpCenter?user=0&noTitle=true";
    }else if ([_kLastYYServerURL containsString:@"ycosystem.com"]){
        //生产
        _weburl = @"http://m.ycosystem.com/helpCenter?user=0&noTitle=true";
    }
    if([LanguageManager isEnglishLanguage]){
        _weburl = [[NSString alloc] initWithFormat:@"%@&lang=en",_weburl];
    }
    self.webView.urlString = _weburl;

    [self.webView setJumpPageSuccess:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageHelp];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageHelp];
}
@end
