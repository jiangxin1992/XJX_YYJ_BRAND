//
//  YYPackageListCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYPackageListCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYPackageModel.h"

@interface YYPackageListCell()

@property (nonatomic, strong) UILabel *packageNameLabel;
@property (nonatomic, strong) UILabel *logisticsInfoLabel;
@property (nonatomic, strong) UILabel *packageStatusLabel;
@property (nonatomic, strong) UIButton *errorButton;

@end

@implementation YYPackageListCell

#pragma mark - --------------生命周期--------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
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

    WeakSelf(ws);

    UIView *downLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [self.contentView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(15.5);
        make.right.mas_equalTo(-15.5);
    }];

    UIImageView *rightArrow = [[UIImageView alloc] init];
    [self.contentView addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.width.mas_equalTo(41);
        make.bottom.mas_equalTo(downLine.mas_top).with.offset(0);
    }];
    rightArrow.image = [[UIImage imageNamed:@"right_arrow"] imageWithTintColor:[UIColor colorWithHex:@"AFAFAF"]];
    rightArrow.contentMode = UIViewContentModeScaleAspectFit;

    _packageNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:14.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_packageNameLabel];
    [_packageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(7);
        make.right.mas_equalTo(-100);
    }];

    _logisticsInfoLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self.contentView addSubview:_logisticsInfoLabel];
    [_logisticsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.bottom.mas_equalTo(downLine.mas_top).with.offset(-7.5);
        make.right.mas_equalTo(-100);
    }];

    _packageStatusLabel = [UILabel getLabelWithAlignment:2 WithTitle:nil WithFont:13.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self.contentView addSubview:_packageStatusLabel];
    [_packageStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(downLine.mas_top).with.offset(0);
        make.right.mas_equalTo(-35.5);
    }];

    _errorButton = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:12.f WithSpacing:0 WithNormalTitle:NSLocalizedString(@"存在异常",nil) WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [self.contentView addSubview:_errorButton];
    CGFloat errorButtonWidth = getWidthWithHeight(30, NSLocalizedString(@"存在异常",nil), getFont(12.f))+13.f;
    [_errorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(ws.packageStatusLabel.mas_left).with.offset(-15);
        make.centerY.mas_equalTo(ws.contentView).with.offset(-0.5);
        make.width.mas_equalTo(errorButtonWidth);
        make.height.mas_equalTo(20);
    }];
    _errorButton.userInteractionEnabled = NO;
    _errorButton.backgroundColor = [UIColor colorWithHex:@"EF4E31"];
    _errorButton.layer.masksToBounds = YES;
    _errorButton.layer.cornerRadius = 10.f;
    _errorButton.hidden = YES;
}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    _packageNameLabel.text = _packageName;
    _logisticsInfoLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@%@%@", nil),_packageModel.logisticsName,NSLocalizedString(@"：",nil),_packageModel.logisticsCode];
    if([_packageModel.status isEqualToString:@"ON_THE_WAY"]){
        // 在途中
        _packageStatusLabel.text = NSLocalizedString(@"在途中",nil);
        _packageStatusLabel.textColor = [UIColor colorWithHex:@"58C776"];
    }else if([_packageModel.status isEqualToString:@"RECEIVED"]){
        // 已收货
        _packageStatusLabel.text = NSLocalizedString(@"已收货",nil);
        _packageStatusLabel.textColor = [UIColor colorWithHex:@"919191"];
    }else{
        _packageStatusLabel.text = @"";
    }
    _errorButton.hidden = ![_packageModel.hasException boolValue];
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
