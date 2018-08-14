//
//  YYPayLogTableViewCell.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYPayLogTableViewCell.h"

// 自定义视图

// 接口

// 分类
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

@interface YYPayLogTableViewCell()

@property (nonatomic, strong) UILabel *firstTitleLabel;
@property (nonatomic, strong) UILabel *firstContentLabel;
@property (nonatomic, strong) UILabel *secondTitleLabel;
@property (nonatomic, strong) UILabel *secondContentLabel;
@property (nonatomic, strong) UILabel *thirdTitleLabel;
@property (nonatomic, strong) UILabel *thirdContentLabel;
@property (nonatomic, strong) UILabel *fourthTitleLabel;
@property (nonatomic, strong) UILabel *fourthContentLabel;
@property (nonatomic, strong) UILabel *fifthTitleLabel;
@property (nonatomic, strong) UILabel *fifthContentLabel;
@property (nonatomic, strong) UIButton *affirmButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation YYPayLogTableViewCell

#pragma mark - --------------生命周期--------------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth([UIScreen mainScreen].bounds), 0, 0);
        __weak typeof (self)weakSelf = self;
        
        self.firstTitleLabel = [[UILabel alloc] init];
        self.firstTitleLabel.text = NSLocalizedString(@"订单编号", nil);
        self.firstTitleLabel.textColor = [UIColor lightGrayColor];
        self.firstTitleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.firstTitleLabel];
        [self.firstTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(110);
            make.top.mas_equalTo(19);
            make.left.mas_equalTo(17);
        }];
        
        self.firstContentLabel = [[UILabel alloc] init];
        self.firstContentLabel.textColor = [UIColor lightGrayColor];
        self.firstContentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.firstContentLabel];
        [self.firstContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.firstTitleLabel.mas_centerY);
            make.left.equalTo(weakSelf.firstTitleLabel.mas_right).with.offset(0);
            make.right.mas_equalTo(0);
        }];
        
        self.secondTitleLabel = [[UILabel alloc] init];
        self.secondTitleLabel.text = NSLocalizedString(@"交易单号", nil);
        self.secondTitleLabel.textColor = [UIColor lightGrayColor];
        self.secondTitleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.secondTitleLabel];
        [self.secondTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.firstTitleLabel.mas_width);
            make.top.equalTo(weakSelf.firstTitleLabel.mas_bottom).with.offset(11);
            make.left.mas_equalTo(17);
        }];
        
        self.secondContentLabel = [[UILabel alloc] init];
        self.secondContentLabel.textColor = [UIColor lightGrayColor];
        self.secondContentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.secondContentLabel];
        [self.secondContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.secondTitleLabel.mas_centerY);
            make.left.equalTo(weakSelf.secondTitleLabel.mas_right);
            make.right.mas_equalTo(0);
        }];
        
        self.thirdTitleLabel = [[UILabel alloc] init];
        self.thirdTitleLabel.text = NSLocalizedString(@"支付流水号", nil);
        self.thirdTitleLabel.textColor = [UIColor lightGrayColor];
        self.thirdTitleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.thirdTitleLabel];
        [self.thirdTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.firstTitleLabel.mas_width);
            make.top.equalTo(weakSelf.secondTitleLabel.mas_bottom).with.offset(11);
            make.left.mas_equalTo(17);
        }];
        
        self.thirdContentLabel = [[UILabel alloc] init];
        self.thirdContentLabel.textColor = [UIColor lightGrayColor];
        self.thirdContentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.thirdContentLabel];
        [self.thirdContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.thirdTitleLabel.mas_centerY);
            make.left.equalTo(weakSelf.thirdTitleLabel.mas_right);
            make.right.mas_equalTo(0);
        }];
        
        self.fourthTitleLabel = [[UILabel alloc] init];
        self.fourthTitleLabel.text = NSLocalizedString(@"付款时间", nil);
        self.fourthTitleLabel.textColor = [UIColor lightGrayColor];
        self.fourthTitleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.fourthTitleLabel];
        [self.fourthTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.firstTitleLabel.mas_width);
            make.top.equalTo(weakSelf.thirdTitleLabel.mas_bottom).with.offset(11);
            make.left.mas_equalTo(17);
        }];
        
        self.fourthContentLabel = [[UILabel alloc] init];
        self.fourthContentLabel.textColor = [UIColor lightGrayColor];
        self.fourthContentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.fourthContentLabel];
        [self.fourthContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.fourthTitleLabel.mas_centerY);
            make.left.equalTo(weakSelf.fourthTitleLabel.mas_right);
            make.right.mas_equalTo(0);
        }];
        
        self.fifthTitleLabel = [[UILabel alloc] init];
        self.fifthTitleLabel.text = NSLocalizedString(@"到账时间", nil);
        self.fifthTitleLabel.textColor = [UIColor lightGrayColor];
        self.fifthTitleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.fifthTitleLabel];
        [self.fifthTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.firstTitleLabel.mas_width);
            make.top.equalTo(weakSelf.fourthTitleLabel.mas_bottom).with.offset(11);
            make.left.mas_equalTo(17);
        }];
        
        self.fifthContentLabel = [[UILabel alloc] init];
        self.fifthContentLabel.textColor = [UIColor lightGrayColor];
        self.fifthContentLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.fifthContentLabel];
        [self.fifthContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.fifthTitleLabel.mas_centerY);
            make.left.equalTo(weakSelf.fifthTitleLabel.mas_right);
            make.right.mas_equalTo(0);
        }];
        
        self.affirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.affirmButton setTitle:NSLocalizedString(@"确认到账", nil) forState:UIControlStateNormal];
        [self.affirmButton setTitleColor:_define_white_color forState:UIControlStateNormal];
        self.affirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.affirmButton.backgroundColor = _define_black_color;
        self.affirmButton.layer.cornerRadius = 2.5;
        [self.affirmButton addTarget:self action:@selector(affirmRecord) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.affirmButton];
        [self.affirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.top.equalTo(weakSelf.fifthTitleLabel.mas_bottom).with.offset(22);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        self.cancelButton = [UIButton getCustomImgBtnWithImageStr:@"cancel" WithSelectedImageStr:nil];
        [self.cancelButton setTitle:NSLocalizedString(@"作废此条收款记录", nil) forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:_define_black_color forState:UIControlStateNormal];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.cancelButton.layer.borderWidth = 1;
        self.cancelButton.layer.borderColor = _define_black_color.CGColor;
        self.cancelButton.layer.cornerRadius = 2.5;
        [self.cancelButton addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.top.equalTo(weakSelf.affirmButton.mas_bottom).with.offset(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton setTitle:NSLocalizedString(@"删除此条收款记录", nil) forState:UIControlStateNormal];
        [self.deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.deleteButton setImage:[[UIImage imageNamed:@"delete1"] imageWithTintColor:[UIColor colorWithHex:@"ef4e31"]] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(deleteRecord) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.top.equalTo(weakSelf.fifthTitleLabel.mas_bottom).with.offset(22);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
    }
    return self;
}

#pragma mark - --------------SomePrepare--------------

#pragma mark - --------------UIConfig----------------------
-(void)updateCellInfo:(YYPaymentNoteModel *) noteModel{
    [self.firstTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if ([LanguageManager isEnglishLanguage]) {
            make.width.mas_equalTo(150);
        } else {
            make.width.mas_equalTo(95);
        }
    }];
    [super updateConstraints];
    
    self.affirmButton.hidden = YES;
    self.affirmButton.enabled = YES;
    self.affirmButton.backgroundColor = [UIColor blackColor];
    self.cancelButton.hidden = YES;
    self.deleteButton.hidden = YES;
    if( [noteModel.payType integerValue] == 0){
        self.secondTitleLabel.text = NSLocalizedString(@"支付方式",nil);
        self.thirdTitleLabel.text = NSLocalizedString(@"交易单号",nil);
        self.fourthTitleLabel.text = NSLocalizedString(@"添加时间",nil);
        self.fifthTitleLabel.text = NSLocalizedString(@"确认时间",nil);
        if([noteModel.payStatus integerValue] == 0){
            self.affirmButton.hidden = NO;
            if(([noteModel.tmpPercent floatValue] + [noteModel.realPercent floatValue]) >100){
                self.affirmButton.enabled = NO;
                self.affirmButton.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
                
            }
            self.cancelButton.hidden = NO;
            self.fifthContentLabel.text = @"";
        }else if([noteModel.payStatus integerValue] == 2){
            self.deleteButton.hidden = NO;
            self.fifthTitleLabel.text = NSLocalizedString(@"作废时间",nil);
            self.fifthContentLabel.text = getShowDateByFormatAndTimeInterval(@"YYYY-MM-dd HH:mm:ss",[noteModel.modifyTime stringValue]);;
            
        }else{
            self.fifthContentLabel.text = getShowDateByFormatAndTimeInterval(@"YYYY-MM-dd HH:mm:ss",[noteModel.modifyTime stringValue]);
        }
        self.firstContentLabel.text = noteModel.orderCode;
        self.secondContentLabel.text = NSLocalizedString(@"线下支付",nil);
        self.thirdContentLabel.text = noteModel.outTradeNo;
        self.fourthContentLabel.text = getShowDateByFormatAndTimeInterval(@"YYYY-MM-dd HH:mm:ss",[noteModel.createTime stringValue]);
    }else{
        self.secondTitleLabel.text = NSLocalizedString(@"交易单号",nil);
        self.thirdTitleLabel.text = NSLocalizedString(@"支付宝流水号",nil);
        self.fourthTitleLabel.text = NSLocalizedString(@"付款时间",nil);
        self.fifthTitleLabel.text = NSLocalizedString(@"到账时间",nil);
        NSString *payTimer = @"";
        if(noteModel.onlinePayDetail.payTime){
            payTimer = getShowDateByFormatAndTimeInterval(@"YYYY-MM-dd HH:mm:ss",noteModel.onlinePayDetail.payTime);
        }
        NSString *getTimer = @"";
        if(noteModel.onlinePayDetail.accountTime){
            getTimer = getShowDateByFormatAndTimeInterval(@"YYYY-MM-dd HH:mm:ss",noteModel.onlinePayDetail.accountTime);
        }else{
            getTimer = NSLocalizedString(@"请耐心等待2-3个工作日到账",nil);
            self.fifthContentLabel.font =  [UIFont boldSystemFontOfSize:12];
        }
        self.firstContentLabel.text = noteModel.orderCode;
        self.secondContentLabel.text = noteModel.outTradeNo;
        self.thirdContentLabel.text = noteModel.onlinePayDetail.tradeNo;
        self.fourthContentLabel.text = payTimer;
        self.fifthContentLabel.text = getTimer;
    }
    
}

#pragma mark - --------------请求数据----------------------

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (void)affirmRecord {
    if (self.affirmRecordBlock) {
        self.affirmRecordBlock();
    }
}

- (void)cancelRecord {
    if (self.cancelRecordBlock) {
        self.cancelRecordBlock();
    }
}

- (void)deleteRecord {
    if (self.deleteRecordBlock) {
        self.deleteRecordBlock();
    }
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
