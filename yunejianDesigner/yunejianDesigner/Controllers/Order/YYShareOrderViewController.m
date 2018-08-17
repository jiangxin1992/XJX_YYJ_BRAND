//
//  YYShareOrderViewController.m
//  Yunejian
//
//  Created by yyj on 15/8/28.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYShareOrderViewController.h"
#import "QRCodeGenerator.h"
#import "YYUserApi.h"
#import "YYRspStatusAndMessage.h"

@interface YYShareOrderViewController ()

@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIButton *emailBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderCodeBtn;
@property (weak, nonatomic) IBOutlet UIView *emailTab;
@property (weak, nonatomic) IBOutlet UIView *codeTab;

@property (weak, nonatomic) IBOutlet UILabel *helpText1;
@property (weak, nonatomic) IBOutlet UILabel *helpText2;
@property (weak, nonatomic) IBOutlet UILabel *helpText3;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (nonatomic) NSInteger tabIndex;//0emailtab  1codetab
@property (nonatomic) float originalHeight;
- (IBAction)tabBtnChangeHandler:(id)sender;

- (IBAction)sendEmailHandler:(id)sender;
@end

@implementation YYShareOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_emailBtn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateNormal];
    [_emailBtn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] forState:UIControlStateSelected];
    [_orderCodeBtn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateNormal];
    [_orderCodeBtn setTitleColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] forState:UIControlStateSelected];
    _originalHeight = _viewHeightLayoutConstraint.constant;
    
    NSString *helpTextStr = _helpText1.text;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: helpTextStr];
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont boldSystemFontOfSize:23] range: NSMakeRange(0,1)];
    _helpText1.attributedText=attributedStr;
    
    helpTextStr= _helpText2.text;
    attributedStr = [[NSMutableAttributedString alloc] initWithString: helpTextStr];
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont boldSystemFontOfSize:23] range: NSMakeRange(0,1)];
    _helpText2.attributedText=attributedStr;
    helpTextStr= _helpText3.text;
    attributedStr = [[NSMutableAttributedString alloc] initWithString: helpTextStr];
    [attributedStr addAttribute: NSFontAttributeName value: [UIFont boldSystemFontOfSize:23] range: NSMakeRange(0,1)];
    _helpText3.attributedText=attributedStr;
    
    popWindowAddBgView(self.view);
    _tabIndex = 1;
    [self updateUI];
}

- (void)updateUI{
    if (_tabIndex == 0) {
        _emailBtn.selected = YES;
        _orderCodeBtn.selected = NO;
        _emailTab.hidden = YES;
        _codeTab.hidden = NO;
        _viewHeightLayoutConstraint.constant = _originalHeight-190;
    }else if(_tabIndex == 1){
        _emailBtn.selected = NO;
        _orderCodeBtn.selected = YES;

        _emailTab.hidden = NO;
        _codeTab.hidden = YES;
        if (_currentYYOrderInfoModel) {
            QRPointType pointType = QRPointRect;
            QRPositionType positionType = QRPositionNormal;
            UIColor *codeColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
            
            
            UIImage *image = [QRCodeGenerator qrImageForString:_currentYYOrderInfoModel.shareCode imageSize:_orderImage.frame.size.width withPointType:pointType withPositionType:positionType withColor:codeColor];
            if (image) {
                _orderImage.image = image;
            }
        }
        _viewHeightLayoutConstraint.constant = _originalHeight;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClicked:(id)sender{
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}
- (IBAction)tabBtnChangeHandler:(id)sender {
    if([sender isEqual:_emailBtn]){
        _tabIndex = 0;
    }else if([sender isEqual:_orderCodeBtn]){
        _tabIndex = 1;
    }
    [self updateUI];
}

- (IBAction)sendEmailHandler:(id)sender {
    if([_emailText.text isEqualToString:@""] || _currentYYOrderInfoModel.shareCode == nil){
        return;
    }
    
    //_currentYYOrderInfoModel.shareCode
    [YYUserApi sendOrderByMail:_emailText.text andCode:_currentYYOrderInfoModel.orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            _emailText.text = @"";
            [YYToast showToastWithTitle:NSLocalizedString(@"发送成功！",nil) andDuration:kAlertToastDuration];
            [self cancelClicked:nil];
        }else{
            [YYToast showToastWithTitle:NSLocalizedString(@"发送失败！",nil) andDuration:kAlertToastDuration];
        }

    }];
}
@end
