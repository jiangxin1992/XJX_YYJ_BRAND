//
//  YYRegisterTableEmailVerifyCell.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYRegisterTableEmailVerifyCell.h"

// 自定义视图

// 接口
#import "YYUserApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "JKCountDownButton.h"

@interface YYRegisterTableEmailVerifyCell()

@property (nonatomic, strong) UIButton *oprateResultButton;
@property (nonatomic, strong) UILabel *emailTipLabel;
@property (nonatomic, strong) UILabel *lookEmailLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *sendTimerLabel;
@property (nonatomic, strong) JKCountDownButton *sendButton;

@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) NSInteger emailType;

@end

@implementation YYRegisterTableEmailVerifyCell

#pragma mark - --------------生命周期--------------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth([UIScreen mainScreen].bounds), 0, 0);
        __weak typeof (self)weakSelf = self;
        
        self.oprateResultButton = [UIButton getCustomImgBtnWithImageStr:@"Validation_email_designer" WithSelectedImageStr:nil];
        [self.oprateResultButton setTitle:NSLocalizedString(@"验证邮箱", nil) forState:UIControlStateNormal];
        [self.oprateResultButton setTitleColor:_define_black_color forState:UIControlStateNormal];
        self.oprateResultButton.titleLabel.font = [UIFont systemFontOfSize:17];
        //        [self.oprateResultButton addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.oprateResultButton];
        [self.oprateResultButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(45);
            make.top.mas_equalTo(36);
            make.centerX.mas_equalTo(0);
        }];
        
        self.emailTipLabel = [[UILabel alloc] init];
        self.emailTipLabel.textColor = _define_black_color;
        self.emailTipLabel.font = [UIFont systemFontOfSize:14];
        self.emailTipLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.emailTipLabel];
        [self.emailTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(18);
            make.top.equalTo(weakSelf.oprateResultButton.mas_bottom).with.offset(34);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        
        self.lookEmailLabel = [[UILabel alloc] init];
        [self.lookEmailLabel setText:NSLocalizedString(@"请至邮箱点击激活链接，激活成功后即可登录", nil)];
        self.lookEmailLabel.numberOfLines = 2;
        [self.lookEmailLabel setTextColor:_define_black_color];
        self.lookEmailLabel.font = [UIFont systemFontOfSize:14];
        self.lookEmailLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.lookEmailLabel];
        [self.lookEmailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.emailTipLabel.mas_bottom).with.offset(5);
            make.left.mas_equalTo(10);
            make.centerX.mas_equalTo(0);
        }];
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.iconImageView setImage:[UIImage imageNamed:@"Validation_Image_designer"]];
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(156);
            make.height.mas_equalTo(156);
            make.top.equalTo(weakSelf.lookEmailLabel.mas_bottom).with.offset(30);
            make.centerX.mas_equalTo(0);
        }];
        
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.submitButton.backgroundColor = _define_black_color;
        self.submitButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.submitButton.layer.cornerRadius = 2.5;
        self.submitButton.layer.masksToBounds = YES;
        [self.submitButton addTarget:self action:@selector(submitHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(44);
            make.top.equalTo(weakSelf.iconImageView.mas_bottom).with.offset(35);
            make.left.mas_equalTo(20);
            make.centerX.mas_equalTo(0);
        }];
        
        self.sendTimerLabel = [[UILabel alloc] init];
        self.sendTimerLabel.textColor = [UIColor colorWithHex:@"ef4e31"];
        self.sendTimerLabel.font = [UIFont systemFontOfSize:14];
        self.sendTimerLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.sendTimerLabel];
        [self.sendTimerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(14);
            make.top.equalTo(weakSelf.submitButton.mas_bottom).with.offset(17);
            make.left.mas_equalTo(57);
            make.centerX.mas_equalTo(0);
        }];
        
        self.sendButton = [[JKCountDownButton alloc] init];
        [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.sendButton setTitle:NSLocalizedString(@"没收到，再发一封", nil) forState:UIControlStateNormal];
        self.sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.sendButton.backgroundColor = [UIColor clearColor];
        self.sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.sendButton.layer.cornerRadius = 2.5;
        self.sendButton.layer.masksToBounds = YES;
        [self.sendButton addTarget:self action:@selector(reSendEmailHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.sendButton];
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(16);
            make.top.equalTo(weakSelf.submitButton.mas_bottom).with.offset(17);
            make.left.mas_equalTo(57);
            make.centerX.mas_equalTo(0);
        }];
    }
    return self;
}

