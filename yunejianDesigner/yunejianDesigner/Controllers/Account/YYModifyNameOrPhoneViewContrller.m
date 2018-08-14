//
//  YYModifyNameOrPhoneViewContrller.m
//  Yunejian
//
//  Created by yyj on 15/7/16.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYModifyNameOrPhoneViewContrller.h"
#import "YYUserApi.h"
#import "YYRspStatusAndMessage.h"
#import "RegexKitLite.h"
#import "YYNavigationBarViewController.h"
#import "YYPickView.h"
#import "regular.h"
#import "YYVerifyTool.h"

@interface YYModifyNameOrPhoneViewContrller ()<UITextFieldDelegate,YYPickViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *chooseCountryCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLine;
@property (weak, nonatomic) IBOutlet UIButton *phoneTipButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downTitleLabelTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLabelTopLayout;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property(nonatomic,strong) YYPickView *countryCodePickerView;

@end

@implementation YYModifyNameOrPhoneViewContrller

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self updateUI];
    [_textField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    if (_currentShowType == ShowTypeUsername) {
        // 进入埋点
        [MobClick beginLogPageView:kYYPageModifyName];
    }else if (_currentShowType == ShowTypePhone) {
        // 进入埋点
        [MobClick beginLogPageView:kYYPageModifyPhone];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    if (_currentShowType == ShowTypeUsername) {
        // 进入埋点
        [MobClick endLogPageView:kYYPageModifyName];
    }else if (_currentShowType == ShowTypePhone) {
        // 进入埋点
        [MobClick endLogPageView:kYYPageModifyPhone];
    }
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData{}
-(void)PrepareUI{
    _phoneTipButton.hidden = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    
    _countryCodeTitleLabel.text = NSLocalizedString(@"地区/区号",nil);
    
    _countryCodeLabel.text = @"";
    
    if (_currentShowType == ShowTypeUsername) {
        _titleLabel.text = NSLocalizedString(@"用户名", nil);
        _textField.keyboardType = UIKeyboardTypeDefault;
        navigationBarViewController.nowTitle = NSLocalizedString(@"修改用户名",nil);
        _chooseCountryCodeButton.hidden = YES;
        _countryCodeTitleLabel.hidden = YES;
        _countryCodeLabel.hidden = YES;
        _countryCodeLine.hidden = YES;
        
        _downLineTopLayout.constant = 55;
        _downTitleLabelTopLayout.constant = 0;
        _downLabelTopLayout.constant = 0;
    }else if (_currentShowType == ShowTypePhone) {
        _titleLabel.text = NSLocalizedString(@"手机号", nil);
        _textField.keyboardType = UIKeyboardTypePhonePad;
        navigationBarViewController.nowTitle = NSLocalizedString(@"修改电话",nil);
        _chooseCountryCodeButton.hidden = NO;
        _countryCodeTitleLabel.hidden = NO;
        _countryCodeLabel.hidden = NO;
        _countryCodeLine.hidden = NO;
        
        _downLineTopLayout.constant = 110;
        _downTitleLabelTopLayout.constant = 56;
        _downLabelTopLayout.constant = 56;
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
    __block YYNavigationBarViewController *blockVc = navigationBarViewController;
    
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            [ws cancelClicked:nil];
            blockVc = nil;
        }
    }];
    _saveBtn.layer.cornerRadius = 2.5;
    _saveBtn.layer.masksToBounds = YES;
    //popWindowAddBgView(self.view);
    
//    _textField
    if (_currentShowType == ShowTypeUsername) {
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
    }else if (_currentShowType == ShowTypePhone) {
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.clearButtonMode = UITextFieldViewModeNever;
    }
    _textField.delegate = self;
    
}
#pragma mark - updateUI
//改为私有方法 防止反复调用这个方法
- (void)updateUI{
    
    if (_userInfo) {
        if (_currentShowType == ShowTypeUsername) {
            _textField.text = _userInfo.username;
            _countryCodeLabel.text = @"";
        }else if (_currentShowType == ShowTypePhone) {
            _textField.text = getPhoneNum(_userInfo.phone);
            _countryCodeLabel.text = getCountryCodeDetailDes(_userInfo.phone);
        }
    }

}
-(void)toobarDonBtnHaveClick:(YYPickView *)pickView resultString:(NSString *)resultString{
    //    +44 英国
    _countryCodeLabel.text = resultString;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [regular dismissKeyborad];
}
#pragma mark - SomeAction
-(NSInteger )getCountryCode{
    NSInteger countryCode = 86;
    NSArray *getCodeArr = [_countryCodeLabel.text componentsSeparatedByString:@" "];
    if(getCodeArr.count){
        NSArray *countryCodeArr =  [getCodeArr[0] componentsSeparatedByString:@"+"];
        if(countryCodeArr.count >= 2){
            countryCode = [countryCodeArr[1] integerValue];
        }
    }
    return countryCode;
}
-(BOOL)checkPhoneWarnWithPhoneCode:(NSInteger )phoneCode{
    if([NSString isNilOrEmpty:_textField.text]){
        //没有的时候不显示警告
        return YES;
    }else{
        if([YYVerifyTool numberVerift:_textField.text]){
            //通过数字验证
            if(phoneCode == 86){
                //            中国
                if(_textField.text.length == 11){
                    return YES;
                }
            }else{
                //            国外
                if(_textField.text.length <= 20 && _textField.text.length >= 6){
                    return YES;
                }
                
            }
        }
    }    return NO;
}
- (IBAction)chooseCountryAction:(id)sender {
    [regular dismissKeyborad];
    if(self.countryCodePickerView == nil){
        NSArray *pickData = getContactLocalData();
        self.countryCodePickerView=[[YYPickView alloc] initPickviewWithArray:pickData isHaveNavControler:NO];
        self.countryCodePickerView.uidataType = UIDataTypeModifyLimit;
        [self.countryCodePickerView show:self.view];
        self.countryCodePickerView.delegate = self;
    }else
    {
        [self.countryCodePickerView show:self.view];
    }
}
- (IBAction)cancelClicked:(id)sender{
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}

