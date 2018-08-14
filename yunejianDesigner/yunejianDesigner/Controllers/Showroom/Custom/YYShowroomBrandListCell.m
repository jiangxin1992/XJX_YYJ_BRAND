//
//  YYShowroomBrandListCell.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomBrandListCell.h"

#import "SCGIFImageView.h"

@interface YYShowroomBrandListCell()

@property (strong ,nonatomic) SCGIFImageView *headview;
@property (strong ,nonatomic) UILabel *brandNameLabel;
@property (strong ,nonatomic) UILabel *designerNameLabel;
@property (strong ,nonatomic) UIView *bottomLine;
@end

@implementation YYShowroomBrandListCell

#pragma mark - 初始化
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self UIConfig];
    }
    return self;
}
#pragma mark - UIConfig
-(void)UIConfig
{
    self.contentView.backgroundColor = _define_white_color;
    
    _headview = [[SCGIFImageView alloc] init];
    [self.contentView addSubview:_headview];
    _headview.contentMode = 1;
    [_headview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.width.height.mas_equalTo(50);
        make.centerY.mas_equalTo(_headview.superview);
    }];
    _headview.backgroundColor = _define_white_color;
    _headview.layer.masksToBounds = YES;
    _headview.layer.cornerRadius = 25;
    _headview.layer.borderWidth = 1;
    _headview.layer.borderColor = [[UIColor colorWithHex:@"EFEFEF"] CGColor];
    
    _brandNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [self.contentView addSubview:_brandNameLabel];
    [_brandNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headview.mas_right).with.offset(13.0f);
        make.bottom.mas_equalTo(_headview.mas_centerY).with.offset(0);
        make.right.mas_equalTo(-17);
    }];

    _designerNameLabel = [UILabel getLabelWithAlignment:0 WithTitle:@"" WithFont:13.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [self.contentView addSubview:_designerNameLabel];
    [_designerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headview.mas_right).with.offset(13.0f);
        make.top.mas_equalTo(_headview.mas_centerY).with.offset(0);
        make.right.mas_equalTo(-17);
    }];
    
    _bottomLine = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"efefef"]];
    [self.contentView addSubview:_bottomLine];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
    }];
}
#pragma mark - setter
-(void)setBrandModel:(YYShowroomBrandModel *)brandModel
{
    _brandModel = brandModel;
    _brandNameLabel.text = _brandModel.brandName;
    _designerNameLabel.text = _brandModel.designerName;
    
    if(_brandModel && ![NSString isNilOrEmpty:_brandModel.brandLogo]){
        sd_downloadWebImageWithRelativePath(NO, _brandModel.brandLogo, _headview, kNewsCover, 0);
    }else{
        sd_downloadWebImageWithRelativePath(NO, @"", _headview, kNewsCover, 0);
    }
}
#pragma mark - SomeAction
-(void)bottomIsHide:(BOOL )ishide
{
    if(_bottomLine)
    {
        _bottomLine.hidden = ishide;
    }
}
#pragma mark - Other
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
