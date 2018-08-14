//
//  YYPickingListNullCell.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYPickingListNullCell.h"

@implementation YYPickingListNullCell

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
    self.contentView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    UIView *upline = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [self.contentView addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------

#pragma mark - --------------自定义方法----------------------
+(CGFloat)cellHeight{
    return 11.f;
}

#pragma mark - --------------other----------------------


@end
