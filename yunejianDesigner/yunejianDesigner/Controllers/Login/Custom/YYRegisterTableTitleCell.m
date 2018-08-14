//
//  YYRegisterTableTitleCell.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYRegisterTableTitleCell.h"

@interface YYRegisterTableTitleCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation YYRegisterTableTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth([UIScreen mainScreen].bounds), 0, 0);
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = _define_black_color;
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(2);
            make.left.mas_equalTo(13);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-13);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.textColor = _define_black_color;
        [self.contentView addSubview:self.titleLabel];
        __weak typeof (self)weakSelf = self;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(7);
            make.bottom.equalTo(weakSelf.lineView.mas_top).with.offset(-12);
            make.right.mas_equalTo(-17);
        }];
    }
    return self;
}

- (void)updateUI {
    self.titleLabel.text = self.title;
}

@end
