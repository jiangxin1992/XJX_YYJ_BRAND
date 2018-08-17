//
//  YYSeriesInfoViewCell.m
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYSeriesInfoViewCell.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "SCLoopScrollView.h"

// 接口
#import "YYUserApi.h"

// 分类
#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYLookBookModel.h"
#import "YYSeriesInfoModel.h"

@interface YYSeriesInfoViewCell()

@property (weak, nonatomic) IBOutlet UILabel *supplyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDueTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descDetailBtnBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UILabel *outTimeFlagView1;
@property (weak, nonatomic) IBOutlet UILabel *outTimeFlagView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outTimeLeftLayoutConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outTimeLeftLayoutConstraint2;
@property (nonatomic,strong) YYLookBookModel *lookBookModel;
@property (weak, nonatomic) IBOutlet SCLoopScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIControl *filterDateRangeView;
@property (weak, nonatomic) IBOutlet UILabel *dateRangeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateRangeValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *filterDataFlagImage;
@property (weak, nonatomic) IBOutlet UILabel *taxTitleLabel;
@property (weak, nonatomic) IBOutlet UIControl *taxTypeView;
@property (weak, nonatomic) IBOutlet UILabel *taxTypeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxTypeValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *taxTypeFlagImage;
@property (weak, nonatomic) IBOutlet UIImageView *lookbookTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *seriesNameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supplyTimeWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxWidthLayout;
@property (weak, nonatomic) IBOutlet UILabel *styleAmountLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *showMinPriceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *hiddenMinPriceConstarint;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelAddToCartButton;
@property (weak, nonatomic) IBOutlet UIButton *sureAddToCartButton;

@end

@implementation YYSeriesInfoViewCell

#pragma mark - --------------生命周期--------------


