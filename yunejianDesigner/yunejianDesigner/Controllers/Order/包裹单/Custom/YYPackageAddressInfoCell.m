//
//  YYPackageAddressInfoCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYPackageAddressInfoCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYPackingListDetailModel.h"

@interface YYPackageAddressInfoCell()

@property (nonatomic, strong) UILabel *buyerNameLabel;
@property (nonatomic, strong) UILabel *addressInfoLabel;
@property (nonatomic, strong) UILabel *orderCodeLabel;
@property (nonatomic, strong) UILabel *orderCreateTimeLabel;

@end

@implementation YYPackageAddressInfoCell

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

    _buyerNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:15.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_buyerNameLabel];
    [_buyerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(10);
    }];
    _buyerNameLabel.font = getSemiboldFont(15.f);

    _addressInfoLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_addressInfoLabel];
    [_addressInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(ws.buyerNameLabel.mas_bottom).with.offset(5);
    }];
    _addressInfoLabel.numberOfLines = 0;

    _orderCodeLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self.contentView addSubview:_orderCodeLabel];
    [_orderCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(ws.addressInfoLabel.mas_bottom).with.offset(5);
    }];

    _orderCreateTimeLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self.contentView addSubview:_orderCreateTimeLabel];
    [_orderCreateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(ws.orderCodeLabel.mas_bottom).with.offset(5);
        make.bottom.mas_equalTo(-10);
    }];

}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    if(_packingListDetailModel){
        _buyerNameLabel.text = _packingListDetailModel.buyerName;
        _addressInfoLabel.text = [[NSString alloc] initWithFormat:@"%@  %@%@",_packingListDetailModel.receiverAddress,_packingListDetailModel.receiver,_packingListDetailModel.receiverPhone];
        _orderCodeLabel.text = [[NSString alloc] initWithFormat:@"%@%@",NSLocalizedString(@"订单号：",nil),_packingListDetailModel.orderCode];
        _orderCreateTimeLabel.text = [[NSString alloc] initWithFormat:@"%@%@",NSLocalizedString(@"建单时间：",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd HH:mm:ss",[_packingListDetailModel.orderCreateTime stringValue])];
    }
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
