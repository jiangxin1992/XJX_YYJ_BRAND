//
//  YYShowroomOrderingCheckCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/3/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYShowroomOrderingCheckCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYShowroomOrderingCheckModel.h"

@interface YYShowroomOrderingCheckCell()

@property (nonatomic, strong) UILabel *applyTimeLabel;//申请时间
@property (nonatomic, strong) UILabel *statusLabel;//申请状态

@property (nonatomic, strong) UILabel *shopNameLabel;//买手店名称
@property (nonatomic, strong) UILabel *contactUserLabel;//预约人
@property (nonatomic, strong) UILabel *contactPhoneLabel;//电话
@property (nonatomic, strong) UILabel *contactEmailLabel;//邮箱
@property (nonatomic, strong) UILabel *selectedDateLabel;//预约时间

@property (nonatomic, strong) UIView *back_line_down;
@property (nonatomic, strong) UIButton *refuseButton;
@property (nonatomic, strong) UIButton *agreeButton;

@end

@implementation YYShowroomOrderingCheckCell

#pragma mark - --------------生命周期--------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,YYShowroomOrderingCheckModel *showroomOrderingCheckModel))block{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _block=block;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    UIView *backView = [UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-11);
    }];

    UIView *downView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [self.contentView addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(backView.mas_bottom).with.offset(0);
    }];

    UIView *line = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"D3D3D3"]];
    [downView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    _applyTimeLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:13.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [backView addSubview:_applyTimeLabel];
    [_applyTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(18);
        make.height.mas_equalTo(40);
    }];


    _statusLabel = [UILabel getLabelWithAlignment:2 WithTitle:nil WithFont:14.f WithTextColor:nil WithSpacing:0];
    [backView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(40);
    }];

    UIView *back_line_up = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [backView addSubview:back_line_up];
    [back_line_up mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(_applyTimeLabel.mas_bottom).with.offset(0);
    }];

    _shopNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:14.f WithTextColor:nil WithSpacing:0];
    [backView addSubview:_shopNameLabel];
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(back_line_up.mas_bottom).with.offset(9.5);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
    }];

    _contactUserLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [backView addSubview:_contactUserLabel];
    [_contactUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopNameLabel.mas_bottom).with.offset(8);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
    }];

    _contactPhoneLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [backView addSubview:_contactPhoneLabel];
    [_contactPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contactUserLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
    }];

    _contactEmailLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [backView addSubview:_contactEmailLabel];
    [_contactEmailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contactPhoneLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
    }];

    _selectedDateLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:nil WithSpacing:0];
    [backView addSubview:_selectedDateLabel];
    [_selectedDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contactEmailLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
    }];

    _back_line_down = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [backView addSubview:_back_line_down];
    [_back_line_down mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(downView.mas_top).with.offset(-50);
    }];
    _back_line_down.hidden = YES;

    _agreeButton = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"通过", nil) WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [backView addSubview:_agreeButton];
    [_agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(downView.mas_top).with.offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-17.f);
    }];
    _agreeButton.backgroundColor = [UIColor colorWithHex:@"58C776"];
    [_agreeButton addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    _agreeButton.layer.masksToBounds = YES;
    _agreeButton.layer.cornerRadius = 2.5f;
    _agreeButton.hidden = YES;


    _refuseButton = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"拒绝", nil) WithNormalColor:nil WithSelectedTitle:nil WithSelectedColor:nil];
    [backView addSubview:_refuseButton];
    [_refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(downView.mas_top).with.offset(-10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(_agreeButton.mas_left).with.offset(-14);
    }];
    [_refuseButton addTarget:self action:@selector(refuseAction) forControlEvents:UIControlEventTouchUpInside];
    _refuseButton.layer.masksToBounds = YES;
    _refuseButton.layer.cornerRadius = 2.5f;
    setBorderCustom(_refuseButton, 1, [UIColor colorWithHex:@"D3D3D3"]);
    _refuseButton.hidden = YES;
}

#pragma mark - --------------UpdateUI----------------------
-(void)setShowroomOrderingCheckModel:(YYShowroomOrderingCheckModel *)showroomOrderingCheckModel{
    _showroomOrderingCheckModel = showroomOrderingCheckModel;

    NSString *timeApply = [NSString stringWithFormat:@"%ld", (long)[_showroomOrderingCheckModel.applyTime timeIntervalSince1970]];
    _applyTimeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"申请时间：%@",nil),getShowDateByFormatAndTimeInterval(@"yyyy.MM.dd",timeApply)];

    _statusLabel.text = [_showroomOrderingCheckModel getStrStatus];

    YYOrderingCheckStatus status = [_showroomOrderingCheckModel getEnumStatus];
    if(status == YYOrderingCheckStatus_TO_BE_VERIFIED){
        //待审核
        _statusLabel.textColor = [UIColor colorWithHex:@"FFB000"];
    }else if(status == YYOrderingCheckStatus_VERIFIED){
        //已通过
        _statusLabel.textColor = [UIColor colorWithHex:@"58C776"];
    }else{
        //其他
        _statusLabel.textColor = [UIColor colorWithHex:@"919191"];
    }

    _shopNameLabel.text = _showroomOrderingCheckModel.shopName;
    _contactUserLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"预约人：%@",nil),_showroomOrderingCheckModel.contactUser];
    _contactPhoneLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"电话：%@",nil),_showroomOrderingCheckModel.contactPhone];
    _contactEmailLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"邮箱：%@",nil),_showroomOrderingCheckModel.contactEmail];

    NSString *timeSubscribe = [NSString stringWithFormat:@"%ld", (long)[_showroomOrderingCheckModel.selectedDate timeIntervalSince1970]];
    _selectedDateLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"预约时间：%@  %@",nil),getShowDateByFormatAndTimeInterval(@"yyyy.MM.dd",timeSubscribe),_showroomOrderingCheckModel.range];

    if(status == YYOrderingCheckStatus_TO_BE_VERIFIED){
        //待审核
        _back_line_down.hidden = NO;
        _refuseButton.hidden = NO;
        _agreeButton.hidden = NO;
    }else{
        //其他
        _back_line_down.hidden = YES;
        _refuseButton.hidden = YES;
        _agreeButton.hidden = YES;
    }
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
- (void)refuseAction{
    if(_block){
        _block(@"refuse",_showroomOrderingCheckModel);
    }
}
- (void)agreeAction{
    if(_block){
        _block(@"agree",_showroomOrderingCheckModel);
    }
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
