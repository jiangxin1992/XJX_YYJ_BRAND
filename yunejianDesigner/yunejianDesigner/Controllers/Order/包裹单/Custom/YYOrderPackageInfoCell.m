//
//  YYOrderPackageInfoCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/27.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYOrderPackageInfoCell.h"

#import "YYOrderPackageStatModel.h"
#import "UIImage+Tint.h"

@interface YYOrderPackageInfoCell()

@property (nonatomic, strong) UILabel *packageTitleLabel;
@property (nonatomic, strong) UILabel *packageInfoLabel;

@end

@implementation YYOrderPackageInfoCell

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
- (void)PrepareUI{
    self.contentView.backgroundColor = _define_white_color;
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{

    WeakSelf(ws);

    UIButton *deliverRightButton = [UIButton getCustomImgBtnWithImageStr:nil WithSelectedImageStr:nil];
    [self.contentView addSubview:deliverRightButton];
    [deliverRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.mas_equalTo(0);
        make.height.mas_equalTo(61);
    }];
    deliverRightButton.backgroundColor = _define_white_color;
    [deliverRightButton addTarget:self action:@selector(packageAction:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *rightArrow = [[UIImageView alloc] init];
    [deliverRightButton addSubview:rightArrow];
    [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(41);
    }];
    rightArrow.image = [[UIImage imageNamed:@"right_arrow"] imageWithTintColor:[UIColor colorWithHex:@"AFAFAF"]];
    rightArrow.contentMode = UIViewContentModeScaleAspectFit;

    _packageTitleLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:14.f WithTextColor:nil WithSpacing:0];
    [deliverRightButton addSubview:_packageTitleLabel];
    [_packageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(11);
        make.right.mas_equalTo(-41);
    }];

    _packageInfoLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [deliverRightButton addSubview:_packageInfoLabel];
    [_packageInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(ws.packageTitleLabel.mas_bottom).with.offset(3);
        make.right.mas_equalTo(-41);
    }];

    UIView *downView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [self.contentView addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(deliverRightButton.mas_bottom).with.offset(0);
    }];

    UIView *downLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"D3D3D3"]];
    [downView addSubview:downLine];
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    NSInteger totalPackages = [_orderPackageStatModel.totalPackages integerValue];
    NSInteger receivedPackages = [_orderPackageStatModel.receivedPackages integerValue];

    _packageTitleLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"共有 %ld 个包裹",nil),totalPackages];
    _packageInfoLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"在途中（%ld）  已收货（%ld）", nil),totalPackages-receivedPackages,receivedPackages];
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
-(void)packageAction:(UIButton *)sender{
    NSLog(@"packageAction");
    if(_cellClickBlock){
        _cellClickBlock();
    }
}

#pragma mark - --------------自定义方法----------------------
+(CGFloat)cellHeight{
    return 72.f;
}

#pragma mark - --------------other----------------------


@end