#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    _addToCartButton.layer.masksToBounds = YES;
    _addToCartButton.layer.cornerRadius = 3.0f;

    _cancelAddToCartButton.layer.masksToBounds = YES;
    _cancelAddToCartButton.layer.cornerRadius = 3.0f;
    _cancelAddToCartButton.layer.borderColor = _define_black_color.CGColor;
    _cancelAddToCartButton.layer.borderWidth = 1;

    _sureAddToCartButton.layer.masksToBounds = YES;
    _sureAddToCartButton.layer.cornerRadius = 3.0f;
}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{

    [self SomePrepare];

    if(_isSelect){
        _addToCartButton.hidden = YES;
        _cancelAddToCartButton.hidden = NO;
        _sureAddToCartButton.hidden = NO;
    }else{
        _addToCartButton.hidden = NO;
        if(self.orderDueCompareResult == NSOrderedAscending){
            _addToCartButton.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
        }else{
            _addToCartButton.backgroundColor = _define_black_color;
        }
        _cancelAddToCartButton.hidden = YES;
        _sureAddToCartButton.hidden = YES;
    }

    if(!_selectCount){
        [_sureAddToCartButton setTitle:NSLocalizedString(@"未选择", nil) forState:UIControlStateNormal];
        _sureAddToCartButton.backgroundColor = [UIColor colorWithHex:@"d3d3d3"];
    }else{
        [_sureAddToCartButton setTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"确定加入(%ld)", nil),_selectCount] forState:UIControlStateNormal];
        _sureAddToCartButton.backgroundColor = _define_black_color;
    }

    _detailBtn.selected = _isDetail;
    float imageHeight = ( SCREEN_WIDTH*265/375);
    _scrollView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
    [_scrollView setConstraintConstant:imageHeight forAttribute:NSLayoutAttributeHeight];
    _filterDateRangeView.hidden = YES;
    if (_seriesModel != nil) {
        _styleAmountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"共%@款",nil),[[NSString alloc] initWithFormat:@"%ld",[_seriesModel.styleAmount integerValue]]];
        
        if ([self.seriesModel.orderPriceMin floatValue] > 0) {
            self.showMinPriceConstraint.priority = 999;
            self.hiddenMinPriceConstarint.priority = 1;
            self.orderPriceMinLabel.hidden = NO;
            self.orderPriceMinLabel.text = replaceMoneyFlag([NSString stringWithFormat:NSLocalizedString(@"系列起订金额：￥%.2lf", nil), [self.seriesModel.orderPriceMin floatValue]], [self.seriesModel.orderPriceCurType integerValue]);
        } else {
            self.showMinPriceConstraint.priority = 1;
            self.hiddenMinPriceConstarint.priority = 999;
            self.orderPriceMinLabel.hidden = YES;
            self.orderPriceMinLabel.text = nil;
        }
        
        if(_dateRanges== nil || [_dateRanges count] == 0){
            _supplyTimeLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"发货日期：",nil), [NSString isNilOrEmpty:self.seriesModel.note] ? NSLocalizedString(@"马上发货", nil) : self.seriesModel.note];
        }else{
            _filterDateRangeView.hidden = NO;
            _supplyTimeLabel.text = NSLocalizedString(@"发货日期：",nil);
            if([_dateRanges count] <= 1){
                [_filterDataFlagImage hideByWidth:YES];
            }else{
                [_filterDataFlagImage hideByWidth:NO];
            }
            [self updateDateRangeUI:self.selectDateRange];
        }

        _seriesNameLabel.text = _seriesModel.name;

        _taxTitleLabel.text = NSLocalizedString(@"税　　制：",nil);
        _taxTypeView.layer.borderWidth = 1;
        _taxTypeView.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
        _taxTypeView.layer.cornerRadius = 2;
        _taxTypeTitleLabel.text = getPayTaxType(_selectTaxType,YES);
        _taxTypeValueLabel.text = @"";

        if ([NSString isNilOrEmpty:self.seriesModel.orderDueTime]) {
            self.orderDueTimeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"最晚下单：%@",nil), NSLocalizedString(@"随时可以下单",nil)];
        } else {
            _orderDueTimeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"最晚下单：%@",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd",_seriesModel.orderDueTime)];
        }

        if(self.lookBookModel == nil){
            self.lookBookModel = [[YYLookBookModel alloc] init];
            WeakSelf(ws);
            if(_seriesModel.lookBookId != nil && [_seriesModel.lookBookId integerValue] > 0){
                [YYUserApi getLookBookInfoWithId:[_seriesModel.lookBookId integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYLookBookModel *lookBookModel, NSError *error) {
                    if(rspStatusAndMessage.status == kCode100){
                        ws.lookBookModel = lookBookModel;
                        if(ws.lookBookModel.coverPic != nil && ![ws.lookBookModel.coverPic isEqualToString:@""]){
                            NSMutableArray *tmpPics = [[NSMutableArray alloc] init];
                            [tmpPics addObject:@{@"picUrl":ws.lookBookModel.coverPic}];
                            if(ws.lookBookModel.picUrls !=nil && [ws.lookBookModel.picUrls count] > 0){
                                [tmpPics addObjectsFromArray:ws.lookBookModel.picUrls];
                            }
                            ws.lookBookModel.picUrls = tmpPics;
                        }
                        [ws updatePicUrls];
                    }else{
                        ws.lookbookTagImageView.hidden = YES;
                        ws.pageControl.hidden = YES;
                        if(ws.seriesModel.albumImg){
                            ws.scrollView.images = @[[NSString stringWithFormat:@"%@%@|%@",ws.seriesModel.albumImg,kStyleDetailCover,@""]];
                        }else{
                            ws.scrollView.images = nil;
                        }
                    }
                }];
            }else{
                _lookbookTagImageView.hidden = YES;
                _pageControl.hidden = YES;
                if(_seriesModel.albumImg){
                    _scrollView.images = @[[NSString stringWithFormat:@"%@%@|%@",_seriesModel.albumImg,kStyleDetailCover,@""]];
                }else{
                    _scrollView.images = nil;
                }
            }
            [_scrollView show:^(NSInteger index) {
                [ws showLookBookPics:nil];
            } finished:^(NSInteger index) {
            }];

        }

        NSString *descStr = ((_seriesDescription && _seriesDescription.length >0)?_seriesDescription:@"");
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = ((descStr.length <= 4)?0:5);//
        NSDictionary *attrDict = @{NSParagraphStyleAttributeName: paraStyle,
                                   NSFontAttributeName: [UIFont systemFontOfSize: 12] };
        float txtHeight =getTxtHeight(SCREEN_WIDTH-34, descStr, attrDict);
        float showHeight = getTxtHeight(SCREEN_WIDTH-34, @" \n \n", attrDict);
        if(txtHeight <= showHeight){
            [_detailBtn hideByHeight:YES];
            _descDetailBtnBottomLayoutConstraint.constant = 0;
        }else{
            [_detailBtn hideByHeight:NO];
            _descDetailBtnBottomLayoutConstraint.constant = 20;
        }

        _descLabel.attributedText = [[NSAttributedString alloc] initWithString: descStr attributes: attrDict];
        NSComparisonResult compareResult1 = NSOrderedDescending;
        NSComparisonResult compareResult2 = NSOrderedDescending;
        compareResult2 = compareNowDate([_seriesModel.supplyEndTime stringValue]);
        compareResult1 = [NSString isNilOrEmpty:self.seriesModel.orderDueTime] ? NSOrderedDescending : compareNowDate(_seriesModel.orderDueTime);

        if(compareResult1 == NSOrderedAscending){
            _outTimeFlagView1.hidden = NO;
            _outTimeLeftLayoutConstraint1.constant = getWidthWithHeight(16.0f, _orderDueTimeLabel.text, _orderDueTimeLabel.font);
        }else{
            _outTimeFlagView1.hidden = YES;
        }
        if(compareResult2 == NSOrderedAscending){
            _outTimeFlagView2.hidden = YES;
            _outTimeLeftLayoutConstraint2.constant = getWidthWithHeight(15.0f, _supplyTimeLabel.text, _supplyTimeLabel.font);
        }else{
            _outTimeFlagView2.hidden = YES;
        }
        [self layoutIfNeeded];

    }else{
        _styleAmountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@款",nil),@"0"];
        _seriesNameLabel.text = @"";
        _supplyTimeLabel.text = [NSString stringWithFormat:@"%@%@-%@",NSLocalizedString(@"发货日期：",nil),@"",@""];
        _orderDueTimeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"最晚下单：%@",nil),@""];
        _descLabel.text = @"";
        [_detailBtn hideByHeight:YES];
        _outTimeFlagView1.hidden = YES;
        _outTimeFlagView2.hidden = YES;
        _scrollView.images = nil;
    }
    NSLog(@"%@ %@ %@",_supplyTimeLabel.text,_taxTitleLabel.text,_orderDueTimeLabel.text);
    _supplyTimeWidthLayout.constant = getWidthWithHeight(15.0f, _supplyTimeLabel.text, _supplyTimeLabel.font);
    _taxWidthLayout.constant = getWidthWithHeight(15.0f, _taxTitleLabel.text, _taxTitleLabel.font);
}

