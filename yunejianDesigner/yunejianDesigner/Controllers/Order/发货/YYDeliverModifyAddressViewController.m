//
//  YYDeliverModifyAddressViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYDeliverModifyAddressViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MLInputDodger.h"

#import "YYDeliverModel.h"

#import "YYVerifyTool.h"

@interface YYDeliverModifyAddressViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic,strong) YYNavigationBarViewController *navigationBarViewController;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *phoneTipButton;

@property (weak, nonatomic) IBOutlet UITextView *detailAddressField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressWidthLayout;

@end

@implementation YYDeliverModifyAddressViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self updateUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageDeliverModifyAddress];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageDeliverModifyAddress];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare {
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData {

}
- (void)PrepareUI {

    _phoneTipButton.hidden = YES;

    WeakSelf(ws);

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = NSLocalizedString(@"修改收件地址",nil);
    [_containerView insertSubview:navigationBarViewController.view atIndex:0];

    __weak UIView *_weakContainerView = _containerView;
    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakContainerView.mas_top);
        make.left.equalTo(_weakContainerView.mas_left);
        make.bottom.equalTo(_weakContainerView.mas_bottom);
        make.right.equalTo(_weakContainerView.mas_right);
    }];

    __block YYNavigationBarViewController *blockVc = navigationBarViewController;
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            if(ws.cancelButtonClicked){
                ws.cancelButtonClicked();
            }
            blockVc = nil;
        }
    }];

    self.view.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.view registerAsDodgeViewForMLInputDodger];

    _phoneField.keyboardType = UIKeyboardTypeNumberPad;

    _nameField.delegate = self;
    _phoneField.delegate = self;
    _detailAddressField.textAlignment = NSTextAlignmentLeft;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _saveBtn.layer.cornerRadius = 2.5;
    _saveBtn.layer.masksToBounds = YES;

}

//#pragma mark - --------------UIConfig----------------------
//- (void)UIConfig {
//
//}
//
//#pragma mark - --------------请求数据----------------------
//- (void)RequestData {
//
//}

#pragma mark - --------------系统代理----------------------
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _phoneField){
        BOOL _ishide = [self checkPhoneWarn];
        _phoneTipButton.hidden = _ishide;
    }
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (IBAction)saveClicked:(id)sender{

    NSString *receiveName = trimWhitespaceOfStr(_nameField.text);
    NSString *receivePhone = trimWhitespaceOfStr(_phoneField.text);
    NSString *detailAddress = trimWhitespaceOfStr(_detailAddressField.text);

    if ([NSString isNilOrEmpty:receiveName]) {
        [YYToast showToastWithView:self.view title:NSLocalizedString(@"请输入收件人姓名",nil) andDuration:kAlertToastDuration];
        return;
    }

    if ([NSString isNilOrEmpty:detailAddress]) {
        [YYToast showToastWithView:self.view title:NSLocalizedString(@"请输入详细地址",nil) andDuration:kAlertToastDuration];
        return;
    }

    //6-20位纯数字
    BOOL isValidPhone = [YYVerifyTool internationalPhoneVerify:receivePhone];
    if(!isValidPhone){
        [YYToast showToastWithView:self.view title:NSLocalizedString(@"手机号码格式错误",nil) andDuration:kAlertToastDuration];
        return;
    }

    //做保存应该做的事
    _deliverModel.receiver = receiveName;
    _deliverModel.receiverAddress = detailAddress;
    _deliverModel.receiverPhone = receivePhone;

    if(_modifySuccess){
        _modifySuccess();
    }
}

#pragma mark - --------------自定义方法----------------------
-(BOOL)checkPhoneWarn{
    if([NSString isNilOrEmpty:_phoneField.text]){
        //没有的时候不显示警告
        return YES;
    }else{
        if([YYVerifyTool numberVerift:_phoneField.text]){
            //通过数字验证
            return YES;
        }
    }
    return NO;
}
-(void)updateUI{
    if([LanguageManager isEnglishLanguage]){
        _nameWidthLayout.constant = 120;
        _phoneWidthLayout.constant = 120;
        _addressWidthLayout.constant = 130;
    }else{
        _nameWidthLayout.constant = 102;
        _phoneWidthLayout.constant = 102;
        _addressWidthLayout.constant = 112;
    }

    _nameField.text = _deliverModel.receiver;
    _phoneField.text = _deliverModel.receiverPhone;
    _detailAddressField.text = _deliverModel.receiverAddress;
}
#pragma mark - --------------other----------------------


@end
