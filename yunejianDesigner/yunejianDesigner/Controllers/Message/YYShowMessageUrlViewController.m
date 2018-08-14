//
//  YYShowMessageUrlViewController.m
//  YunejianBuyer
//
//  Created by chuanjun sun on 2017/11/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowMessageUrlViewController.h"

@interface YYShowMessageUrlViewController ()

@end

@implementation YYShowMessageUrlViewController

#pragma mark - --------------生命周期--------------
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{

}


#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)okButtonClick{
    [self cancel];
    // 代理
    if (_okClick) {
        _okClick(self.message);
    }
}
#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------UI----------------------
// 创建子控件
- (void)PrepareUI{
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];


    UIView *cancel = [[UIView alloc] initWithFrame:self.view.bounds];
    cancel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cancel];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [cancel addGestureRecognizer:tap];


    UIView *blackBg = [[UIView alloc] init];
    blackBg.backgroundColor = _define_black_color;
    [self.view addSubview:blackBg];

    [blackBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(25);
        make.right.mas_offset(-25);
        make.height.mas_equalTo(230);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];

    UIView *whiteBg = [[UIView alloc] init];
    whiteBg.backgroundColor = _define_white_color;
    [blackBg addSubview:whiteBg];

    [whiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.right.mas_offset(-5);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(@"即将离开此页面跳转到浏览器", nil);
    [whiteBg addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(38);
        make.centerX.mas_equalTo(0);
    }];

    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = _define_black_color;

    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.textColor = [UIColor colorWithHex:@"919191"];
    messageLabel.font = [UIFont systemFontOfSize:13];
    messageLabel.numberOfLines = 2;
    messageLabel.text = self.message;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [whiteBg addSubview:messageLabel];

    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(9);
    }];

    UIButton *okButton = [[UIButton alloc] init];
    okButton.backgroundColor = _define_black_color;
    [okButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [okButton setTitleColor:_define_white_color forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
    okButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [whiteBg addSubview:okButton];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(42.5);
        make.right.mas_equalTo(-42.5);
        make.height.mas_equalTo(38);
        make.top.mas_equalTo(121);
    }];


    UIButton *cancelButton = [[UIButton alloc] init];
    cancelButton.backgroundColor = _define_white_color;
    [cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelButton setTitleColor:_define_black_color forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelButton.layer.borderWidth = 1;
    cancelButton.layer.borderColor = _define_black_color.CGColor;
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [whiteBg addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(42.5);
        make.right.mas_equalTo(-42.5);
        make.height.mas_equalTo(38);
        make.top.mas_equalTo(okButton.mas_bottom).offset(10);
    }];


}

#pragma mark - --------------other----------------------

@end