#pragma mark - --------------自定义响应----------------------
//加入购物车
- (IBAction)addToCart:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"addToCart"]];
    }
}
//取消购物车
- (IBAction)cancelAddToCart:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"cancelAddToCart"]];
    }
}
//确认加入
- (IBAction)sureToAddToCart:(id)sender {
    if (self.delegate) {
        if(_selectCount){
            [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"sureToAddToCart"]];
        }
    }
}
- (IBAction)detailBtnHamdler:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"descDetail",@(_isDetail)]];
    }
}

- (IBAction)filterData:(id)sender {
    if (self.delegate && [_dateRanges count] > 1) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"filterDateRange"]];
    }
}
- (IBAction)selectedTaxType:(id)sender {
    if (self.delegate) {
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"selectedTaxType"]];
    }
}
#pragma mark - --------------自定义方法----------------------
-(void)updatePicUrls{
    _lookbookTagImageView.hidden = NO;
    _pageControl.hidden = YES;
    if(_lookBookModel != nil && _lookBookModel.coverPic != nil){
        NSArray *imagesArr = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@%@|%@",_lookBookModel.coverPic,kLookBookImage,@""], nil];
        _scrollView.images = imagesArr;
    }else{
        _scrollView.images = nil;
    }
}

+ (float)cellHeight:(NSString *)desc isDetail:(BOOL)detail showMinPrice:(BOOL)isShow{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = ((desc.length <= 4)?0:5);
    NSDictionary *attrDict = @{NSParagraphStyleAttributeName: paraStyle,
                               NSFontAttributeName: [UIFont systemFontOfSize: 12] };
    float txtHeight = 0;
    if(![desc isEqualToString:@""]){
        txtHeight =getTxtHeight(SCREEN_WIDTH-34, desc, attrDict);
    }
    if( detail){
        txtHeight =  txtHeight + 1;
    }else{
        if(txtHeight > 0){
            float showHeight = getTxtHeight(SCREEN_WIDTH - 34, @" \n \n", attrDict) + 1;
            if(txtHeight <= showHeight){
                txtHeight = txtHeight + 1 - 40;//隐藏按钮后间距处理
            }else{

                txtHeight = showHeight;
            }
        }else{
            txtHeight = -55;
        }
    }
    float imageOffsetY = ((float)(SCREEN_WIDTH*265)/375 - 265);
    if (isShow) {
        return 16 + 45 + 540 + 53 + imageOffsetY + txtHeight - 1;
    } else {
        return 16 + 540 + 53 + imageOffsetY + txtHeight - 1;
    }
}

