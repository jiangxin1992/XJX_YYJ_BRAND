//
//  YYDeliverDoneConfirmStyleInfoCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/7/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYDeliverDoneConfirmStyleInfoCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"

// 接口

// 分类
#import "UIImage+YYImage.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderStyleModel.h"

@interface YYDeliverDoneConfirmStyleInfoCell()

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UIView *styleInfoView;
@property (nonatomic, strong) SCGIFImageView *styleImageView;
@property (nonatomic, strong) UILabel *styleNameLabel;

@property (nonatomic, strong) UIView *sizeTitleView;
@property (nonatomic, strong) UILabel *sizeNameTitleLabel;
@property (nonatomic, strong) UILabel *orderAmountTitleLabel;

@property (nonatomic, strong) UIView *sizeContentView;
@property (nonatomic, strong) NSMutableArray *styleColorArray;

@end

@implementation YYDeliverDoneConfirmStyleInfoCell

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
- (void)PrepareData{
    _styleColorArray = [[NSMutableArray alloc] init];
}
- (void)PrepareUI{
    self.contentView.backgroundColor = _define_white_color;

    _sizeNameTitleLabel = [UILabel getLabelWithAlignment:2 WithTitle:NSLocalizedString(@"尺码",nil) WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];

    _orderAmountTitleLabel = [UILabel getLabelWithAlignment:2 WithTitle:NSLocalizedString(@"修改订单数",nil) WithFont:13.f WithTextColor:nil WithSpacing:0];
    _orderAmountTitleLabel.font = getSemiboldFont(13.f);
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createTitleView];
    [self createStyleInfoView];
    [self createSizeTitleView];
    [self createSizeContentView];
}
-(void)createTitleView{
    _titleView = [UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    _titleView.hidden = YES;

    UIView *titleLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_titleView addSubview:titleLine];
    [titleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    UILabel *titleLabel = [UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"商品改动",nil) WithFont:15.f WithTextColor:nil WithSpacing:0];
    [_titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(titleLine.mas_top).with.offset(0);
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
    }];
    titleLabel.font = getSemiboldFont(15.f);
}
-(void)createStyleInfoView{

    WeakSelf(ws);
    _styleInfoView = [UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:_styleInfoView];
    [_styleInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(105);
    }];

    _styleImageView = [[SCGIFImageView alloc] init];
    [_styleInfoView addSubview:_styleImageView];
    [_styleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.height.width.mas_equalTo(75);
        make.top.mas_equalTo(15);
    }];
    _styleImageView.contentMode = 1;
    setBorderCustom(_styleImageView, 1, [UIColor colorWithHex:@"EFEFEF"]);

    _styleNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:14.f WithTextColor:nil WithSpacing:0];
    [_styleInfoView addSubview:_styleNameLabel];
    [_styleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.styleImageView.mas_right).with.offset(15);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(15);
    }];
    _styleNameLabel.numberOfLines = 2;

}
-(void)createSizeTitleView{

    WeakSelf(ws);

    _sizeTitleView = [UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:_sizeTitleView];
    [_sizeTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.styleInfoView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(46);
    }];

    UIView *upline = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_sizeTitleView addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    UIView *downline = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_sizeTitleView addSubview:downline];
    [downline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];

    NSArray *noteTitleArr = @[@{@"title":NSLocalizedString(@"颜色", nil),@"isright":@(NO),@"length":@(22)}
                              ,@{@"title":NSLocalizedString(@"尺码", nil),@"isright":@(YES),@"length":@(173)}
                              ,@{@"title":NSLocalizedString(@"修改订单数", nil),@"isright":@(YES),@"length":@(25)}
                              ];
    for (int i = 0 ; i < noteTitleArr.count; i++) {
        NSDictionary *titleDict = noteTitleArr[i];
        UILabel *label = nil;
        if(i == 0){
            label = [UILabel getLabelWithAlignment:1 WithTitle:titleDict[@"title"] WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
        }else{
            label = i==1?_sizeNameTitleLabel:_orderAmountTitleLabel;
        }
        [_sizeTitleView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(upline.mas_bottom).with.offset(0);
            make.bottom.mas_equalTo(downline.mas_top).with.offset(0);
            if([titleDict[@"isright"] boolValue]){
                make.right.mas_equalTo(-[titleDict[@"length"] integerValue]);
            }else{
                make.left.mas_equalTo([titleDict[@"length"] integerValue]);
            }
        }];
    }
}
-(void)createSizeContentView{

    WeakSelf(ws);

    _sizeContentView = [UIView getCustomViewWithColor:_define_white_color];
    [self.contentView addSubview:_sizeContentView];
    [_sizeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(ws.sizeTitleView.mas_bottom).with.offset(0);
    }];

}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{
    if(_orderStyleModel){

        WeakSelf(ws);

        _titleView.hidden = !_isFirstCell;
        [_styleInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
            if(ws.isFirstCell){
                make.top.mas_equalTo(46);
            }else{
                make.top.mas_equalTo(0);
            }
        }];

        if(![NSString isNilOrEmpty:_orderStyleModel.albumImg]){
            sd_downloadWebImageWithRelativePath(NO, _orderStyleModel.albumImg, _styleImageView, kNewsCover, 0);
        }else{
            sd_downloadWebImageWithRelativePath(NO, @"", _styleImageView, kNewsCover, 0);
        }

        _styleNameLabel.text = _orderStyleModel.name;

        for (UIView *obj in _styleColorArray) {
            [obj removeFromSuperview];
        }
        [_styleColorArray removeAllObjects];

        UIView *lastStyleColorView = nil;
        for (YYOrderOneColorModel *orderOneColorModel in _orderStyleModel.colors) {

            UIView *styleColorView = [UIView getCustomViewWithColor:_define_white_color];
            [_sizeContentView addSubview:styleColorView];
            CGFloat styleColorHeight = orderOneColorModel.sizes.count*50 + 20;
            [styleColorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                if(lastStyleColorView){
                    make.top.mas_equalTo(lastStyleColorView.mas_bottom).with.offset(0);
                }else{
                    make.top.mas_equalTo(0);
                }
                make.height.mas_equalTo(styleColorHeight);
            }];

            SCGIFImageView *sizeColorImage = [[SCGIFImageView alloc] init];
            [styleColorView addSubview:sizeColorImage];
            [sizeColorImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(22.5);
                make.left.mas_equalTo(17);
                make.height.with.mas_equalTo(25);
            }];
            setBorderCustom(sizeColorImage, 1, [UIColor colorWithHex:@"EFEFEF"]);
            sizeColorImage.contentMode = UIViewContentModeScaleAspectFit;
            [self setSizeColorImage:sizeColorImage colorValue:orderOneColorModel.value];

            UILabel *sizeColorNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:orderOneColorModel.name WithFont:11.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
            [styleColorView addSubview:sizeColorNameLabel];
            [sizeColorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(sizeColorImage);
                make.width.mas_equalTo(75);
                make.left.mas_equalTo(sizeColorImage.mas_right).with.offset(10);
            }];
            sizeColorNameLabel.numberOfLines = 2;


            UIView *lastStyleSizeView = nil;
            for (YYOrderSizeModel *orderSizeModel in orderOneColorModel.sizes) {

                UIView *styleSizeView = [UIView getCustomViewWithColor:_define_white_color];//130
                [styleColorView addSubview:styleSizeView];
                [styleSizeView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(sizeColorNameLabel.mas_right).with.offset(5);
                    make.right.mas_equalTo(0);
                    if(lastStyleSizeView){
                        make.top.mas_equalTo(lastStyleSizeView.mas_bottom).with.offset(0);
                    }else{
                        make.top.mas_equalTo(0);
                    }
                    make.height.mas_equalTo(50);
                }];

                UILabel *sizeNameTitleLabel = [UILabel getLabelWithAlignment:1 WithTitle:orderSizeModel.name WithFont:12.f WithTextColor:nil WithSpacing:0];
                [styleSizeView addSubview:sizeNameTitleLabel];
                [sizeNameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(ws.sizeNameTitleLabel);
                    make.top.mas_equalTo(27);
                }];


                UILabel *orderAmountTitleLabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:13.f WithTextColor:nil WithSpacing:0];
                [styleSizeView addSubview:orderAmountTitleLabel];
                [orderAmountTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(ws.orderAmountTitleLabel);
                    make.top.mas_equalTo(26);
                }];

                NSString *orderAmountTitleStr = [[NSString alloc] initWithFormat:@"%ld → %ld",[orderSizeModel.amount integerValue],[orderSizeModel.received integerValue]];
                NSInteger amountLength = [[orderSizeModel.amount stringValue] length];
                NSMutableAttributedString *tmpstr = [[NSMutableAttributedString alloc]initWithString:orderAmountTitleStr];
                [tmpstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"919191"] range:NSMakeRange(0, amountLength)];
                [tmpstr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, amountLength)];
                orderAmountTitleLabel.attributedText = tmpstr;

                lastStyleSizeView = styleSizeView;
            }

            [_styleColorArray addObject:styleColorView];
            lastStyleColorView = styleColorView;
        }
    }
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------
-(void)setSizeColorImage:(SCGIFImageView *)sizeColorImage colorValue:(NSString *)value{
    if (value) {
        if ([value hasPrefix:@"#"]
            && [value length] == 7) {
            //16进制的色值
            UIColor *color = [UIColor colorWithHex:[value substringFromIndex:1]];
            UIImage *colorImage = [UIImage imageWithColor:color size:CGSizeMake(25, 25)];
            sizeColorImage.image = colorImage;
        }else{
            sd_downloadWebImageWithRelativePath(NO, value, sizeColorImage, kStyleColorImageCover, 0);
        }
    }else{
        UIColor *color = [UIColor clearColor];
        UIImage *colorImage = [UIImage imageWithColor:color size:CGSizeMake(25, 25)];
        sizeColorImage.image = colorImage;
    }
}

#pragma mark - --------------other----------------------


@end
