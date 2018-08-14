//
//  YYRegisterTableInputCell.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYRegisterTableInputCell.h"

// 自定义视图

// 接口

// 分类
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYVerifyTool.h"

@interface YYRegisterTableInputCell()

@property (nonatomic, strong) UILabel *starLabel;
@property (nonatomic, strong) UIButton *iconButton;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UIButton *tipView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *otherLabel;
@property (nonatomic, strong) UIButton *helpButton;

@end

@implementation YYRegisterTableInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth([UIScreen mainScreen].bounds), 0, 0);
        __weak typeof (self)weakSelf = self;
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.mas_equalTo(13);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-13);
        }];
        
        self.starLabel = [[UILabel alloc] init];
        self.starLabel.text = @"*";
        self.starLabel.font = [UIFont systemFontOfSize:15];
        self.starLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.starLabel];
        [self.starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(7);
            make.top.mas_equalTo(17);
            make.left.mas_equalTo(17);
            make.bottom.equalTo(weakSelf.lineView.mas_top).with.offset(-14);
        }];
        
        self.iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.iconButton];
        [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(27);
            make.top.mas_equalTo(0);
            make.left.equalTo(weakSelf.starLabel.mas_right).with.offset(0);
            make.bottom.equalTo(weakSelf.lineView.mas_top).with.offset(0);
        }];
        
        self.tipView = [UIButton getCustomImgBtnWithImageStr:@"warn" WithSelectedImageStr:nil];
        self.tipView.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.tipView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.tipView];
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.left.equalTo(weakSelf.starLabel.mas_right).with.offset(0);
            make.bottom.equalTo(weakSelf.lineView.mas_top).with.offset(0);
        }];
        
        self.inputTextField = [[UITextField alloc] init];
        self.inputTextField.textColor = _define_black_color;
        self.inputTextField.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.inputTextField];
        [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.equalTo(weakSelf.iconButton.mas_right).with.offset(0);
            make.bottom.equalTo(weakSelf.lineView.mas_top).with.offset(0);
            make.right.mas_equalTo(-15);
        }];
        
        self.otherLabel = [[UILabel alloc] init];
        self.otherLabel.textColor = [UIColor lightGrayColor];
        self.otherLabel.font = [UIFont systemFontOfSize:15];
        self.otherLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.otherLabel];
        [self.otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(60);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-15);
        }];
        
        self.helpButton = [UIButton getCustomImgBtnWithImageStr:@"infohelp_icon" WithSelectedImageStr:nil];
        [self.helpButton addTarget:self action:@selector(helpHandler) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.helpButton];
        [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(44);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.inputTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidEndEditingNotification
                                                  object:self.inputTextField];
    _tap = nil;
}

-(void)updateCellInfo:(YYTableViewCellInfoModel *)info {
    if(self.tap == nil){
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.inputTextField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledWillHide:) name:UITextFieldTextDidEndEditingNotification object:self.inputTextField];
        self.tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    }
    
    infoModel = info;
    
    if ([infoModel.propertyKey isEqualToString:@"phone"]) {
        self.inputTextField.userInteractionEnabled = YES;
        [self.helpButton setImage:[UIImage imageNamed:@"infohelp_icon"] forState:UIControlStateNormal];
        [self.helpButton setImage:[UIImage imageNamed:@"infohelp_icon"] forState:UIControlStateHighlighted];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(46);
        }];
        [super updateConstraints];
    } else if ([infoModel.propertyKey isEqualToString:@"countryCode"]) {
        self.inputTextField.userInteractionEnabled = NO;
        [self.helpButton setImage:[UIImage imageNamed:@"down_gray"] forState:UIControlStateNormal];
        [self.helpButton setImage:[UIImage imageNamed:@"down_gray"] forState:UIControlStateHighlighted];
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(46);
        }];
        [super updateConstraints];
    }
    if(self.isMust){
        if(infoModel.ismust){
            self.starLabel.hidden = NO;
        }else{
            self.starLabel.hidden = YES;
        }
    }else{
        self.starLabel.hidden = YES;
    }
    
    UIColor *color = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1];
    if (![NSString isNilOrEmpty:infoModel.title]) {
        self.inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:infoModel.title attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    if([infoModel.tipStr isEqualToString:@""]){
        [self.iconButton hideByWidth:YES];
    }else{
        [self.iconButton hideByWidth:NO];
        [self.iconButton setImage:[UIImage imageNamed:infoModel.tipStr] forState:UIControlStateNormal];
        [self.iconButton setImage:[UIImage imageNamed:infoModel.tipStr] forState:UIControlStateHighlighted];
    }
    
    [self.tipView setTitle:infoModel.warnStr forState:UIControlStateNormal];
    [self setTipBtnHideStatus];
    
    if (infoModel.keyboardType >= 0) {
        self.inputTextField.keyboardType = infoModel.keyboardType;
    }
    self.inputTextField.secureTextEntry = infoModel.secureTextEntry;
    if(![NSString isNilOrEmpty:infoModel.inputTipStr]){
        self.inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:infoModel.inputTipStr attributes:@{NSForegroundColorAttributeName: color}];
    }
    if (![NSString isNilOrEmpty:infoModel.value]) {
        self.inputTextField.text = infoModel.value;
    } else {
        self.inputTextField.text = nil;
    }
    
    if([@[@"userName",@"phone",@"countryCode"] containsObject:infoModel.propertyKey]){
        self.helpButton.hidden = NO;
    }else{
        self.helpButton.hidden = YES;
    }
    if([@[@"annualSales"] containsObject:infoModel.propertyKey]){
        self.otherLabel.hidden = NO;
    }else{
        self.otherLabel.hidden = YES;
    }
}

#pragma mark - --------------自定义响应----------------------
-(void)setTipBtnHideStatus{
    if(self.otherInfo){
        if([infoModel.propertyKey isEqualToString:@"phone"]){
            BOOL isHide = NO;
            YYTableViewCellInfoModel *tempInfoModel = self.otherInfo;
            NSString *phoneCode = getCountryCode(tempInfoModel.value);
            if(![phoneCode isEqualToString:@"++"]){
                if(![NSString isNilOrEmpty:phoneCode]){
                    isHide = [infoModel checkPhoneWarnWithPhoneCode:[phoneCode integerValue]];
                }
            }
            self.tipView.hidden = isHide;
            infoModel.validated = isHide;
        }else{
            self.tipView.hidden = YES;
        }
    }else{
        [self.tipView setHidden:[infoModel checkWarn]];
    }
}

- (void)helpHandler {
    if(self.delegate){
        if([infoModel.propertyKey isEqualToString:@"userName"]){
            [self.delegate selectClick:_indexPath.row AndSection:_indexPath.section andParmas:@[@"helpPanel",@(-2),@(1)]];
        }else if([infoModel.propertyKey isEqualToString:@"phone"]){
            [self.delegate selectClick:_indexPath.row AndSection:_indexPath.section andParmas:@[@"helpPanel",@(-2),@(2)]];
        }
    }
}

- (void)textFiledEditChanged:(NSNotification *)obj{
    infoModel.value = self.inputTextField.text;
    [self.delegate selectClick:_indexPath.row AndSection:_indexPath.section andParmas:@[self.inputTextField.text,@(0)]];
}
    
- (void)textFiledWillHide:(NSNotification *)obj{
    if(infoModel != nil){
        [self setTipBtnHideStatus];
    }
}

#pragma mark - --------------自定义方法----------------------

@end