-(void)dealloc{
    [self.sendButton stop];
}

#pragma mark - --------------UIConfig----------------------
- (void)updateCellInfo:(YYTableViewCellInfoModel *)info {
    NSString *imgStr = @"";
    if([LanguageManager isEnglishLanguage]){
        imgStr = @"Validation_Image_designer_en";
    }else{
        imgStr = @"Validation_Image_designer";
    }
    [self.iconImageView setImage:[UIImage imageNamed:imgStr]];
    
    YYTableViewCellInfoModel *infoModel = info;
    [self.submitButton setTitle:infoModel.title forState:UIControlStateNormal];
    NSArray *valueInfo = [infoModel.value componentsSeparatedByString:@"|"];
    self.emailType = [[valueInfo objectAtIndex:0] integerValue];
    self.email = [valueInfo objectAtIndex:1];
    if(self.emailType == kEmailRegisterType){
        //[_oprateResultTipBtn hideByHeight:NO];
        self.oprateResultButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
        self.oprateResultButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
    }else if(self.emailType == kEmailPasswordType){
        [self.oprateResultButton setTitle:nil forState:UIControlStateNormal];
        //[_oprateResultTipBtn hideByHeight:YES];
    }
    
    NSString *emailTipStr =[NSString stringWithFormat:NSLocalizedString(@"已经向 %@ 发送邮件",nil),self.email];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: emailTipStr];
    NSRange range = [emailTipStr rangeOfString:self.email];
    if (range.location != NSNotFound) {
        //[attributedStr addAttribute: NSUnderlineStyleAttributeName value:@(NSUnderlineStyleThick) range: NSMakeRange(range.location, _email.length)];
    }//NSUnderlineStyleAttributeName: @(NSUnderlineStyleThick)
    self.emailTipLabel.attributedText = attributedStr;
    [self reSendEmailHandler:nil];
}

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (void)reSendEmailHandler:(id)sender {
    if(sender){
        if(self.emailType == kEmailRegisterType){
            [YYUserApi reSendMailConfirmMail:self.email andUserType:[NSString stringWithFormat:@"%ld",(long)YYUserTypeDesigner]  andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if(rspStatusAndMessage.status == YYReqStatusCode100){
                    [YYToast showToastWithTitle:NSLocalizedString(@"发送成功！",nil) andDuration:kAlertToastDuration];
                }else{
                    [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                }
                
            }];
        }else if (self.emailType == kEmailPasswordType){
            [YYUserApi forgetPassword:[NSString stringWithFormat:@"email=%@",self.email] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                if( rspStatusAndMessage.status == YYReqStatusCode100){
                    [YYToast showToastWithTitle:NSLocalizedString(@"发送成功！",nil) andDuration:kAlertToastDuration];
                }else{
                    [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                }
            }];
        }
    }
    self.sendButton.enabled = NO;
    [self.sendButton setTitleColor:[UIColor colorWithHex:@"919191"] forState:UIControlStateNormal];
    [self.sendButton startWithSecond:60];
    self.sendTimerLabel.text = @"60s";
    self.sendTimerLabel.textColor = [UIColor colorWithHex:@"ef4e31"];
    WeakSelf(ws);
    [self.sendButton didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = NSLocalizedString(@"没收到，再发一封",nil);
        ws.sendTimerLabel.text = [NSString stringWithFormat:@"%ds",second];
        return title;
    }];
    [self.sendButton didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        ws.sendTimerLabel.textColor = [UIColor colorWithHex:@"919191"];
        [ws.sendButton setTitleColor:[UIColor colorWithHex:@"ef4e31"] forState:UIControlStateNormal];
        return NSLocalizedString(@"没收到，再发一封",nil);
        
    }];
}

- (void)submitHandler {
    if (self.submitBlock) {
        [self.sendButton stop];
        self.submitBlock();
    }
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------
@end
