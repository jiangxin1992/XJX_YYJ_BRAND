//
//  YYShowroomBrandTabBar.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/13.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomBrandTabBar.h"

#define showroomHomeTabbarHeight 58

@interface YYShowroomBrandTabBar()

@property (nonatomic,strong) NSMutableArray *btnarr;

@end

@implementation YYShowroomBrandTabBar

#pragma mark - init
-(instancetype)initWithSuperView:(UIView *)superView WithBlock:(void(^)(NSInteger type))clickBlock
{
    self = [super init];
    if(self)
    {
        _superView = superView;
        _clickBlock = clickBlock;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{
    _btnarr = [[NSMutableArray alloc] init];
}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    self.backgroundColor=[UIColor whiteColor];
    [_superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-(kIPhoneX?34.f:0.f));
        make.height.mas_equalTo(showroomHomeTabbarHeight);
    }];
    
    
    UIView *upline = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"d3d3d3"]];
    [self addSubview:upline];
    [upline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *backBtn = [UIButton getCustomBtn];
    [self addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(upline.mas_bottom).with.offset(0);
        make.width.mas_equalTo(127);
    }];
    
    UIView *rightLine = [UIView getCustomViewWithColor:_define_black_color];
    [backBtn addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(backBtn);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(2);
    }];
    
    UILabel *backTitleLabel = [UILabel getLabelWithAlignment:1 WithTitle:@"SHOWROOM" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [backBtn addSubview:backTitleLabel];
    backTitleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    [backTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(rightLine.mas_left).with.offset(0);
    }];
    
    
    UIView *lastview = nil;
    for (int i=0; i<2; i++) {
        
        NSString *selectImg = i?@"leftMenuButtonIndex_2_selected":@"leftMenuButtonIndex_1_selected";
        NSString *normalImg = i?@"leftMenuButtonIndex_2_normal":@"leftMenuButtonIndex_1_normal";

        UIButton *btn = [UIButton getCustomBtn];
        [btn setTitle:i?NSLocalizedString(@"订单",nil):NSLocalizedString(@"作品",nil) forState:UIControlStateSelected];
        [btn setTitle:i?NSLocalizedString(@"订单",nil):NSLocalizedString(@"作品",nil) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:@"919191"] forState:UIControlStateNormal];
        [btn setTitleColor:_define_black_color forState:UIControlStateSelected];
        btn.titleLabel.font = getFont(12.0f);

        [self addSubview:btn];
        [btn addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];

        btn.tag = 100+i;
        //锁定第一个视图为默认出现页面
        if (i == 0) {
            btn.selected = YES;
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(upline.mas_bottom).with.offset(0);
            if(!lastview)
            {
                make.left.mas_equalTo(backBtn.mas_right).with.offset(20);
            }else
            {
                make.left.mas_equalTo(lastview.mas_right).with.offset(0);
                make.width.mas_equalTo(lastview);
                make.right.mas_equalTo(-20);
            }
        }];

        // get the size of the elements here for readability
        CGFloat spacing = 0.0;
        CGSize imageSize = btn.imageView.frame.size;
        CGSize titleSize = btn.titleLabel.frame.size;
        // get the height they will take up as a unit
        CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);

        // raise the image and push it right to center it
        btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);

        // lower the text and push it left to center it
        btn.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);

        lastview = btn;
        [_btnarr addObject:btn];
    }
}
#pragma mark - SomeAction
-(void)menuAction:(UIButton *)btn
{
    [_btnarr enumerateObjectsUsingBlock:^(UIButton *_btn, NSUInteger idx, BOOL * _Nonnull stop) {
        _btn.selected = NO;
    }];
    
    btn.selected = YES;
    _clickBlock(btn.tag - 100);
}
-(void)backAction
{
    _clickBlock(-1);
}
@end
