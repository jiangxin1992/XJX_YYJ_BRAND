//
//  YYFeedbackViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/21.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYFeedbackViewController.h"

#import "YYRspStatusAndMessage.h"
#import "YYUserApi.h"
#import "YYNavigationBarViewController.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "MLInputDodger.h"
#import "regular.h"

@interface YYFeedbackViewController ()

@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *txtContaier;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *whiteViewHeightLayout;

@end

@implementation YYFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageFeedback];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageFeedback];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData{}
-(void)PrepareUI{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = NSLocalizedString(@"建议反馈",nil);
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
            [ws cancelClicked:nil];
            blockVc = nil;
        }
    }];
    _txtContaier.layer.cornerRadius = 2.5;
    _txtContaier.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
    _txtContaier.layer.borderWidth = 1;
    _txtContaier.layer.masksToBounds = YES;
    
    float viewTxtHeight = (SCREEN_WIDTH - 35)*640/680;
    [_txtContaier setConstraintConstant:viewTxtHeight forAttribute:NSLayoutAttributeHeight];
    _saveBtn.layer.cornerRadius = 2.5;
    _saveBtn.layer.masksToBounds = YES;

    _whiteViewHeightLayout.constant = kTabbarHeight;
    
}
#pragma mark - SomeAction
- (IBAction)cancelClicked:(id)sender{
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}

- (IBAction)saveClicked:(id)sender{
    
   NSString *feedbackString = trimWhitespaceOfStr(_feedbackTextView.text);
    
    if (! feedbackString || [feedbackString length] == 0) {
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入您的反馈内容",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    [YYUserApi userFeedBack:feedbackString andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if (rspStatusAndMessage.status == kCode100) {
            [YYToast showToastWithTitle:NSLocalizedString(@"反馈成功!",nil) andDuration:kAlertToastDuration];
            if (_modifySuccess) {
                _modifySuccess();
            }
        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [regular dismissKeyborad];
}
#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
