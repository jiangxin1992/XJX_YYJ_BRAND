//
//  YYBuyerInfoAboutCell.m
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYBrandInfoSeriesCell.h"

#import "YYNoDataView.h"

#import "YYOpusSeriesModel.h"
#import "SCGIFImageView.h"

@interface YYBrandInfoSeriesCell ()

@property (nonatomic, strong) YYNoDataView *noIntroductionDataView;
@property (nonatomic, assign) CGFloat cellWidth;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat labelHeight;

@end

@implementation YYBrandInfoSeriesCell

#pragma mark - init
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type, NSInteger idx))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _cellblock=block;
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
-(void)PrepareData
{
    _cellWidth = floor((SCREEN_WIDTH-14*2-12)/2.0f);
    _cellHeight = floor((285.0f/215.0f)*_cellWidth)+17;
    _labelHeight = floor((((_cellHeight-17)-(_cellWidth-5)-10)/3.0f));
}
-(void)PrepareUI
{
    self.contentView.backgroundColor=[UIColor colorWithHex:@"EFEFEF"];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateNoDataView];
}
-(void)CreateNoDataView
{
    if(_isHomePage)
    {
        _noIntroductionDataView = (YYNoDataView *)addNoDataView_phone(self.contentView,[NSString stringWithFormat:@"%@|icon:notxt_icon",NSLocalizedString(@"该设计师还未发布系列",nil)],kDefaultBorderColor,@"noinfo_icon");
    }else
    {
        _noIntroductionDataView = (YYNoDataView *)addNoDataView_phone(self.contentView,[NSString stringWithFormat:@"%@|icon:notxt_icon",NSLocalizedString(@"该设计师还未发布系列",nil)],kDefaultBorderColor,@"noinfo_icon");
    }
    [self.contentView addSubview:_noIntroductionDataView];
    [_noIntroductionDataView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(100);
    }];
    _noIntroductionDataView.hidden=YES;
    
}
#pragma mark - Setter
-(void)setSeriesArray:(NSMutableArray *)seriesArray
{
    _seriesArray = seriesArray;
    [self setData];
}

-(void)setData
{

    for (UIView *obj in self.contentView.subviews) {
        if(![obj isKindOfClass:[YYNoDataView class]]){
            [obj removeFromSuperview];
        }else{
            NSLog(@"YYNoDataView");
        }
    }

    __block UIView *lastView = nil;
    [_seriesArray enumerateObjectsUsingBlock:^(YYOpusSeriesModel *seriesModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *backimg = [UIButton getCustomBtn];
        [self.contentView addSubview:backimg];
        backimg.layer.masksToBounds = YES;
        backimg.layer.cornerRadius = 3;
        backimg.tag = 100+idx;
        [backimg addTarget:self action:@selector(cardClick:) forControlEvents:UIControlEventTouchUpInside];
        backimg.backgroundColor = _define_white_color;
        [backimg mas_makeConstraints:^(MASConstraintMaker *make) {
            if((idx+1)%2)
            {
                make.left.mas_equalTo(14);
            }else
            {
                make.right.mas_equalTo(-14);
            }
            NSInteger row = 0;
            if((idx+1)%2)
            {
                row = 1+((idx+1)/2);
            }else
            {
                row = (idx+1)/2;
            }
            make.height.mas_equalTo(_cellHeight);
            make.width.mas_equalTo(_cellWidth);
            make.top.mas_equalTo(11+(row-1)*(12+_cellHeight));
        }];
        
        SCGIFImageView *_logoImageView = [[SCGIFImageView alloc] init];
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [backimg addSubview:_logoImageView];
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(_cellWidth-10);
        }];
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.layer.cornerRadius = 3;
        
        sd_downloadWebImageWithRelativePath(YES, seriesModel.albumImg, _logoImageView, kBuyerCardImage, UIViewContentModeScaleAspectFit);
        
        NSArray *contentArr = @[
                                seriesModel.name
                                ,[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"最晚下单",nil),getShowDateByFormatAndTimeInterval(@"yy/MM/dd",seriesModel.orderDueTime)]
                                ,[[NSString alloc] initWithFormat:NSLocalizedString(@"%@款",nil),[seriesModel.styleAmount stringValue]]
                                ];
        __block UIView *lastlabel = nil;
        [contentArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [UILabel getLabelWithAlignment:0 WithTitle:obj WithFont:12.0f WithTextColor:idx?[UIColor colorWithRed:145.0f/255.0f green:145.0f/255.0f blue:145.0f/255.0f alpha:1]:_define_black_color WithSpacing:0];
            [backimg addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                if(!idx)
                {
                    make.top.mas_equalTo(_logoImageView.mas_bottom).with.offset(10);
                }else
                {
                    make.top.mas_equalTo(lastlabel.mas_bottom).with.offset(6);
                }
                make.left.mas_equalTo(5);
                make.right.mas_equalTo(-5);
                make.height.mas_equalTo(_labelHeight);
            }];
            label.text = obj;
            lastlabel = label;
        }];
        
        lastView = backimg;
        
    }];
    
    if(!_seriesArray.count)
    {
        _noIntroductionDataView.hidden = NO;
    }else
    {
        _noIntroductionDataView.hidden = YES;
    }
    NSLog(@"self.contentView.subviews.count = %ld",self.contentView.subviews.count);
    NSLog(@"111");
}
#pragma mark - SomeAction
-(void)cardClick:(UIButton *)btn
{
    if(_cellblock){
        _cellblock(@"cardClick",btn.tag-100);
    }
}
+(CGFloat )getHeightWithHomeSeriesArray:(NSMutableArray *)seriesArray
{
    if(seriesArray.count)
    {
        CGFloat _cellWidth = floor((SCREEN_WIDTH-14*2-12)/2.0f);
        CGFloat _cellHeight = floor((285.0f/215.0f)*_cellWidth)+17;
        
        NSInteger row = 0;
        if(seriesArray.count%2)
        {
            row = 1+(seriesArray.count/2);
        }else
        {
            row = seriesArray.count/2;
        }
        
        return 22+(row)*_cellHeight+(row-1)*12;
    }
    return 250;
}
+(BOOL)haveData:(NSMutableArray *)seriesArray
{
    return seriesArray.count;
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

