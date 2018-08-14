//
//  YYStockMessageCell.m
//  yunejianDesigner
//
//  Created by Victor on 2018/2/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "YYStockMessageCell.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "SCGIFImageView.h"

@interface YYStockMessageCell()

@property (nonatomic, strong) UIView *topBackgroundView;
@property (nonatomic, strong) UIView *bottomBackgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) SCGIFImageView *logoImageView;
@property (nonatomic, strong) UIView *readFlagView;
@property (nonatomic, strong) UILabel *styleNameLabel;
@property (nonatomic, strong) UILabel *styleCodeLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
//@property (nonatomic, strong) UILabel *stocksLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation YYStockMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth([UIScreen mainScreen].bounds), 0, 0);
        __weak typeof (self)weakSelf = self;
        
        self.topBackgroundView = [[UIView alloc] init];
        self.topBackgroundView.backgroundColor = _define_white_color;
        [self.contentView addSubview:self.topBackgroundView];
        [self.topBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = NSLocalizedString(@"以下款式已无法被下单，请及时调整库存", nil);
        self.titleLabel.textColor = _define_black_color;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.topBackgroundView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(17);
        }];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.text = @"今天 10:01";
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:12];
        [self.topBackgroundView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.titleLabel.mas_centerY);
            make.right.mas_equalTo(-17);
        }];
        
        self.bottomBackgroundView = [[UIView alloc] init];
        self.bottomBackgroundView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
        [self.contentView addSubview:self.bottomBackgroundView];
        [self.bottomBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.topBackgroundView.mas_bottom).with.offset(2);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        self.logoImageView = [[SCGIFImageView alloc] init];
        self.logoImageView.backgroundColor = _define_white_color;
        [self.bottomBackgroundView addSubview:self.logoImageView];
        [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(55);
            make.centerY.mas_equalTo(0);
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(17);
        }];
        
        CGFloat readFlagWidth = 12;
        CGFloat readFlagHeight = 12;
        self.readFlagView = [[UIView alloc] init];
        self.readFlagView.backgroundColor = [UIColor redColor];
        self.readFlagView.layer.cornerRadius = readFlagWidth / 2;
        self.readFlagView.layer.masksToBounds = YES;
        [self.bottomBackgroundView addSubview:self.readFlagView];
        [self.readFlagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(readFlagWidth);
            make.height.mas_equalTo(readFlagHeight);
            make.top.equalTo(weakSelf.logoImageView.mas_top).with.offset(-readFlagHeight / 2);
            make.right.equalTo(weakSelf.logoImageView.mas_right).with.offset(readFlagWidth / 2);
        }];
        
        self.styleNameLabel = [[UILabel alloc] init];
        self.styleNameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"款式名称：%@", nil), @"秋冬女款"];
        self.styleNameLabel.textColor = [UIColor lightGrayColor];
        self.styleNameLabel.font = [UIFont systemFontOfSize:12];
        [self.bottomBackgroundView addSubview:self.styleNameLabel];
        [self.styleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.logoImageView.mas_top);
            make.left.equalTo(weakSelf.logoImageView.mas_right).with.offset(13);
        }];
        
        self.styleCodeLabel = [[UILabel alloc] init];
        self.styleCodeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"款式编号：%@", nil), @"1451413"];
        self.styleCodeLabel.textColor = [UIColor lightGrayColor];
        self.styleCodeLabel.font = [UIFont systemFontOfSize:12];
        [self.bottomBackgroundView addSubview:self.styleCodeLabel];
        [self.styleCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.equalTo(weakSelf.styleNameLabel.mas_left);
        }];
        
        self.sizeLabel = [[UILabel alloc] init];
        self.sizeLabel.text = @"";
        self.sizeLabel.textColor = [UIColor lightGrayColor];
        self.sizeLabel.font = [UIFont systemFontOfSize:12];
        [self.bottomBackgroundView addSubview:self.sizeLabel];
        [self.sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.logoImageView.mas_bottom);
            make.left.equalTo(weakSelf.styleNameLabel.mas_left);
        }];
        
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.text = NSLocalizedString(@"查看详情>", nil);
        self.detailLabel.textColor = [UIColor colorWithRed:71/255.0 green:163/255.0 blue:220/255.0 alpha:1];
        self.detailLabel.font = [UIFont systemFontOfSize:12];
        [self.bottomBackgroundView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.sizeLabel.mas_centerY);
            make.right.mas_equalTo(-17);
        }];
    }
    return self;
}

- (void)updateUIWithModel:(YYSkuMessageModel *)model {
    if (![NSString isNilOrEmpty:model.styleImg]) {
        sd_downloadWebImageWithRelativePath(YES, model.styleImg, self.logoImageView, kStyleCover, 0);
    }
    if (![NSString isNilOrEmpty:model.styleName]) {
        self.styleNameLabel.text = [NSString stringWithFormat:NSLocalizedString(@"款式名称：%@", nil), model.styleName];
    }
    if (![NSString isNilOrEmpty:model.styleCode]) {
        self.styleCodeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"款式编号：%@", nil), model.styleCode];
    }
    self.timeLabel.text = getTimeStr([model.created integerValue] / 1000, @"M/d H:m");
    self.readFlagView.hidden = [model.hasRead boolValue];
}

@end
