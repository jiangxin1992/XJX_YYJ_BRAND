//
//  YYPickingListStyleCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYPickingListStyleCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"

// 接口

// 分类
#import "UIImage+YYImage.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYPackingListStyleModel.h"

@interface YYPickingListStyleCell()

@property (nonatomic, strong) UIView *styleInfoView;
@property (nonatomic, strong) SCGIFImageView *styleColorImage;
@property (nonatomic, strong) UILabel *styleNameLabel;
@property (nonatomic, strong) UILabel *styleColorCodeLabel;

@property (nonatomic, strong) UIView *styleColorView;
@property (nonatomic, strong) SCGIFImageView *sizeColorImage;
@property (nonatomic, strong) UILabel *sizeColorNameLabel;

@property (nonatomic, strong) NSMutableArray *sizeTitleArray;
@property (nonatomic, strong) NSMutableArray *sizeInfoArray;

@property (nonatomic, assign) YYPickingListStyleType styleType;

@end

@implementation YYPickingListStyleCell

#pragma mark - --------------生命周期--------------
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier styleType:(YYPickingListStyleType)styleType{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _styleType = styleType;
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
    _sizeTitleArray = [[NSMutableArray alloc] init];
    _sizeInfoArray = [[NSMutableArray alloc] init];
}
- (void)PrepareUI{
    self.contentView.backgroundColor = _define_white_color;
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createStyleInfoView];
    [self createStyleColorView];
}
-(void)createStyleInfoView{
    //151
    WeakSelf(ws);

    _styleInfoView = [UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:_styleInfoView];
    [_styleInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(106);
    }];

    _styleColorImage = [[SCGIFImageView alloc] init];
    [_styleInfoView addSubview:_styleColorImage];
    [_styleColorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.height.width.mas_equalTo(75);
        make.top.mas_equalTo(15);
    }];
    _styleColorImage.contentMode = 1;
    setBorderCustom(_styleColorImage, 1, [UIColor colorWithHex:@"EFEFEF"]);

    _styleNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:14.f WithTextColor:_define_black_color WithSpacing:0];
    [_styleInfoView addSubview:_styleNameLabel];
    [_styleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.styleColorImage.mas_right).with.offset(15);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(15);
    }];

    _styleColorCodeLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [_styleInfoView addSubview:_styleColorCodeLabel];
    [_styleColorCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ws.styleColorImage.mas_right).with.offset(15);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(ws.styleNameLabel.mas_bottom).with.offset(3);
    }];

    UIView *styleLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"efefef"]];
    [_styleInfoView addSubview:styleLine];
    [styleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}
