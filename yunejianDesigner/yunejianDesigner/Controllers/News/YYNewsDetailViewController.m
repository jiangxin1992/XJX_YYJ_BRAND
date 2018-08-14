//
//  YYNewsDetailViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/9/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYNewsDetailViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"

// 自定义视图
#import "YYBaseWebView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

@interface YYNewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet YYBaseWebView *webView;

@end

@implementation YYNewsDetailViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageNewsDetail];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageNewsDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    [self createNavView];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.frame = CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65);
    _webView.urlString =_newsUrlString;
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{}
-(void)createNavView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = NSLocalizedString(@"YCO新闻",nil);
    [_containerView insertSubview:navigationBarViewController.view atIndex:0];
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
            if(ws.cancelButtonClicked){
                ws.cancelButtonClicked();
            }
            blockVc = nil;
        }
    }];
}

#pragma mark - --------------请求数据----------------------
-(void)RequestData{}

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
