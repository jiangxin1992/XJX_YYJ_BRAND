//
//  YYParcelExceptionStyleCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/7/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYParcelExceptionStyleCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"

// 接口

// 分类
#import "UIImage+YYImage.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYParcelExceptionModel.h"

@interface YYParcelExceptionStyleCell()

@property (nonatomic, strong) UIView *styleInfoView;
@property (nonatomic, strong) SCGIFImageView *styleColorImage;
@property (nonatomic, strong) UILabel *styleNameLabel;
@property (nonatomic, strong) UILabel *styleColorCodeLabel;

@property (nonatomic, strong) UIView *styleColorView;
@property (nonatomic, strong) SCGIFImageView *sizeColorImage;
@property (nonatomic, strong) UILabel *sizeColorNameLabel;

@property (nonatomic, strong) UILabel *sizeNameLabel;
@property (nonatomic, strong) UILabel *dlvqtyAmoutLabel;
@property (nonatomic, strong) UILabel *inputAmoutLabel;
@property (nonatomic, strong) UILabel *exceptionAmountLabel;

@property (nonatomic, strong) NSMutableArray *sizeTitleArray;

@end

@implementation YYParcelExceptionStyleCell

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
    _sizeTitleArray = [[NSMutableArray alloc] init];
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

    CGFloat dlvqtyAmoutLength = 0.f;
    if([LanguageManager isEnglishLanguage]){
        if(IsPhone6_gt){
            dlvqtyAmoutLength = 153.f;
        }else{
            dlvqtyAmoutLength = 140.f;
        }
    }else{
        if(IsPhone6_gt){
            dlvqtyAmoutLength = 153.f;
        }else{
            dlvqtyAmoutLength = 133.f;
        }
    }

    CGFloat inputAmoutLength = 0.f;
    if([LanguageManager isEnglishLanguage]){
        if(IsPhone6_gt){
            inputAmoutLength = 106.f;
        }else{
            inputAmoutLength = 96.f;
        }
    }else{
        if(IsPhone6_gt){
            inputAmoutLength = 86.f;
        }else{
            inputAmoutLength = 76.f;
        }
    }

    NSArray *noteTitleArr = @[@{@"title":NSLocalizedString(@"颜色", nil),@"isright":@(NO),@"length":@(22)}
                              ,@{@"title":NSLocalizedString(@"尺码", nil),@"isright":@(YES),@"length":@(IsPhone6_gt?228:195)}
                              ,@{@"title":NSLocalizedString(@"发货数", nil),@"isright":@(YES),@"length":@(dlvqtyAmoutLength)}
                              ,@{@"title":NSLocalizedString(@"入库数", nil),@"isright":@(YES),@"length":@(inputAmoutLength)}
                              ,@{@"title":NSLocalizedString(@"异常", nil),@"isright":@(YES),@"length":@(22)}];
    for (NSDictionary *titleDict in noteTitleArr) {

        UILabel *label = [UILabel getLabelWithAlignment:1 WithTitle:titleDict[@"title"] WithFont:12.f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
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

        [_sizeTitleArray addObject:label];
    }

    _sizeColorImage = [[SCGIFImageView alloc] init];
    [_styleColorView addSubview:_sizeColorImage];
    [_sizeColorImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteLine.mas_bottom).with.offset(22.5);
        make.bottom.mas_equalTo(-22.5);
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

    UILabel *sizeNameTitleLabel = _sizeTitleArray[1];
    _sizeNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:nil WithSpacing:0];
    [_styleColorView addSubview:_sizeNameLabel];
    [_sizeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(sizeNameTitleLabel);
        make.centerY.mas_equalTo(ws.sizeColorImage);
    }];

    UILabel *orderAmoutTitleLabel = _sizeTitleArray[2];
    _dlvqtyAmoutLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:nil WithSpacing:0];
    [_styleColorView addSubview:_dlvqtyAmoutLabel];
    [_dlvqtyAmoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(orderAmoutTitleLabel);
        make.centerY.mas_equalTo(ws.sizeColorImage);
    }];

    UILabel *inputAmoutTitleLabel = _sizeTitleArray[3];
    _inputAmoutLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:12.f WithTextColor:nil WithSpacing:0];
    [_styleColorView addSubview:_inputAmoutLabel];
    [_inputAmoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(inputAmoutTitleLabel);
        make.centerY.mas_equalTo(ws.sizeColorImage);
    }];

    UILabel *exceptionAmountTitleLabel = _sizeTitleArray[4];
    _exceptionAmountLabel = [UILabel getLabelWithAlignment:0 WithTitle:nil WithFont:13.f WithTextColor:nil WithSpacing:0];
    [_styleColorView addSubview:_exceptionAmountLabel];
    [_exceptionAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(exceptionAmountTitleLabel);
        make.centerY.mas_equalTo(ws.sizeColorImage);
    }];

}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    if(_parcelExceptionModel){
        if(![NSString isNilOrEmpty:_parcelExceptionModel.styleImg]){
            sd_downloadWebImageWithRelativePath(NO, _parcelExceptionModel.styleImg, _styleColorImage, kNewsCover, 0);
        }else{
            sd_downloadWebImageWithRelativePath(NO, @"", _styleColorImage, kNewsCover, 0);
        }

        _styleNameLabel.text = _parcelExceptionModel.styleName;

        _styleColorCodeLabel.text = [[NSString alloc] initWithFormat:@"%@%@",NSLocalizedString(@"款号：", nil),_parcelExceptionModel.styleCode];

        //最左边颜色部份
        NSString *colorValue = _parcelExceptionModel.colorValue;
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

        _sizeColorNameLabel.text = _parcelExceptionModel.colorName;
        _sizeNameLabel.text = _parcelExceptionModel.sizeName;
        _dlvqtyAmoutLabel.text = [_parcelExceptionModel.sent stringValue];;
        _inputAmoutLabel.text = [_parcelExceptionModel.received stringValue];

        if([_parcelExceptionModel.amount integerValue]){
            _exceptionAmountLabel.textColor = [UIColor colorWithHex:@"EF4E31"];
        }else{
            _exceptionAmountLabel.textColor = _define_black_color;
        }
        _exceptionAmountLabel.text = [_parcelExceptionModel.amount stringValue];

    }
    
}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
