//
//  YYDeliverAddressInfoCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYDeliverAddressInfoCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYDeliverModel.h"

@interface YYDeliverAddressInfoCell()

@property (nonatomic, strong) UILabel *receiverLabel;
@property (nonatomic, strong) UILabel *receiverPhoneLabel;
@property (nonatomic, strong) UILabel *receiverAddressLabel;

@end

@implementation YYDeliverAddressInfoCell

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

    _receiverPhoneLabel = [UILabel getLabelWithAlignment:2 WithTitle:nil WithFont:14.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_receiverPhoneLabel];
    [_receiverPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.right.mas_equalTo(-41);
        make.top.mas_equalTo(15);
    }];
    _receiverPhoneLabel.font = getSemiboldFont(14.f);

    _receiverLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:14.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_receiverLabel];
    [_receiverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(ws.receiverPhoneLabel.mas_left).with.offset(0);
        make.top.mas_equalTo(15);
    }];
    _receiverLabel.font = getSemiboldFont(14.f);

    _receiverAddressLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_receiverAddressLabel];
    [_receiverAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-41);
        make.top.mas_equalTo(ws.receiverLabel.mas_bottom).with.offset(7);
    }];
    _receiverAddressLabel.numberOfLines = 0;

    UIView *bottomLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(15.5);
        make.right.mas_equalTo(-15.5);
        make.top.mas_equalTo(ws.receiverAddressLabel.mas_bottom).with.offset(15);
    }];

    UIButton *deliverRightButton = [UIButton getCustomImgBtnWithImageStr:nil WithSelectedImageStr:nil];
    [self.contentView addSubview:deliverRightButton];
    [deliverRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(bottomLine.mas_top).with.offset(0);
        make.left.mas_equalTo(ws.receiverAddressLabel.mas_right).with.offset(0);
        make.width.mas_equalTo(41);
    }];
    UIImage *deliverRightImg = [[UIImage imageNamed:@"right_arrow"] imageWithTintColor:[UIColor colorWithHex:@"AFAFAF"]];
    [deliverRightButton setImage:deliverRightImg forState:UIControlStateNormal];
    deliverRightButton.userInteractionEnabled = NO;

}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    _receiverLabel.text = _deliverModel.receiver;
    _receiverPhoneLabel.text = _deliverModel.receiverPhone;
    _receiverAddressLabel.text = _deliverModel.receiverAddress;
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
