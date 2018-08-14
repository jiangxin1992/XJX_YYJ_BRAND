//
//  YYShareInfoView.m
//  Yunejian
//
//  Created by yyj on 2017/4/17.
//  Copyright © 2017年 yyj. All rights reserved.
//

#import "YYShareInfoView.h"

#import "YYVerifyTool.h"
#import "regular.h"
#import "MLInputDodger.h"


#define blackBackViewSeriesHeight 400
#define  blackBackViewOrderHeight 185

@interface YYShareInfoView()<UITextFieldDelegate>

@property (nonatomic,strong) NSMutableArray *contactArr;

@end

@implementation YYShareInfoView{
    UIView *mainBackView;
}
#pragma mark - --------------生命周期--------------
-(instancetype)initWithShareViewType:(EShareViewType )shareViewType
{
    self = [super init];
    if (self) {
        _shareViewType = shareViewType;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidEndEditingNotification
                                                  object:_emailTextField];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{
    if(_shareViewType == EShareViewSeries){
        _contactArr = [[NSMutableArray alloc] init];
    }
}
-(void)PrepareUI{
    self.userInteractionEnabled = YES;
    self.backgroundColor =[_define_black_color colorWithAlphaComponent:0.3];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)]];

    self.shiftHeightAsDodgeViewForMLInputDodger = 90;
    [self registerAsDodgeViewForMLInputDodger];
}
#pragma mark - UIConfig
-(void)UIConfig{
    [self MainViewConfig];
    if(_shareViewType == EShareViewSeries){
        [self ContactViewConfig];
    }
}
-(void)MainViewConfig{
    UIView *blackBackView = [UIView getCustomViewWithColor:_define_black_color];
    [self addSubview:blackBackView];
    [blackBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH-50);
        if(_shareViewType == EShareViewSeries){
            make.height.mas_equalTo(blackBackViewSeriesHeight);
        }else{
            make.height.mas_equalTo(blackBackViewOrderHeight);
        }
    }];
    [blackBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyborad)]];

    mainBackView = [UIView getCustomViewWithColor:_define_white_color];
    [blackBackView addSubview:mainBackView];
    [mainBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(4);
        make.bottom.right.mas_equalTo(-4);
    }];


    NSString *shareTitle = nil;
    if(_shareViewType == EShareViewSeries){
        shareTitle = NSLocalizedString(@"分享系列",nil);
    }else{
        shareTitle = NSLocalizedString(@"分享订单",nil);
    }
    UILabel *titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:shareTitle WithFont:15.0f WithTextColor:nil WithSpacing:0];

    [mainBackView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(mainBackView);
        make.top.mas_equalTo(19);
    }];

    UIView *emailBackView = [UIView getCustomViewWithColor:nil];
    [mainBackView addSubview:emailBackView];
    [emailBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(12);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(40);
    }];
    emailBackView.layer.masksToBounds = YES;
    emailBackView.layer.borderWidth = 1;
    emailBackView.layer.borderColor = [[UIColor colorWithHex:@"d3d3d3"] CGColor];

    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 40)];
    [emailBackView addSubview:leftView];
    UIImageView *emailImg = [UIImageView  getImgWithImageStr:@"email_icon1"];
    [leftView addSubview:emailImg];
    emailImg.frame = CGRectMake(10, 15, 14, 10);


    _emailTextField = [[UITextField alloc] init];
    [emailBackView addSubview:_emailTextField];
    _emailTextField.returnKeyType = UIReturnKeySend;
    _emailTextField.delegate = self;
    _emailTextField.font = getFont(14.0f);
    _emailTextField.textColor = _define_black_color;
    _emailTextField.textAlignment=0;
    [_emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.top.bottom.mas_equalTo(0);
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledWillHide:) name:UITextFieldTextDidEndEditingNotification object:_emailTextField];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:_emailTextField];

    _emailTipButton = [UIButton getCustomTitleBtnWithAlignment:1 WithFont:12.0f WithSpacing:0 WithNormalTitle:[[NSString alloc] initWithFormat:@"  %@",NSLocalizedString(@"邮箱格式不对！",nil)] WithNormalColor:[UIColor colorWithHex:@"ef4e31"] WithSelectedTitle:nil WithSelectedColor:nil];
    [mainBackView addSubview:_emailTipButton];
    [_emailTipButton setImage:[UIImage imageNamed:@"warn"] forState:UIControlStateNormal];
    [_emailTipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.top.mas_equalTo(_emailTextField.mas_bottom).with.offset(0);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(200);
    }];
    _emailTipButton.hidden = YES;

    UIButton *sendButton = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.0f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"确认发送",nil) WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [mainBackView addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_equalTo(40);
    }];
    sendButton.backgroundColor = _define_black_color;
    [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
}
-(void)ContactViewConfig{
    UILabel *tipLabel = [UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"商务联系方式将与系列款式、款式大片一起分享给对方。",nil) WithFont:12.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [mainBackView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
        make.top.mas_equalTo(_emailTipButton.mas_bottom).with.offset(0);
    }];
    tipLabel.numberOfLines = 2;

    UIView *contactView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"f8f8f8"]];
    [mainBackView addSubview:contactView];
    [contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.top.mas_equalTo(tipLabel.mas_bottom).with.offset(8);
        make.height.mas_equalTo(162);
    }];

    UILabel *contactTitle = [UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"商务联系方式",nil) WithFont:13.0f WithTextColor:nil WithSpacing:0];
    [contactView addSubview:contactTitle];
    [contactTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(8);
        make.height.mas_equalTo(16);
    }];


    UIButton *editButton = [UIButton getCustomImgBtnWithImageStr:@"modfiy_icon" WithSelectedImageStr:nil];
    [contactView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(contactTitle);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [editButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];

    CGFloat jiangge = (162-15*5-16-8)/6.0f;
    UIView *lastView = nil;
    for (int i=0; i<5; i++) {

        NSString *imageStr = i==0?@"email_icon2":i==1?@"phone_icon1":i==2?@"mobile_icon":i==3?@"weixin_icon1":@"qq_icon1";

        UILabel *label = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.0f WithTextColor:nil WithSpacing:0];
        [contactView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(39);
            make.height.mas_equalTo(15);
            if(!lastView){
                make.top.mas_equalTo(contactTitle.mas_bottom).with.offset(jiangge);
            }else{
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(jiangge);
            }
            make.right.mas_equalTo(-5);
        }];

        UIImageView *iconImg = [UIImageView getImgWithImageStr:imageStr];
        [contactView addSubview:iconImg];
        [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(label);
            make.left.mas_equalTo(10);
            make.width.height.mas_equalTo(14);
        }];
        
        [_contactArr addObject:label];
        lastView = label;
    }
}
#pragma mark - Setter
-(void)setHomePageModel:(YYBrandHomeInfoModel *)homePageModel{
    _homePageModel = homePageModel;

    //0 邮箱, 4 固定电话 1 电话, 3 微信号, 2 QQ,
    //    NSInteger idx=contactType==0?0:contactType==1?2:contactType==2?3:contactType==3?4:contactType==4?2:-1;
    BOOL _haveVaule = NO;
    if(_homePageModel.userContactInfos){
        if(_homePageModel.userContactInfos.count){
            _haveVaule = YES;
        }
    }

    if(_contactArr){
        if(_contactArr.count){
            for (int i=0; i<_contactArr.count; i++) {
                UILabel *label = _contactArr[i];
                label.textColor = [UIColor colorWithHex:@"919191"];
                label.text = NSLocalizedString(@"暂无",nil);
            }
        }
    }

    if(_haveVaule){
        for (int i=0; i<_homePageModel.userContactInfos.count; i++) {
            YYBuyerContactInfoModel *obj = [_homePageModel.userContactInfos objectAtIndex:i];
            if(![self isNilOrEmptyWithContactValue:obj.contactValue WithContactType:obj.contactType]){
                NSInteger number = [obj.contactType integerValue];
                NSInteger index = number==0?0:number==4?1:number==1?2:number==3?3:number==2?4:-1;
                if(index>=0&&index<_contactArr.count){
                    UILabel *label = [_contactArr objectAtIndex:index];
                    label.textColor = _define_black_color;
                    label.text = obj.contactValue;
                }
            }
        }
    }
    
}
#pragma mark - --------------自定义响应----------------------
-(void)closeAction{
    //关闭
    if(_shareViewBlock){
        _emailTextField.text = @"";
        _emailTipButton.hidden = YES;
        _shareViewBlock(@"hide");
    }
}
-(void)sendAction{
    if([NSString isNilOrEmpty:_emailTextField.text]){
        //空
        _emailTipButton.hidden = NO;
        [_emailTipButton setTitle:[[NSString alloc] initWithFormat:@"  %@",NSLocalizedString(@"请输入邮箱！",nil)] forState:UIControlStateNormal];
    }else{
        if([YYVerifyTool emailVerify:_emailTextField.text]){
            //通过验证
            if(_shareViewBlock){
                _shareViewBlock(@"send");
            }
        }else{
            //格式不对
            _emailTipButton.hidden = NO;
            [_emailTipButton setTitle:[[NSString alloc] initWithFormat:@"  %@",NSLocalizedString(@"邮箱格式不对！",nil)] forState:UIControlStateNormal];
        }
    }
}
-(void)editAction{
    if(_shareViewBlock){
        _shareViewBlock(@"edit");
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self sendAction];
    return YES;
}
-(void)textFiledWillHide:(NSNotification *)obj{
    if([NSString isNilOrEmpty:_emailTextField.text]){
        _emailTipButton.hidden = YES;
    }else{
        if([YYVerifyTool emailVerify:_emailTextField.text]){
            _emailTipButton.hidden = YES;
        }else{
            _emailTipButton.hidden = NO;
            [_emailTipButton setTitle:[[NSString alloc] initWithFormat:@"  %@",NSLocalizedString(@"邮箱格式不对！",nil)] forState:UIControlStateNormal];
        }
    }
}

