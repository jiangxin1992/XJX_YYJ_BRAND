//
//  YYPickingListInfoCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYPickingListInfoCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

#import "YYPackingListDetailModel.h"

@interface YYPickingListInfoCell()

@property (nonatomic, strong) UILabel *buyerNameLabel;
@property (nonatomic, strong) UILabel *orderCodeLabel;
@property (nonatomic, strong) UILabel *orderCreateTimeLabel;

@end

@implementation YYPickingListInfoCell

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
    _buyerNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:15.f WithTextColor:_define_black_color WithSpacing:0];
    [self.contentView addSubview:_buyerNameLabel];
    [_buyerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(10);
    }];

    _orderCodeLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self.contentView addSubview:_orderCodeLabel];
    [_orderCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(ws.buyerNameLabel.mas_bottom).with.offset(5);
    }];

    _orderCreateTimeLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self.contentView addSubview:_orderCreateTimeLabel];
    [_orderCreateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(ws.orderCodeLabel.mas_bottom).with.offset(5);
    }];

}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    if(_packingListDetailModel){
        _buyerNameLabel.text = _packingListDetailModel.buyerName;
        _orderCodeLabel.text = [[NSString alloc] initWithFormat:@"%@%@",NSLocalizedString(@"订单号：", nil),_packingListDetailModel.orderCode];
        _orderCreateTimeLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"建单时间：",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd HH:mm:ss",[_packingListDetailModel.orderCreateTime stringValue])];
    }
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------

#pragma mark - --------------自定义方法----------------------
+(CGFloat)cellHeight{
    return 85.f;
}

#pragma mark - --------------other----------------------


@end
