//
//  YYDeliverDoneTotalPriceCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/7/4.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYDeliverDoneTotalPriceCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYStylesAndTotalPriceModel.h"

@interface YYDeliverDoneTotalPriceCell()

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UILabel *totalAmountLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;

@end

@implementation YYDeliverDoneTotalPriceCell

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
    [self createTitleView];
    [self createPriceContentView];
}
-(void)createPriceContentView{

    WeakSelf(ws);

    UIView *priceContentView = [UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:priceContentView];
    [priceContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.titleView.mas_bottom).with.offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];

    _totalAmountLabel = [UILabel getLabelWithAlignment:2 WithTitle:nil WithFont:13.f WithTextColor:nil WithSpacing:0];
    [priceContentView addSubview:_totalAmountLabel];
    [_totalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-17);
        make.left.mas_equalTo(17);
    }];

    _totalPriceLabel = [UILabel getLabelWithAlignment:2 WithTitle:nil WithFont:13.f WithTextColor:nil WithSpacing:0];
    [priceContentView addSubview:_totalPriceLabel];
    [_totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.totalAmountLabel.mas_bottom).with.offset(17);
        make.right.mas_equalTo(-17);
        make.left.mas_equalTo(17);
    }];

    UILabel *tipLabel = [UILabel getLabelWithAlignment:2 WithTitle:NSLocalizedString(@"如果对方有支付款项，请将多余款项退给买手店。",nil) WithFont:13.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [priceContentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws.totalPriceLabel.mas_bottom).with.offset(17);
        make.bottom.mas_equalTo(-20);
        make.right.mas_equalTo(-17);
        make.left.mas_equalTo(17);
    }];
    tipLabel.numberOfLines = 2;
}
-(void)createTitleView{
    _titleView = [UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];

    UIView *titleLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_titleView addSubview:titleLine];
    [titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    UILabel *titleLabel = [UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"订单改动",nil) WithFont:15.f WithTextColor:nil WithSpacing:0];
    [_titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(titleLine.mas_top).with.offset(0);
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
    }];
    titleLabel.font = getSemiboldFont(15.f);
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    //设定 totalAmountLabel 格式 ----> “共计：66 款 130 件 → 66 款 120 件”
    NSString *totalAmountStr = [[NSString alloc] initWithFormat:NSLocalizedString(@"共计：%ld 款 %ld 件 → %ld 款 %ld 件",nil),_stylesAndTotalPriceModel.totalStyles,_stylesAndTotalPriceModel.totalCount,_nowStylesAndTotalPriceModel.totalStyles,_nowStylesAndTotalPriceModel.totalCount];

    NSString *preSignStr = [[NSString alloc] initWithFormat:NSLocalizedString(@"%ld 款 %ld 件",nil),_stylesAndTotalPriceModel.totalStyles,_stylesAndTotalPriceModel.totalCount];
    NSRange totalAmountRange = [totalAmountStr rangeOfString:[[NSString alloc] initWithFormat:@"%@%@",NSLocalizedString(@"：",nil),preSignStr]];

    NSMutableAttributedString *totalAmountAttributedStr = [[NSMutableAttributedString alloc] initWithString:totalAmountStr];

    NSRange realTotalAmountRange = NSMakeRange(totalAmountRange.location + NSLocalizedString(@"：",nil).length, totalAmountRange.length - NSLocalizedString(@"：",nil).length);

    [totalAmountAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"919191"] range:realTotalAmountRange];
    [totalAmountAttributedStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:realTotalAmountRange];

    _totalAmountLabel.attributedText = totalAmountAttributedStr;

    //设定 totalPriceLabel 格式 ----> “总价：￥500,000 → ￥490,000”
    NSString *totalPriceStr = replaceMoneyFlag([[NSString alloc] initWithFormat:NSLocalizedString(@"总价：￥%.2lf → ￥%.2lf",nil),_stylesAndTotalPriceModel.finalTotalPrice,_nowStylesAndTotalPriceModel.finalTotalPrice],[_curType integerValue]);

    NSRange totalPriceRange = [totalPriceStr rangeOfString:@"→"];

    NSMutableAttributedString *totalPriceAttributedStr = [[NSMutableAttributedString alloc] initWithString:totalPriceStr];

    NSInteger berforeTotalPriceLength = replaceMoneyFlag([[NSString alloc] initWithFormat:@"￥%.2lf",_stylesAndTotalPriceModel.finalTotalPrice],[_curType integerValue]).length;
    NSRange berforeTotalPriceRange = NSMakeRange(totalPriceRange.location - 1 - berforeTotalPriceLength,berforeTotalPriceLength);

    [totalPriceAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"919191"] range:berforeTotalPriceRange];
    [totalPriceAttributedStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:berforeTotalPriceRange];

    NSInteger nowTotalPriceLength = replaceMoneyFlag([[NSString alloc] initWithFormat:@"→ ￥%.2lf",_nowStylesAndTotalPriceModel.finalTotalPrice],[_curType integerValue]).length;
    NSRange nowTotalPriceRange = NSMakeRange(totalPriceRange.location,nowTotalPriceLength);

    [totalPriceAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"ED6498"] range:nowTotalPriceRange];

    _totalPriceLabel.attributedText = totalPriceAttributedStr;

}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
