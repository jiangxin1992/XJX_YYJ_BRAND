//
//  YYModifyPasswordViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/14.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYModifyPasswordViewController.h"
#import "YYUserApi.h"
#import "YYRspStatusAndMessage.h"
#import "YYNavigationBarViewController.h"

@interface YYModifyPasswordViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *oldPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *nowPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldPwdWidthLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *newstPwdWidthLayout1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmPwdWidthLayout;


@end

@implementation YYModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([LanguageManager isEnglishLanguage]){
        _oldPwdWidthLayout.constant = 95;
        _newstPwdWidthLayout1.constant = 95;
        _confirmPwdWidthLayout.constant = 95;
    }else{
        _oldPwdWidthLayout.constant = 65;
        _newstPwdWidthLayout1.constant = 65;
        _confirmPwdWidthLayout.constant = 65;
    }
    
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    //self.navigationBarViewController = navigationBarViewController;
    navigationBarViewController.nowTitle = NSLocalizedString(@"登录密码",nil);
    [_containerView insertSubview:navigationBarViewController.view atIndex:0];
    //[_containerView addSubview:navigationBarViewController.view];
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
            [ws cancelClicked:nil];
            blockVc = nil;
        }
    }];
    
    _saveBtn.layer.cornerRadius = 2.5;
    _saveBtn.layer.masksToBounds = YES;
    
    _oldPasswordField.delegate = self;
    _nowPasswordField.delegate = self;
    _confirmPasswordField.delegate = self;
    
    //popWindowAddBgView(self.view);
    
    [_oldPasswordField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageModifyPassword];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageModifyPassword];
}

- (IBAction)cancelClicked:(id)sender{
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}

- (IBAction)saveClicked:(id)sender{
    NSString *old = trimWhitespaceOfStr(_oldPasswordField.text);
    NSString *now = trimWhitespaceOfStr(_nowPasswordField.text);
    NSString *confirm = trimWhitespaceOfStr(_confirmPasswordField.text);
    
    if (! old || [old length] == 0) {
        
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入原来的密码",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    
    if (! now || [now length] == 0) {
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入新密码！",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if (! confirm || [confirm length] == 0) {
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入确认密码！",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if (![now isEqualToString:confirm]) {
        [YYToast showToastWithTitle:NSLocalizedString(@"新密码和确认密码不一致！",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    [YYUserApi passwdUpdateWithOldPassword:md5(old) nowPassword:md5(now) andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            [YYToast showToastWithTitle:NSLocalizedString(@"密码修改成功！",nil) andDuration:kAlertToastDuration];
            if (_modifySuccess) {
                _modifySuccess();
            }
        }else{
           [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate



@end