-(void)createStyleColorView{

    WeakSelf(ws);

    _styleColorView = [UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:_styleColorView];
    [_styleColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(ws.styleInfoView.mas_bottom).with.offset(0);
    }];

    UIView *noteLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"efefef"]];
    [_styleColorView addSubview:noteLine];
    [noteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(44);
        make.height.mas_equalTo(1);
    }];

    NSArray *noteTitleArr = nil;
    if(_styleType == YYPickingListStyleTypeNormal){
        noteTitleArr = @[@{@"title":NSLocalizedString(@"颜色", nil),@"isright":@(NO),@"length":@(22),@"isblack":@(NO)}
                         ,@{@"title":NSLocalizedString(@"尺码", nil),@"isright":@(YES),@"length":@(173),@"isblack":@(NO)}
                         ,@{@"title":NSLocalizedString(@"本次发货", nil),@"isright":@(YES),@"length":@(22),@"isblack":@(YES)}];
    }else if(_styleType == YYPickingListStyleTypePackage){
        noteTitleArr = @[@{@"title":NSLocalizedString(@"颜色", nil),@"isright":@(NO),@"length":@(22),@"isblack":@(NO)}
                         ,@{@"title":NSLocalizedString(@"尺码", nil),@"isright":@(YES),@"length":@(188),@"isblack":@(NO)}
                         ,@{@"title":NSLocalizedString(@"订单数", nil),@"isright":@(YES),@"length":@(112),@"isblack":@(NO)}
                         ,@{@"title":NSLocalizedString(@"本次发货", nil),@"isright":@(YES),@"length":@(22),@"isblack":@(YES)}];
    }else if(_styleType == YYPickingListStyleTypePackageError){
        CGFloat sizeWidth = 0.f;
        CGFloat sentAmountWidth = 0.f;
        CGFloat receivedAmountWidth = 0.f;
        CGFloat abnormalAmountWidth = 0.f;
        if(IsPhone6_gt){
            if([LanguageManager isEnglishLanguage]){
                sizeWidth = 238.f;
                sentAmountWidth = 159.f;
                receivedAmountWidth = 87.f;
                abnormalAmountWidth = 16.5f;
            }else{
                sizeWidth = 218.f;
                sentAmountWidth = 139.f;
                receivedAmountWidth = 67.f;
                abnormalAmountWidth = 16.5f;
            }
        }else{
            if([LanguageManager isEnglishLanguage]){
                sizeWidth = 182.f;
                sentAmountWidth = 124.f;
                receivedAmountWidth = 66.f;
                abnormalAmountWidth = 7.5f;
            }else{
                sizeWidth = 182.f;
                sentAmountWidth = 119.f;
                receivedAmountWidth = 57.f;
                abnormalAmountWidth = 16.5f;
            }
        }
        noteTitleArr = @[@{@"title":NSLocalizedString(@"颜色", nil),@"isright":@(NO),@"length":@(22),@"isblack":@(NO)}
                         ,@{@"title":NSLocalizedString(@"尺码", nil),@"isright":@(YES),@"length":@(sizeWidth),@"isblack":@(NO)}
                         ,@{@"title":NSLocalizedString(@"本次发货", nil),@"isright":@(YES),@"length":@(sentAmountWidth),@"isblack":@(NO)}
                         ,@{@"title":NSLocalizedString(@"确认收货", nil),@"isright":@(YES),@"length":@(receivedAmountWidth),@"isblack":@(NO)}
                         ,@{@"title":NSLocalizedString(@"异常", nil),@"isright":@(YES),@"length":@(abnormalAmountWidth),@"isblack":@(NO)}
                         ];
    }

    if(![NSArray isNilOrEmpty:noteTitleArr]){
        for (NSDictionary *titleDict in noteTitleArr) {

            UILabel *label = [UILabel getLabelWithAlignment:1 WithTitle:titleDict[@"title"] WithFont:[titleDict[@"isblack"] boolValue]?13.f:12.f WithTextColor:[titleDict[@"isblack"] boolValue]?_define_black_color:[UIColor colorWithHex:@"919191"] WithSpacing:0];
            [_styleColorView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.bottom.mas_equalTo(noteLine.mas_top).with.offset(0);
                if([titleDict[@"isright"] boolValue]){
                    make.right.mas_equalTo(-[titleDict[@"length"] integerValue]);
                }else{
                    make.left.mas_equalTo([titleDict[@"length"] integerValue]);
                }
            }];
            label.font = [titleDict[@"isblack"] boolValue]?getSemiboldFont(13.f):getFont(12.f);
            [_sizeTitleArray addObject:label];
        }
    }

    _sizeColorImage = [[SCGIFImageView alloc] init];
    [_styleColorView addSubview:_sizeColorImage];
    [_sizeColorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteLine.mas_bottom).with.offset(22.5);
        make.left.mas_equalTo(17);
        make.height.with.mas_equalTo(25);
    }];
    setBorderCustom(_sizeColorImage, 1, [UIColor colorWithHex:@"EFEFEF"]);
    _sizeColorImage.contentMode = UIViewContentModeScaleAspectFit;

    _sizeColorNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:11.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [_styleColorView addSubview:_sizeColorNameLabel];
    [_sizeColorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(ws.sizeColorImage);
        make.width.mas_equalTo(50);
        make.left.mas_equalTo(ws.sizeColorImage.mas_right).with.offset(10);
    }];
    _sizeColorNameLabel.numberOfLines = 2;

}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    if(_packingListStyleModel){
        if(![NSString isNilOrEmpty:_packingListStyleModel.color.styleImg]){
            sd_downloadWebImageWithRelativePath(NO, _packingListStyleModel.color.styleImg, _styleColorImage, kNewsCover, 0);
        }else{
            sd_downloadWebImageWithRelativePath(NO, @"", _styleColorImage, kNewsCover, 0);
        }

        _styleNameLabel.text = _packingListStyleModel.styleName;

        _styleColorCodeLabel.text = [[NSString alloc] initWithFormat:@"%@%@",NSLocalizedString(@"款号：", nil),_packingListStyleModel.color.styleCode];

        //最左边颜色部份
        NSString *colorValue = _packingListStyleModel.color.colorValue;
        if (colorValue) {
            if ([colorValue hasPrefix:@"#"]
                && [colorValue length] == 7) {
                //16进制的色值
                UIColor *color = [UIColor colorWithHex:[colorValue substringFromIndex:1]];
                UIImage *colorImage = [UIImage imageWithColor:color size:CGSizeMake(25, 25)];
                _sizeColorImage.image = colorImage;
            }else{
                sd_downloadWebImageWithRelativePath(NO, colorValue, _sizeColorImage, kStyleColorImageCover, 0);
            }
        }else{
            UIColor *color = [UIColor clearColor];
            UIImage *colorImage = [UIImage imageWithColor:color size:CGSizeMake(25, 25)];
            _sizeColorImage.image = colorImage;
        }

        _sizeColorNameLabel.text = _packingListStyleModel.color.colorName;

        for (UIView *obj in _sizeInfoArray) {
            [obj removeFromSuperview];
        }
        [_sizeInfoArray removeAllObjects];

        WeakSelf(ws);

        UIView *lastView = nil;
        for (YYPackingListSizeModel *packingListSizeModel in _packingListStyleModel.color.sizes) {

            UIView *sizeView = [UIView getCustomViewWithColor:nil];
            [_styleColorView addSubview:sizeView];
            [sizeView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50);
                make.right.mas_equalTo(0);
                make.left.mas_equalTo(ws.sizeColorNameLabel.mas_right).with.offset(5);
                if(lastView){
                    make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
                }else{
                    make.top.mas_equalTo(55);
                }
            }];

            UILabel *sizeNameLabel = [UILabel getLabelWithAlignment:1 WithTitle:packingListSizeModel.sizeName WithFont:12.f WithTextColor:nil WithSpacing:0];
            [sizeView addSubview:sizeNameLabel];
            [sizeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(ws.sizeTitleArray[1]);
                make.centerY.mas_equalTo(sizeView);
            }];

            if(_styleType == YYPickingListStyleTypeNormal){
                //本次发货
                UILabel *sentAmountLabel = [UILabel getLabelWithAlignment:1 WithTitle:[packingListSizeModel.sentAmount stringValue] WithFont:13.f WithTextColor:nil WithSpacing:0];
                [sizeView addSubview:sentAmountLabel];
                [sentAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(ws.sizeTitleArray[2]);
                    make.centerY.mas_equalTo(sizeView);
                }];
                sentAmountLabel.font = getSemiboldFont(13.f);
            }else if(_styleType == YYPickingListStyleTypePackage){
                //订单数
                UILabel *orderAmountLabel = [UILabel getLabelWithAlignment:1 WithTitle:[packingListSizeModel.orderAmount stringValue] WithFont:12.f WithTextColor:nil WithSpacing:0];
                [sizeView addSubview:orderAmountLabel];
                [orderAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(ws.sizeTitleArray[2]);
                    make.centerY.mas_equalTo(sizeView);
                }];

                //本次发货
                UILabel *sentAmountLabel = [UILabel getLabelWithAlignment:1 WithTitle:[packingListSizeModel.sentAmount stringValue] WithFont:13.f WithTextColor:nil WithSpacing:0];
                [sizeView addSubview:sentAmountLabel];
                [sentAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(ws.sizeTitleArray[3]);
                    make.centerY.mas_equalTo(sizeView);
                }];
                sentAmountLabel.font = getSemiboldFont(13.f);

            }else if(_styleType == YYPickingListStyleTypePackageError){
                //本次发货
                UILabel *sentAmountLabel = [UILabel getLabelWithAlignment:1 WithTitle:[packingListSizeModel.sentAmount stringValue] WithFont:13.f WithTextColor:nil WithSpacing:0];
                [sizeView addSubview:sentAmountLabel];
                [sentAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(ws.sizeTitleArray[2]);
                    make.centerY.mas_equalTo(sizeView);
                }];

                //确认收货
                UILabel *receivedAmountLabel = [UILabel getLabelWithAlignment:1 WithTitle:[packingListSizeModel.receivedAmount stringValue] WithFont:13.f WithTextColor:nil WithSpacing:0];
                [sizeView addSubview:receivedAmountLabel];
                [receivedAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(ws.sizeTitleArray[3]);
                    make.centerY.mas_equalTo(sizeView);
                }];

                //异常
                UILabel *abnormalAmountLabel = [UILabel getLabelWithAlignment:1 WithTitle:[packingListSizeModel.abnormalAmount stringValue] WithFont:13.f WithTextColor:nil WithSpacing:0];
                [sizeView addSubview:abnormalAmountLabel];
                [abnormalAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(ws.sizeTitleArray[4]);
                    make.centerY.mas_equalTo(sizeView);
                }];
                if([packingListSizeModel.abnormalAmount integerValue]){
                    abnormalAmountLabel.textColor = [UIColor colorWithHex:@"EF4E31"];
                }
            }
            [_sizeInfoArray addObject:sizeView];
            lastView = sizeView;
        }
    }
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
