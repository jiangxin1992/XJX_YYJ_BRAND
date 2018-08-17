//
//  YYChooseWarehouseCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYChooseWarehouseCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYWarehouseModel.h"

@interface YYChooseWarehouseCell()

@property (nonatomic, strong) UILabel *WarehouseNameLabel;
@property (nonatomic, strong) UILabel *WarehouseInfoLabel;
@property (nonatomic, strong) UILabel *WarehouseAddressLabel;

@end

@implementation YYChooseWarehouseCell

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

    _WarehouseNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:14.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_WarehouseNameLabel];
    [_WarehouseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(16);
        make.right.mas_equalTo(-17);
    }];
    _WarehouseNameLabel.font = getSemiboldFont(14.f);

    _WarehouseInfoLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_WarehouseInfoLabel];
    [_WarehouseInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(ws.WarehouseNameLabel.mas_bottom).with.offset(5);
        make.right.mas_equalTo(-17);
    }];


    _WarehouseAddressLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_WarehouseAddressLabel];
    [_WarehouseAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(ws.WarehouseInfoLabel.mas_bottom).with.offset(5);
    }];
    _WarehouseAddressLabel.numberOfLines = 0;

    _bottomLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.WarehouseAddressLabel.mas_bottom).with.offset(15);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(15.5);
        make.right.mas_equalTo(-15.5);
        make.bottom.mas_equalTo(0);
    }];

}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    _WarehouseNameLabel.text = _warehouseModel.name;
    _WarehouseInfoLabel.text = [[NSString alloc] initWithFormat:@"%@ %@",_warehouseModel.receiver,_warehouseModel.phone];
    _WarehouseAddressLabel.text = _warehouseModel.address;
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------

#pragma mark - --------------other----------------------


@end
