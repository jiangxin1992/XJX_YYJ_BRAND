//
//  YYPackageLogisticsInfoCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYPackageLogisticsInfoCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYPackingListDetailModel.h"

@interface YYPackageLogisticsInfoCell()

@property (nonatomic, strong) UIView *statusView;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *logisticsCodeLabel;
@property (nonatomic, strong) UIButton *checkErrorButton;

@property (nonatomic, strong) UIButton *checkLogisticsInfoButton;
@property (nonatomic, strong) UILabel *logisticsInfoItemLabel;
@property (nonatomic, strong) UILabel *logisticsInfoCreateTimeLabel;

@property (nonatomic, strong) UILabel *logisticsNoInfoItemLabel;

@property (nonatomic,copy) void (^packageLogisticsInfoCellBlock)(NSString *type);

@end

@implementation YYPackageLogisticsInfoCell

#pragma mark - --------------生命周期--------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _packageLogisticsInfoCellBlock = block;
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
- (void)PrepareUI{
    self.contentView.backgroundColor = _define_white_color;
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createStatusView];
    [self createLogisticsInfoView];
    [self createLogisticsNoInfoView];
}

-(void)createStatusView{

    WeakSelf(ws);

    _statusView = [UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:_statusView];
    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];

    UIView *statusLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_statusView addSubview:statusLine];
    [statusLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    CGFloat statusfont = 0.f;
    if((!IsPhone6_gt)&&[LanguageManager isEnglishLanguage]){
        statusfont = 12.f;
    }else{
        statusfont = 15.f;
    }

    _statusLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:statusfont WithTextColor:_define_white_color WithSpacing:0];
    [_statusView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(statusLine.mas_top).with.offset(0);
    }];

    _logisticsCodeLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:nil WithSpacing:0];
    [_statusView addSubview:_logisticsCodeLabel];
    [_logisticsCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.statusLabel.mas_right).with.offset(15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(statusLine.mas_top).with.offset(0);
    }];

    _checkErrorButton = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:IsPhone6_gt?13.f:11.f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"查看异常反馈",nil) WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [_statusView addSubview:_checkErrorButton];
    CGFloat checkErrorButtonWidth = 0.f;
    CGFloat checkErrorButtonRight = 0.f;
    if(!IsPhone6_gt){
        checkErrorButtonWidth = getWidthWithHeight(30, NSLocalizedString(@"查看异常反馈",nil), getFont(11.f))+4.f;
        checkErrorButtonRight = -7;
    }else{
        checkErrorButtonWidth = getWidthWithHeight(30, NSLocalizedString(@"查看异常反馈",nil), getFont(13.f))+14.5f;
        checkErrorButtonRight = -17;
    }
    [_checkErrorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.centerY.mas_equalTo(ws.statusView).with.offset(-0.5);
        make.width.mas_equalTo(checkErrorButtonWidth);
        make.right.mas_equalTo(checkErrorButtonRight);
    }];
    [_checkErrorButton addTarget:self action:@selector(checkErrorAction:) forControlEvents:UIControlEventTouchUpInside];
    _checkErrorButton.backgroundColor = [UIColor colorWithHex:@"EF4E31"];
    _checkErrorButton.layer.masksToBounds = YES;
    _checkErrorButton.layer.cornerRadius = 3.f;
    _checkErrorButton.hidden = YES;

}
-(void)createLogisticsInfoView{

    WeakSelf(ws);

    _checkLogisticsInfoButton = [UIButton getCustomBtn];
    [self.contentView addSubview:_checkLogisticsInfoButton];
    [_checkLogisticsInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.statusView.mas_bottom).with.offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];

    _checkLogisticsInfoButton.backgroundColor = _define_white_color;
    [_checkLogisticsInfoButton addTarget:self action:@selector(checkLogisticsInfoAction:) forControlEvents:UIControlEventTouchUpInside];


    UIImageView *rightArrow = [[UIImageView alloc] init];
    [_checkLogisticsInfoButton addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(41);
    }];
    rightArrow.image = [[UIImage imageNamed:@"right_arrow"] imageWithTintColor:[UIColor colorWithHex:@"AFAFAF"]];
    rightArrow.contentMode = UIViewContentModeScaleAspectFit;

    _logisticsInfoItemLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:nil WithSpacing:0];
    [_checkLogisticsInfoButton addSubview:_logisticsInfoItemLabel];
    [_logisticsInfoItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-35.5f);
        make.top.mas_equalTo(10);
    }];
    _logisticsInfoItemLabel.numberOfLines = 0;

    _logisticsInfoCreateTimeLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [_checkLogisticsInfoButton addSubview:_logisticsInfoCreateTimeLabel];
    [_logisticsInfoCreateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(ws.logisticsInfoItemLabel.mas_bottom).with.offset(5);
        make.bottom.mas_equalTo(-10);
    }];

}

-(void)createLogisticsNoInfoView{

    WeakSelf(ws);

    _logisticsNoInfoItemLabel = [UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"暂未查询到物流信息，请耐心等待。",nil) WithFont:12.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_logisticsNoInfoItemLabel];
    [_logisticsNoInfoItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(ws.statusView.mas_bottom).with.offset(0);
    }];
    _logisticsNoInfoItemLabel.numberOfLines = 2;

}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    if(_packingListDetailModel){

        _statusLabel.hidden = NO;
        if([_packingListDetailModel.status isEqualToString:@"ON_THE_WAY"]){
            //在途中
            _statusLabel.text = NSLocalizedString(@"在途中", nil);
            _statusLabel.textColor = [UIColor colorWithHex:@"58C776"];
        }else if([_packingListDetailModel.status isEqualToString:@"RECEIVED"]){
            //已收货
            _statusLabel.text = NSLocalizedString(@"已收货", nil);
            _statusLabel.textColor = [UIColor colorWithHex:@"ED6498"];
        }else{
            _statusLabel.hidden = YES;
        }

        _logisticsCodeLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@%@%@", nil),_packingListDetailModel.logisticsName,NSLocalizedString(@"：",nil),_packingListDetailModel.logisticsCode];
        _checkErrorButton.hidden = ![_packingListDetailModel.hasException boolValue];

        if([_packingListDetailModel.express.message isEqualToString:@"ok"] && ![NSArray isNilOrEmpty:_packingListDetailModel.express.data]){
            //有物流信息
            _checkLogisticsInfoButton.hidden = NO;
            _logisticsNoInfoItemLabel.hidden = YES;

            YYExpressItemModel *expressItemModel = _packingListDetailModel.express.data[0];
            _logisticsInfoItemLabel.text = expressItemModel.context;

            if(![NSString isNilOrEmpty:expressItemModel.time]){

                NSString *transferTime = [expressItemModel transferTime];
                _logisticsInfoCreateTimeLabel.text = transferTime;

            }else{
                _logisticsInfoCreateTimeLabel.text = @"";
            }

        }else{
            //无物流信息
            _checkLogisticsInfoButton.hidden = YES;
            _logisticsNoInfoItemLabel.hidden = NO;
        }
    }
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
-(void)checkErrorAction:(UIButton *)sender{
    if(_packageLogisticsInfoCellBlock){
        _packageLogisticsInfoCellBlock(@"checkError");
    }
}
-(void)checkLogisticsInfoAction:(UIButton *)sender{
    if(_packageLogisticsInfoCellBlock){
        _packageLogisticsInfoCellBlock(@"checkLogisticsInfo");
    }
}
#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
