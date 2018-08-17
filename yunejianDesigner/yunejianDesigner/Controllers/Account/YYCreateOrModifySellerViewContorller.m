//
//  YYCreateOrModifySellerViewContorller.m
//  Yunejian
//
//  Created by yyj on 15/7/17.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYCreateOrModifySellerViewContorller.h"

#import "YYUserApi.h"
#import "YYShowroomApi.h"
#import "YYRspStatusAndMessage.h"
#import "YYNavigationBarViewController.h"
#import "RegexKitLite.h"
#import "YYUser.h"

static CGFloat yellowView_default_constant = 127;

@interface YYCreateOrModifySellerViewContorller ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yellowViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *yellowView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,strong)YYNavigationBarViewController *navigationBarViewController;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (nonatomic,assign) BOOL isShowroom;

@end

@implementation YYCreateOrModifySellerViewContorller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageCreateOrModifySeller];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageCreateOrModifySeller];
}

-(void)PrepareData{
    YYUser *user = [YYUser currentUser];
    if(user.userType == 5)
    {
        _isShowroom = YES;
    }else
    {
        _isShowroom = NO;
    }
}
-(void)PrepareUI{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    self.navigationBarViewController = navigationBarViewController;
    if(_isShowroom){
        navigationBarViewController.nowTitle = NSLocalizedString(@"新建Showroom子账号",nil);
    }else{
        navigationBarViewController.nowTitle = NSLocalizedString(@"新建销售代表",nil);
    }
    
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
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            if(ws.cancelButtonClicked){
                ws.cancelButtonClicked();
            }
        }
    }];
    
    _createBtn.layer.cornerRadius = 2.5;
    //   UIImageView *imageText=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_icon"]];
    //   _nameField.rightView = imageText;
    //   _nameField.rightViewMode=UITextFieldViewModeAlways;
    //   popWindowAddBgView(self.view);
    
    _nameField.delegate = self;
    _emailField.delegate = self;
    _passwordField.delegate = self;
}
#pragma mark - SomeAction
- (IBAction)cancelClicked:(id)sender{
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}

- (IBAction)saveClicked:(id)sender{
    NSString *name = trimWhitespaceOfStr(_nameField.text);
    NSString *email = trimWhitespaceOfStr(_emailField.text);
    NSString *password = trimWhitespaceOfStr(_passwordField.text);
    
    if (! name || [name length] == 0) {
        
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入用户名",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    
    if (! email || [email length] == 0) {
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入email！",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    BOOL isEmail = [email isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];
    if (!isEmail) {
        [YYToast showToastWithTitle:NSLocalizedString(@"email格式不对！",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if (! password || [password length] == 0) {
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入初始密码！",nil) andDuration:kAlertToastDuration];
        return;
    }
    if(_isShowroom){
        [YYShowroomApi createSubShowroomWithUsername:name email:email password:password andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSNumber *userId, NSError *error) {
            if (rspStatusAndMessage.status == kCode100) {
                [YYToast showToastWithTitle:NSLocalizedString(@"创建成功！",nil) andDuration:kAlertToastDuration];
                if (_modifySuccess) {
                    _modifySuccess(userId);//=====
                }
            }else{
                [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
        }];
    }else{
        [YYUserApi createSellerWithUsername:name email:email password:password andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
            if (rspStatusAndMessage.status == kCode100) {
                [YYToast showToastWithTitle:NSLocalizedString(@"创建成功！",nil) andDuration:kAlertToastDuration];
                if (_modifySuccess) {
                    _modifySuccess(@0);
                }
            }else{
                [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
        }];
    }
//    createSubShowroomWithUsername
    
}


#pragma mark - Other

@end
