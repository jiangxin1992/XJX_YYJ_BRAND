//
//  YYDetailContentParamsViewCellNew.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYDetailContentParamsViewCellNew.h"

#import "regular.h"
#import "SCGIFImageView.h"

#import "YYStyleInfoModel.h"
#import "YYDetailContentAdaptiveView.h"

@interface YYDetailContentParamsViewCellNew ()

@property (nonatomic,strong) YYStyleInfoModel *styleInfoModel;

@property (nonatomic,strong) UIView *headView;

@property (nonatomic,strong) UIView *desView;
@property (nonatomic,strong) YYDetailContentAdaptiveView *desLabel;
@property (nonatomic,strong) YYDetailContentAdaptiveView *seriesLabel;

@property (nonatomic,strong) UIView *sizeView;
@property (nonatomic,strong) YYDetailContentAdaptiveView *sizeLabel;
@property (nonatomic,strong) YYDetailContentAdaptiveView *numbersLabel;
@property (nonatomic,strong) YYDetailContentAdaptiveView *categoryLabel;
@property (nonatomic,strong) YYDetailContentAdaptiveView *materialsLabel;

@property (nonatomic,strong) UIView *rangeView;
@property (nonatomic,strong) YYDetailContentAdaptiveView *rangeLabel;
@property (nonatomic,strong) YYDetailContentAdaptiveView *orderAmountMinLabel;
@property (nonatomic,strong) YYDetailContentAdaptiveView *orderPriceMinLabel;

@end

@implementation YYDetailContentParamsViewCellNew

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
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

