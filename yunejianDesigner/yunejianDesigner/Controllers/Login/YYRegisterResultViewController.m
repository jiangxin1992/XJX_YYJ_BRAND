//
//  YYRegisterResultViewController.m
//  Yunejian
//
//  Created by Apple on 15/9/27.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYRegisterResultViewController.h"

#import "YYUserApi.h"
#import "YYRspStatusAndMessage.h"

@interface YYRegisterResultViewController ()

@end

@implementation YYRegisterResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = [UIColor whiteColor];
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updateUI{

    _view1.hidden = YES;
    //_view2.hidden = YES;
    //_view3.hidden = YES;

    _titleLabel.text = NSLocalizedString(@"买手店入驻",nil);
    _sendBtn.layer.cornerRadius = 2.5;
    _sendBtn.layer.masksToBounds = YES;
    if (_status == 0) {
        _view1.hidden = NO;
        _tipLabel.text = [NSString stringWithFormat:NSLocalizedString(@"已经向 %@ 发送邮件",nil),_email];
    }else if (_status == 1){
        //_view2.hidden = NO;
    }else if (_status == 2){
        //_view3.hidden = NO;
    }
}

- (IBAction)lookEmailHandler:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",_email]]];
    
}



- (IBAction)dismissHandler:(id)sender {
    [_sendBtn stop];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)reSendEmailHandler:(id)sender {
    //用户类型0，desinger;1,buyer;2,salesman
    [YYUserApi reSendMailConfirmMail:_email andUserType:[NSString stringWithFormat:@"%ld",(long)_registerType]  andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            
            [YYToast showToastWithTitle:NSLocalizedString(@"发送成功！",nil) andDuration:kAlertToastDuration];
        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
        
    }];
    _sendBtn.enabled = NO;
    _sendBtn.backgroundColor = [UIColor colorWithHex:@"afafaf"];
    [_sendBtn startWithSecond:60];
    _sendBtn.titleLabel.text = NSLocalizedString(@"获取验证码（60s）",nil);
    [_sendBtn setTitle:NSLocalizedString(@"获取验证码（60s）",nil) forState:UIControlStateNormal];
    [_sendBtn didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:NSLocalizedString(@"没收到，再发一封（%ds）",nil),second];
        return title;
    }];
    [_sendBtn didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        _sendBtn.backgroundColor = [UIColor blackColor];
        return NSLocalizedString(@"没收到，再发一封",nil);
        
    }];
}
@end
