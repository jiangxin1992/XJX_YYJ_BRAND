//
//  YYShowroomNotificationListCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/3/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYShowroomNotificationListCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYShowroomOrderingModel.h"

@interface YYShowroomNotificationListCell()

@property (nonatomic, strong) SCGIFImageView *orderingImg;
@property (nonatomic, strong) UILabel *orderingNameLabel;
@property (nonatomic, strong) UILabel *orderingStatusLabel;

@property (nonatomic, strong) UILabel *uncheckNumLabel;

@end

@implementation YYShowroomNotificationListCell

#pragma mark - --------------生命周期--------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,NSNumber *orderingID))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _block=block;
        [self SomePrepare];
        [self UIConfig];
    }
    return  self;
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
- (void)PrepareUI{
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{

    UIView *backView = [UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(129);
    }];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 5.f;
    backView.layer.shadowColor = [[UIColor blackColor] CGColor];
    backView.layer.shadowOpacity = 0.1;
    backView.layer.shadowRadius = 5.f;
    backView.layer.shadowOffset = CGSizeMake(1, 1.7);

    UIButton *upView = [UIButton getCustomBtn];
    [backView addSubview:upView];
    [upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(84);
    }];
    [upView addTarget:self action:@selector(upViewTouch) forControlEvents:UIControlEventTouchUpInside];

    UIView *downline = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [upView addSubview:downline];
    [downline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
    }];

    _orderingImg = [[SCGIFImageView alloc] init];
    [upView addSubview:_orderingImg];
    [_orderingImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(63);
        make.width.mas_equalTo(115);
    }];
    _orderingImg.contentMode = UIViewContentModeScaleAspectFit;

    _orderingNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:14.0f WithTextColor:nil WithSpacing:0];
    [upView addSubview:_orderingNameLabel];
    [_orderingNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(_orderingImg.mas_right).with.offset(12.5f);
        make.right.mas_equalTo(-12);
    }];
    _orderingNameLabel.numberOfLines = 2;

    _orderingStatusLabel = [UILabel getLabelWithAlignment:2 WithTitle:nil WithFont:12.0f WithTextColor:nil WithSpacing:0];
    [upView addSubview:_orderingStatusLabel];
    [_orderingStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10.5f);
        make.bottom.mas_equalTo(downline.mas_top).with.offset(-10);
    }];

    UIButton *downView = [UIButton getCustomBtn];
    [backView addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(upView.mas_bottom).with.offset(0);
    }];
    [downView addTarget:self action:@selector(downViewTouch) forControlEvents:UIControlEventTouchUpInside];

    UILabel *checkTitleLabel = [UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"进入审核页", nil) WithFont:13.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [downView addSubview:checkTitleLabel];
    [checkTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.5f);
        make.top.bottom.mas_equalTo(0);
    }];

    UIImageView *rightArrow = [UIImageView getCustomImg];
    [downView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(downView);
        make.width.mas_equalTo(8.5f);
        make.height.mas_equalTo(15.f);
    }];
    rightArrow.contentMode = UIViewContentModeScaleToFill;
    rightArrow.image = [UIImage imageNamed:@"arrow_right"];

    _uncheckNumLabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:11.f WithTextColor:_define_white_color WithSpacing:0];
    [downView addSubview:_uncheckNumLabel];
    [_uncheckNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(downView);
        make.right.mas_equalTo(rightArrow.mas_left).with.offset(-8);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(15);
    }];
    _uncheckNumLabel.backgroundColor = [UIColor colorWithHex:@"EF4E31"];
    _uncheckNumLabel.hidden = YES;
    _uncheckNumLabel.layer.masksToBounds = YES;
    _uncheckNumLabel.layer.cornerRadius = 7.5f;

}

#pragma mark - --------------UpdateUI----------------------
-(void)setLogisticsModel:(YYShowroomOrderingModel *)logisticsModel{
    _logisticsModel = logisticsModel;

    sd_downloadWebImageWithRelativePath(YES, _logisticsModel.poster, _orderingImg, kSeriesCover, UIViewContentModeScaleAspectFit);

    _orderingNameLabel.text = _logisticsModel.name;

    if([_logisticsModel.status isEqualToString:@"ON"]){
        //进行中
        _orderingStatusLabel.text = NSLocalizedString(@"预约开放中", nil);
        _orderingStatusLabel.textColor = [UIColor colorWithHex:@"58C776"];
    }else{
        //已结束
        _orderingStatusLabel.text = NSLocalizedString(@"预约已结束", nil);
        _orderingStatusLabel.textColor = [UIColor colorWithHex:@"919191"];
    }

    NSInteger peopleToBeVerified = [logisticsModel.peopleToBeVerified integerValue];
    if(peopleToBeVerified){
        _uncheckNumLabel.hidden = NO;
        _uncheckNumLabel.text = [[NSString alloc] initWithFormat:@"%ld",(long)peopleToBeVerified];
    }else{
        _uncheckNumLabel.hidden = YES;
    }
}
#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
-(void)upViewTouch{
    //点击此区域进入订货会详情页
    if(_block){
        _block(@"enter_ordering_detail",_logisticsModel.id);
    }
}
-(void)downViewTouch{
    //点击此区域进入审核页
    if(_block){
        _block(@"enter_ordering_checkview",_logisticsModel.id);
    }
}
#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
