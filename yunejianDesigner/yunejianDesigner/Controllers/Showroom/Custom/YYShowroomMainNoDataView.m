//
//  YYShowroomMainNoDataView.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/11.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomMainNoDataView.h"

#import "TTTAttributedLabel.h"

@interface YYShowroomMainNoDataView()<TTTAttributedLabelDelegate>

@end

@implementation YYShowroomMainNoDataView

#pragma mark - 初始化
-(instancetype)initWithSuperView:(UIView *)superView Block:(void(^)(NSString *type))block
{
    self = [super init];
    if(self)
    {
        _block = block;
        _superView = superView;
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
-(instancetype)initNoDataSearchWithSuperView:(UIView *)superView{
    self = [super init];
    if(self)
    {
        _superView = superView;
        [self SomePrepare];
        [self UIConfigSearchView];
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{}
-(void)PrepareUI{}
#pragma mark - UIConfig
-(void)UIConfig
{
    [_superView addSubview:self];
    CGFloat offset_y = ((324.0f/750.0f)*SCREEN_WIDTH-40)/2.0f;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_superView);
        make.centerY.mas_equalTo(_superView).with.offset(offset_y);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIImageView *imageView = [UIImageView getImgWithImageStr:@"showroom_nodata_icon"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(122);
        make.centerX.mas_equalTo(self);
    }];
    
    UILabel *titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:NSLocalizedString(@"暂无代理品牌",nil) WithFont:14.0f WithTextColor:nil WithSpacing:0];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom).with.offset(30);
    }];
    
    TTTAttributedLabel *contentLabel =[[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).with.offset(48);
        make.centerX.mas_equalTo(titleLabel);
        make.width.mas_equalTo(240);
        make.bottom.mas_equalTo(0);
    }];
    contentLabel.textAlignment = 0;
    contentLabel.font = getFont(13.0f);
    contentLabel.textColor = [UIColor colorWithHex:@"919191"];
    contentLabel.linkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:@"919191"]};
    contentLabel.activeLinkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:@"919191"]};
    contentLabel.inactiveLinkAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHex:@"919191"]};
    contentLabel.numberOfLines = 0;
    contentLabel.delegate = self;
    contentLabel.lineSpacing = 6;
    contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    NSString *contnent = NSLocalizedString(@"您可以：\n1.联系 YCO小助手 为您添加代理品牌\n2.若已申请，请耐心等待品牌方同意代理",nil);
    [contentLabel setText:contnent afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = [[mutableAttributedString string] rangeOfString:NSLocalizedString(@"YCO小助手",nil) options:NSCaseInsensitiveSearch];
        [mutableAttributedString addAttribute:NSUnderlineStyleAttributeName
                                        value:[NSNumber numberWithInt:1]
                                        range:range];
        [mutableAttributedString addAttribute:NSUnderlineColorAttributeName
                                        value:[UIColor colorWithHex:@"919191"]
                                        range:range];
        return mutableAttributedString;
    }];

    NSURL *url = [NSURL fileURLWithPath:@""];
    [contentLabel addLinkToURL:url withRange:[contnent rangeOfString:NSLocalizedString(@"YCO小助手",nil)]];
}
-(void)UIConfigSearchView
{
    [_superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_superView);
        make.centerY.mas_equalTo(_superView).with.offset(-70);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    UIImageView *imageView = [UIImageView getImgWithImageStr:@"showroom_nodata_icon"];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(122);
        make.centerX.mas_equalTo(self);
    }];
    
    UILabel *titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:NSLocalizedString(@"未找到相关代理品牌",nil) WithFont:14.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self addSubview:titleLabel];
    titleLabel.font = getFont(13.0f);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(imageView.mas_bottom).with.offset(30);
        make.bottom.mas_equalTo(0);
    }];
}
#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    if(_block){
        _block(@"showhelp");
    }
}

@end
