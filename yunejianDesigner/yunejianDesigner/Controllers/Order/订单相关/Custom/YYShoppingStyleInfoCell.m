//
//  YYShoppingStyleInfoCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYShoppingStyleInfoCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCGIFImageView.h"
#import "TitlePagerView.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYStyleInfoModel.h"
#import "YYOpusStyleModel.h"
#import "YYOpusSeriesModel.h"

@interface YYShoppingStyleInfoCell()<TitlePagerViewDelegate>

@property (weak, nonatomic) IBOutlet SCGIFImageView *styleImage;
@property (weak, nonatomic) IBOutlet UILabel *styleNameLab;
@property (weak, nonatomic) IBOutlet UILabel *styleCodeLab;
@property (weak, nonatomic) IBOutlet UILabel *styleTypeLab;

@property (nonatomic, strong) TitlePagerView *segmentBtn;
@property (weak, nonatomic) IBOutlet UIView *middleLine;

@end

@implementation YYShoppingStyleInfoCell

#pragma mark - --------------生命周期--------------
- (void)awakeFromNib {
    [super awakeFromNib];
    [self SomePrepare];
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
    if(!self.segmentBtn){

        NSArray *titleArray = @[NSLocalizedString(@"选择尺码数量",nil),NSLocalizedString(@"只选择颜色",nil)];

        self.segmentBtn = [[TitlePagerView alloc] init];
        [self.contentView addSubview:self.segmentBtn];
        self.segmentBtn.backgroundColor = [UIColor clearColor];
        self.segmentBtn.font = [UIFont systemFontOfSize:13.0f];
        self.segmentBtn.dynamicTitlePagerViewTitleSpace = 60.0f;
        [self.segmentBtn addObjects:titleArray];
        self.segmentBtn.delegate = self;

        //获取单个item的宽度
        CGFloat pagingTitleViewItemWidth = [TitlePagerView getMaxTitleWidthFromArray:titleArray withFont:self.segmentBtn.font];
        //获取整个pageview的宽度
        CGFloat pagingTitleViewWidth =  pagingTitleViewItemWidth * [titleArray count] + self.segmentBtn.dynamicTitlePagerViewTitleSpace * ([titleArray count] -1);

        self.segmentBtn.frame = CGRectMake((SCREEN_WIDTH - pagingTitleViewWidth)/2.0f, 118, pagingTitleViewWidth, 43);

    }
}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    self.segmentBtn.hidden = _isModifyOrder;
    self.middleLine.hidden = _isModifyOrder;
    
    if(!self.segmentBtn.hidden){
        [self.segmentBtn adjustTitleViewByIndexNew:_isOnlyColor?1:0];
    }

    NSString *imageRelativePath = nil;
    if (_opusStyleModel
        && ![NSString isNilOrEmpty:_opusStyleModel.albumImg]) {
        imageRelativePath = _opusStyleModel.albumImg;
    }else{
        if (_styleInfoModel
            && ![NSString isNilOrEmpty:_styleInfoModel.style.albumImg]) {
            imageRelativePath = _styleInfoModel.style.albumImg;
        }
    }

    sd_downloadWebImageWithRelativePath(NO, imageRelativePath, _styleImage, kSeriesCover, 0);

    CGFloat minPrice = [self.styleInfoModel getMinTradePrice];
    CGFloat maxPrice = [self.styleInfoModel getMaxTradePrice];
    self.styleNameLab.text = _styleInfoModel.style.name;
    self.styleCodeLab.text = _styleInfoModel.style.styleCode;
    self.styleTypeLab.text = minPrice == maxPrice ? replaceMoneyFlag([NSString stringWithFormat:@"%@ ￥%.2f",NSLocalizedString(@"批发价",nil), minPrice], [self.styleInfoModel.style.curType integerValue]) : replaceMoneyFlag([NSString stringWithFormat:@"%@ ￥%.2f-%.2f",NSLocalizedString(@"批发价",nil), minPrice, maxPrice],[_styleInfoModel.style.curType integerValue]);
}

#pragma mark - --------------自定义响应----------------------

#pragma mark - --------------系统代理----------------------
#pragma TitlePagerViewDelegate
- (void)didTouchBWTitle:(NSUInteger)index {
    if ((self.isOnlyColor && index == 1) || (!self.isOnlyColor && index == 0)) {
        return;
    }
    self.currentIndex = index;
}

- (void)setCurrentIndex:(NSInteger)index {
    if(_changeChooseStyle){
        _changeChooseStyle();
    }
}
#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------



@end