-(void)PrepareData{}
-(void)PrepareUI{
    self.backgroundColor = _define_white_color;
}
#pragma mark - UIConfig
-(void)UIConfig{
    [self CreateHeadView];
    [self CreateDesView];
    [self CreateSizeView];
    [self CreateRangeView];
    [self updateUI:nil atColorIndex:0];
}
-(void)CreateHeadView{
    _headView = [UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:_headView];
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    
    UIView *lineView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_headView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *titleLabel = [UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"商品详情",nil) WithFont:15.0f WithTextColor:nil WithSpacing:0];
    [_headView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_headView);
        make.bottom.mas_equalTo(lineView.mas_top).with.offset(0);
        make.top.mas_equalTo(0);
    }];
}
-(void)CreateDesView{
    WeakSelf(ws);
    _desView = [UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:_desView];
    [_desView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.headView.mas_bottom).with.offset(0);
    }];
    
    _desLabel = [[YYDetailContentAdaptiveView alloc] initWithKey:NSLocalizedString(@"款式描述",nil) Value:nil IsValueLineNum:0];
    [_desView addSubview:_desLabel];
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(18);
    }];
    
    _seriesLabel = [[YYDetailContentAdaptiveView alloc] initWithKey:NSLocalizedString(@"所属系列",nil) Value:nil IsValueLineNum:2];
    [_desView addSubview:_seriesLabel];
    [_seriesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.desLabel.mas_bottom).with.offset(18);
    }];
    
    UIView *lineView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_desView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(ws.seriesLabel.mas_bottom).with.offset(18);
    }];
    
}
-(void)CreateSizeView{
    WeakSelf(ws);
    _sizeView = [UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:_sizeView];
    [_sizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.desView.mas_bottom).with.offset(0);
    }];
    
    _sizeLabel = [[YYDetailContentAdaptiveView alloc] initWithKey:NSLocalizedString(@"尺码",nil) Value:nil IsValueLineNum:2];
    [_sizeView addSubview:_sizeLabel];
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(18);
    }];
    
    _numbersLabel = [[YYDetailContentAdaptiveView alloc] initWithKey:NSLocalizedString(@"款号",nil) Value:nil IsValueLineNum:2];
    [_sizeView addSubview:_numbersLabel];
    [_numbersLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.sizeLabel.mas_bottom).with.offset(18);
    }];
    
    _categoryLabel = [[YYDetailContentAdaptiveView alloc] initWithKey:NSLocalizedString(@"分类",nil) Value:nil IsValueLineNum:2];
    [_sizeView addSubview:_categoryLabel];
    [_categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.numbersLabel.mas_bottom).with.offset(18);
    }];
    
    _materialsLabel = [[YYDetailContentAdaptiveView alloc] initWithKey:NSLocalizedString(@"材料",nil) Value:nil IsValueLineNum:2];
    [_sizeView addSubview:_materialsLabel];
    [_materialsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.categoryLabel.mas_bottom).with.offset(18);
    }];
    
    UIView *lineView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_sizeView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(ws.materialsLabel.mas_bottom).with.offset(18);
    }];
}
-(void)CreateRangeView{
    WeakSelf(ws);
    _rangeView = [UIView getCustomViewWithColor:nil];
    [self.contentView addSubview:_rangeView];
    [_rangeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.sizeView.mas_bottom).with.offset(0);
    }];
    
    _rangeLabel = [[YYDetailContentAdaptiveView alloc] initWithKey:NSLocalizedString(@"发货波段",nil) Value:nil IsValueLineNum:0];
    [_rangeView addSubview:_rangeLabel];
    [_rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(18);
    }];
    
    _orderAmountMinLabel = [[YYDetailContentAdaptiveView alloc] initWithKey:NSLocalizedString(@"起订量",nil) Value:nil IsValueLineNum:2];
    [_rangeView addSubview:_orderAmountMinLabel];
    [_orderAmountMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.rangeLabel.mas_bottom).with.offset(18);
    }];
    
    _orderPriceMinLabel = [[YYDetailContentAdaptiveView alloc] initWithKey:NSLocalizedString(@"起订额",nil) Value:nil IsValueLineNum:2];
    [_rangeView addSubview:_orderPriceMinLabel];
    [_orderPriceMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(ws.orderAmountMinLabel.mas_bottom).with.offset(18);
    }];
    
    UIView *lineView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"EFEFEF"]];
    [_rangeView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(ws.orderPriceMinLabel.mas_bottom).with.offset(18);
    }];
    
    UIView *doneView = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"f8f8f8"]];
    [_rangeView addSubview:doneView];
    [doneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(lineView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(10);
    }];
}
#pragma mark - Setter
-(void)setStyleInfoModel:(YYStyleInfoModel *)styleInfoModel atColorIndex:(NSInteger)colorIndex {
    _styleInfoModel = styleInfoModel;
    if(_headView){
        if(_styleInfoModel){
            _desLabel.value = styleInfoModel.style.styleDescription;
            _seriesLabel.value = styleInfoModel.style.seriesName;
            
            _sizeLabel.value = [styleInfoModel getSizeDes];
            _numbersLabel.value = ((YYColorModel *)styleInfoModel.colorImages[colorIndex]).styleCode;
            _categoryLabel.value = styleInfoModel.style.category;
            _materialsLabel.value = ((YYColorModel *)styleInfoModel.colorImages[colorIndex]).materials;
            
            self.rangeLabel.key = (_styleInfoModel && _styleInfoModel.dateRange) ? NSLocalizedString(@"发货波段",nil) : NSLocalizedString(@"发货日期",nil);
            _rangeLabel.value = ((_styleInfoModel && _styleInfoModel.dateRange)?[_styleInfoModel.dateRange getShowStr] : ([NSString isNilOrEmpty:styleInfoModel.style.note] ? NSLocalizedString(@"马上发货", nil) : styleInfoModel.style.note));
            
            _orderAmountMinLabel.value = [NSString stringWithFormat:@"%@ %@/%@",(_styleInfoModel?[_styleInfoModel.style.orderAmountMin stringValue]:@""),NSLocalizedString(@"件",nil),NSLocalizedString(@"款",nil)];
            _orderPriceMinLabel.value = [NSString stringWithFormat:@"￥ %0.2f/%@",(_styleInfoModel?[_styleInfoModel.style.orderPriceMin floatValue]:0.00),NSLocalizedString(@"单",nil)];;
            
        }else{
            _desLabel.value = @"";
            _seriesLabel.value = @"";

            _sizeLabel.value = @"";
            _numbersLabel.value = @"";
            _categoryLabel.value = @"";
            _materialsLabel.value = @"";

            _rangeLabel.value = @"";
            _orderAmountMinLabel.value = @"";
            _orderPriceMinLabel.value = @"";
        }
    }
}
#pragma mark - updateUI
- (void)updateUI:(YYStyleInfoModel *)styleInfoModel atColorIndex:(NSInteger)colorIndex {
    if (styleInfoModel) {
        [self setStyleInfoModel:styleInfoModel atColorIndex:colorIndex];
    }
    [_desLabel updateUI];
    [_seriesLabel updateUI];
    
    [_sizeLabel updateUI];
    [_numbersLabel updateUI];
    [_categoryLabel updateUI];
    [_materialsLabel updateUI];
    
    [_rangeLabel updateUI];
    [_orderAmountMinLabel updateUI];
    [_orderPriceMinLabel updateUI];
}
#pragma mark - SomeAction
+ (CGFloat)getHeightWithColorModel:(YYStyleInfoModel *)styleInfoModel atColorIndex:(NSInteger)colorIndex {
    YYDetailContentParamsViewCellNew *cell = [[YYDetailContentParamsViewCellNew alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell updateUI:styleInfoModel atColorIndex:colorIndex];
    [cell.contentView layoutIfNeeded];
    CGRect frame =  cell.rangeView.frame;
    return frame.origin.y + frame.size.height;
}
#pragma mark - other
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
@end
