//
//  YYVerifyBrandTableViewDefaultCell.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYVerifyBrandTableViewDefaultCell.h"

@interface YYVerifyBrandTableViewDefaultCell()

@property (nonatomic, strong) UIView *iconBackgroundView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *typeLabel;

@end

@implementation YYVerifyBrandTableViewDefaultCell

#pragma mark - --------------生命周期--------------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        UIColor *color = [UIColor colorWithHex:@"ED6498"];
        
        self.iconBackgroundView = [[UIView alloc] init];
        self.iconBackgroundView.layer.masksToBounds = YES;
        self.iconBackgroundView.layer.borderWidth = 1;
        self.iconBackgroundView.layer.borderColor = [color CGColor];
        self.iconBackgroundView.layer.cornerRadius = 25;
        [self.contentView addSubview:self.iconBackgroundView];
        [self.iconBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
            make.left.mas_equalTo(17);
            make.centerY.mas_equalTo(0);
        }];
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.iconBackgroundView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(29);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        
        self.typeLabel = [[UILabel alloc] init];
        self.typeLabel.textColor = _define_black_color;
        self.typeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.typeLabel];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(80);
            make.left.mas_equalTo(80);
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        self.accessoryView = accessoryView;
    }
    return self;
}

#pragma mark - --------------SomePrepare--------------

#pragma mark - --------------UIConfig----------------------
-(void)updateCellInfo:(YYTableViewCellInfoModel *)info {    [self.iconImageView setImage:[UIImage imageNamed:info.tipStr]];
    self.typeLabel.text = info.title;
}

#pragma mark - --------------请求数据----------------------

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