-(void)textFiledBeginEditing:(NSNotification *)obj{
    _emailTipButton.hidden = YES;
}
#pragma mark - --------------自定义方法----------------------

-(BOOL)isNilOrEmptyWithContactValue:(NSString *)contactValue WithContactType:(NSNumber *)contactType
{
    if([NSString isNilOrEmpty:contactValue])
    {
        return YES;
    }else
    {
        if([contactType integerValue] == 1)
        {
            //移动电话
            NSArray *teleArr = [contactValue componentsSeparatedByString:@" "];
            if(teleArr.count>1)
            {
                if(![NSString isNilOrEmpty:teleArr[1]])
                {
                    return NO;
                }else
                {
                    return YES;
                }
            }
            return YES;
        }else if([contactType integerValue] == 4)
        {
            //固定电话
            NSArray *tempphoneArr = [contactValue componentsSeparatedByString:@" "];
            if(tempphoneArr.count>1)
            {
                if(![NSString isNilOrEmpty:tempphoneArr[1]])
                {
                    NSArray *phoneArr = [tempphoneArr[1] componentsSeparatedByString:@"-"];
                    NSString *vauleStr = [phoneArr componentsJoinedByString:@""];
                    if(![NSString isNilOrEmpty:vauleStr])
                    {
                        return NO;
                    }
                    return YES;
                }else
                {
                    return YES;
                }
            }
            return YES;
        }
        return NO;
    }
}
-(void)hideKeyborad{
    [regular dismissKeyborad];
}

@end