- (void)showLookBookPics:(id)sender {

    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    if(_lookBookModel ==nil || [_lookBookModel.picUrls count] == 0){
        [tmpArr addObject:[NSString stringWithFormat:@"%@%@|%@",_seriesModel.albumImg,kStyleDetailCover,@""]];
    }else{
        NSInteger count = [_lookBookModel.picUrls count];
        if(count > 0){
            for(int i = 0 ; i < count; i++){
                NSString *imageName =[NSString stringWithFormat:@"%@",[[_lookBookModel.picUrls objectAtIndex:i] objectForKey:@"picUrl"]];
                NSString *_imageRelativePath = imageName;
                NSString *imgInfo = [NSString stringWithFormat:@"%@%@|%@",_imageRelativePath,kLookBookImage,@""];
                [tmpArr addObject:imgInfo];
            }

        }
    }
    float UIWidth = SCREEN_WIDTH;
    float UIHeight = SCREEN_HEIGHT;

    SCLoopScrollView *scrollView = [[SCLoopScrollView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight)];
    scrollView.backgroundColor = [UIColor clearColor];

    if([tmpArr count] == 1){
        scrollView.images = @[[tmpArr objectAtIndex:0],[tmpArr objectAtIndex:0]];
    }else{
        scrollView.images = tmpArr;
    }
    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(scrollView.frame)-100)/2, (CGRectGetHeight(scrollView.frame) -28-15), 100, 28)];
    pageLabel.textColor = [UIColor whiteColor];//[UIColor colorWithHex:@"0xafafafaf99"];
    pageLabel.font = [UIFont systemFontOfSize:15];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.text = [NSString stringWithFormat:@"%d / %ld",1,[tmpArr count]];
    __block UILabel *weakpageLabel = pageLabel;
    __block NSInteger blockPagecount = [tmpArr count];

    CMAlertView *alert = [[CMAlertView alloc] initWithViews:@[scrollView,pageLabel] imageFrame:CGRectMake(0, 0, UIWidth, UIHeight) bgClose:NO];
    __block  CMAlertView *blockalert = alert;
    [scrollView show:^(NSInteger index) {
        [blockalert OnTapBg:nil];
    } finished:^(NSInteger index) {
        if(blockPagecount == 0){
            [weakpageLabel setText:@""];
        }else{
            [weakpageLabel setText:[NSString stringWithFormat:@"%ld / %ld",MIN(blockPagecount,index+1),blockPagecount]];
        }
    }];
    [alert show];
}

-(void)updateDateRangeUI:(YYDateRangeModel *)dateRange{
    _filterDateRangeView.layer.borderWidth = 1;
    _filterDateRangeView.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
    _filterDateRangeView.layer.cornerRadius = 2;
    if(dateRange == nil || [dateRange.id unsignedIntegerValue] == 0){
        _dateRangeTitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"共分%lu个波段",nil),(unsigned long)[_dateRanges count]];
        _dateRangeValueLabel.text = [NSString stringWithFormat:@"%@-%@",getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd",[_seriesModel.supplyStartTime stringValue]),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd",[_seriesModel.supplyEndTime stringValue])];
        _filterDateRangeView.backgroundColor = [UIColor whiteColor];

    }else{
        _dateRangeTitleLabel.text = dateRange.name;
        _dateRangeValueLabel.text = [NSString stringWithFormat:@"%@-%@",getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd",[dateRange.start stringValue]),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd",[dateRange.end stringValue])];

        _filterDateRangeView.backgroundColor = [UIColor colorWithHex:@"efefef"];
    }
    float dateRangeTitleWidth = SCREEN_WIDTH - 88- 200;
    float minTitleWidth = 80;
    if(dateRangeTitleWidth < minTitleWidth){
        float dateRangeValueWidth = 160 - (minTitleWidth-dateRangeTitleWidth);
        [_dateRangeValueLabel setConstraintConstant:dateRangeValueWidth forAttribute:NSLayoutAttributeWidth];
    }
    _dateRangeValueLabel.adjustsFontSizeToFitWidth = YES;

}

#pragma mark - --------------other----------------------

@end