- (IBAction)saveClicked:(id)sender{
    NSString *textFiedlValue = trimWhitespaceOfStr(_textField.text);
    
    NSString *username = nil;
    NSString *phone = nil;
    
    if (_currentShowType == ShowTypeUsername) {
        if (! textFiedlValue || [textFiedlValue length] == 0) {
            [YYToast showToastWithTitle:NSLocalizedString(@"请输入用户名",nil) andDuration:kAlertToastDuration];
            return;
        }
        username = textFiedlValue;
        phone = _userInfo.phone;
    
    }else if (_currentShowType == ShowTypePhone) {
        if (! textFiedlValue || [textFiedlValue length] == 0) {
            [YYToast showToastWithTitle:NSLocalizedString(@"请输入电话",nil) andDuration:kAlertToastDuration];
            return;
        }
        
        BOOL isNumbers = [textFiedlValue isMatchedByRegex:@"^[0-9]*$"];
        if (!isNumbers) {
            [YYToast showToastWithTitle:NSLocalizedString(@"电话号码请输入数字！",nil) andDuration:kAlertToastDuration];
            return;
        }
        
        NSInteger countryCode = [self getCountryCode];
        
        BOOL _isAvailably = [self checkPhoneWarnWithPhoneCode:countryCode];
        if (!_isAvailably) {
            [YYToast showToastWithTitle:NSLocalizedString(@"手机号码格式错误",nil) andDuration:kAlertToastDuration];
            return;
        }
        
        username = _userInfo.username;
        phone = textFiedlValue;
    }
    
    if (_userInfo.userType == YYUserTypeRetailer){
        NSString *_province = [LanguageManager isEnglishLanguage]?self.userInfo.provinceEn:self.userInfo.province;
        NSString *_city = [LanguageManager isEnglishLanguage]?self.userInfo.cityEn:self.userInfo.city;
        
        NSString *province = _province;
        NSString *city = _city;
        if (_currentShowType == ShowTypeUsername) {
            NSArray *phoneArr = [phone componentsSeparatedByString:@" "];
            if(phoneArr.count > 1){
                
            }else{
                phone = [[NSString alloc] initWithFormat:@"+86 %@",phone];
            }
//            phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        }else if (_currentShowType == ShowTypePhone) {
            NSArray *getCodeArr = [_countryCodeLabel.text componentsSeparatedByString:@" "];
            if(getCodeArr.count){
//                NSString *countryCode = [getCodeArr[0] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                phone = [[NSString alloc] initWithFormat:@"%@ %@",getCodeArr[0],phone];
            }
        }
        
        [YYUserApi updateBuyerUsername:username phone:phone  province:province city:city andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
            if (rspStatusAndMessage.status == YYReqStatusCode100) {
                [YYToast showToastWithTitle:NSLocalizedString(@"修改成功！",nil) andDuration:kAlertToastDuration];
                if (_modifySuccess) {
                    _modifySuccess();
                }
            }else{
                [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
            
        }];
    }else  if (_userInfo.userType == YYUserTypeDesigner) {
        if (_currentShowType == ShowTypeUsername) {
            NSArray *phoneArr = [phone componentsSeparatedByString:@" "];
            if(phoneArr.count > 1){
                
            }else{
                phone = [[NSString alloc] initWithFormat:@"+86 %@",phone];
            }
//            phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        }else if (_currentShowType == ShowTypePhone) {
            NSArray *getCodeArr = [_countryCodeLabel.text componentsSeparatedByString:@" "];
            if(getCodeArr.count){
//                NSString *countryCode = [getCodeArr[0] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                phone = [[NSString alloc] initWithFormat:@"%@ %@",getCodeArr[0],phone];
            }
        }
        [YYUserApi updateDesignerUsername:username phone:phone andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
            if (rspStatusAndMessage.status == YYReqStatusCode100) {
                
                [YYToast showToastWithTitle:NSLocalizedString(@"修改成功！",nil) andDuration:kAlertToastDuration];
                if (_modifySuccess) {
                    _modifySuccess();
                }
            }else{
                
                [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            }
            
        }];
    }else{
    
    }
    
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(textField == _textField && _currentShowType == ShowTypePhone){
        
        NSInteger countryCode = [self getCountryCode];
        BOOL _ishide = [self checkPhoneWarnWithPhoneCode:countryCode];
        _phoneTipButton.hidden = _ishide;
    }
}

#pragma mark - Other

@end
