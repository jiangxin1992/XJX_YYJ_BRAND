//
//  YYDetailContentTopViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/3/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYDetailContentTopViewCell.h"

#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "SCGIFButtonView.h"
#import "SCGIFImageView.h"

@interface YYDetailContentTopViewCell()

@end

@implementation YYDetailContentTopViewCell{
    UIButton *_lastSelectedButton;
    UILabel *_lastSelectedLabel;
}

- (void)updateUI{
    _scrollView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
    [_scrollView setConstraintConstant:SCREEN_WIDTH forAttribute:NSLayoutAttributeHeight];
    
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [_define_black_color colorWithAlphaComponent:0.3];
    _pageControl.currentPageIndicatorTintColor = _define_black_color;
  
    self.segmentBtn.font = [UIFont systemFontOfSize:15];
    self.segmentBtn.pageIndicatorHeight = 4;
    NSArray *titleArray = @[NSLocalizedString(@"商品参数",nil),NSLocalizedString(@"商品描述",nil)];
    [self.segmentBtn addObjects:titleArray];
    self.segmentBtn.delegate = self;

    _titleLabel.text = _styleInfoModel.style.name;
    _stylePriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"%@ ￥%0.2f",NSLocalizedString(@"批发价",nil), [((YYColorModel *)self.styleInfoModel.colorImages[self.currentColorIndexToShow]).tradePrice floatValue]],[_styleInfoModel.style.curType integerValue]);
    if(needPayTaxView([_styleInfoModel.style.curType integerValue]) && _selectTaxType){
        float taxRate = [getPayTaxType(_selectTaxType,NO) doubleValue];
        NSString *taxTypeStr = getPayTaxType(_selectTaxType,YES);
        _styleTradePriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"%@ %@ ￥%0.2f    %@ ￥%0.2f",taxTypeStr,NSLocalizedString(@"税后价",nil), [((YYColorModel *)self.styleInfoModel.colorImages[self.currentColorIndexToShow]).tradePrice floatValue]*(1+taxRate),NSLocalizedString(@"零售价",nil), [((YYColorModel *)self.styleInfoModel.colorImages[self.currentColorIndexToShow]).retailPrice floatValue]],[_styleInfoModel.style.curType integerValue]);
    }else{
        _styleTradePriceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"%@ ￥%0.2f",NSLocalizedString(@"零售价",nil), [((YYColorModel *)self.styleInfoModel.colorImages[self.currentColorIndexToShow]).retailPrice floatValue]],[_styleInfoModel.style.curType integerValue]);
    }
    NSArray *colorArray = _styleInfoModel.colorImages;
    if (colorArray && [colorArray count] > 0) {
        [self addColorButton:self.colorBgView colors:colorArray];
    }
}

+(float)cellHeight:(NSInteger)arrayCount{
    int perLines = 5;
    int item_height = 25;
    int margin = 10;
    NSInteger lines = arrayCount%perLines == 0 ? arrayCount/perLines:arrayCount/perLines+1;
    float viewHeight = item_height*lines + (lines-1)*margin;
    viewHeight = MAX(item_height, viewHeight);
    return 308 + SCREEN_WIDTH - 100 + viewHeight - item_height-23;
}


- (void)changeImageByChangColorButton:(id)sender{
    UIButton *button = (UIButton *)sender;
    UILabel *buttonLabel = [self viewWithTag:100 + button.tag];
    if (button.tag != _currentColorIndexToShow) {
        if (_lastSelectedButton || _lastSelectedLabel) {
            _lastSelectedButton.layer.borderColor = _define_white_color.CGColor;
            _lastSelectedLabel.hidden = YES;
        }
        _currentColorIndexToShow = button.tag;
        if(self.delegate){
            [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"ColorIndexToShow",@(_currentColorIndexToShow)]];
        }
        [self updateScrollViewContentView];
        button.layer.borderColor = _define_black_color.CGColor;
        buttonLabel.hidden = NO;
        _lastSelectedButton = button;
        _lastSelectedLabel = buttonLabel;
    }
}


- (void)updateScrollViewContentView{
    NSArray *imageArray = nil;
    imageArray = _styleInfoModel.colorImages;
    //_pageControl.hidden = YES;
    
    // 非常耗时
    if (imageArray && _currentColorIndexToShow < [imageArray count]) {
        NSArray *detailImageArray = nil;
        
        NSObject *obj = [imageArray objectAtIndex:_currentColorIndexToShow];
        if ([obj isKindOfClass:[YYColorModel class]]) {
            YYColorModel  *colorModel = (YYColorModel  *)obj;
            detailImageArray = colorModel.imgs;
        }
        
        if (!detailImageArray || [detailImageArray count] == 0) {
            NSString *albumImg = nil;
            if(_styleInfoModel&& _styleInfoModel.style){
                albumImg = _styleInfoModel.style.albumImg;
            }
            
            if(albumImg){
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
                [tempArray addObject:albumImg];
                detailImageArray = [NSArray arrayWithArray:tempArray];
            }
        }
        
        
        if (detailImageArray
            && [detailImageArray count] > 0) {
            
            NSInteger count = [detailImageArray count];
            NSMutableArray * tempImageArray = [[NSMutableArray alloc]initWithCapacity:count];
            _pageControl.numberOfPages = count;
            _pageControl.currentPage = 0;
            _pageControl.hidden = NO;
            for ( int i = 0 ; i < count ; ++i )
            {
                NSString *imageRelativePath = nil;
                NSObject *tempObj = [detailImageArray objectAtIndex:i];
                if ([tempObj isKindOfClass:[NSString class]]) {
                    imageRelativePath = (NSString *)tempObj;
                }

                NSString *imageInfo = [NSString stringWithFormat:@"%@%@|%@",imageRelativePath,kStyleDetailCover,@""];
                [tempImageArray addObject:imageInfo];
            }
            WeakSelf(ws);
            _scrollView.images = tempImageArray;
            [_scrollView show:^(NSInteger index) {
                //_tapLabel.text = @(index).stringValue;
            } finished:^(NSInteger index) {
                // _indexLabel.text = @(index).stringValue;
                ws.pageControl.currentPage = index;
            }];
        }else{
            _pageControl.numberOfPages = 1;
            _pageControl.currentPage = 0;
            _pageControl.hidden = NO;
            UIImage *defaultImage = [UIImage imageWithColor:[UIColor colorWithHex:kDefaultImageColor] size:CGSizeMake(600, 600)];
            _scrollView.images = @[defaultImage];
        }
        _pageControl.hidesForSinglePage = YES;
        //_pageControl.backgroundColor = [UIColor greenColor];
    }
}

- (void)addColorButton:(UIView *)colorBgView colors:(NSArray *)colorArray{
    WeakSelf(ws);
    NSInteger arrayCount = [colorArray count];
    int perLines = 5;
    NSInteger lines = arrayCount%perLines == 0 ? arrayCount/perLines:arrayCount/perLines+1;
    NSInteger maxLineNum = MIN(perLines, arrayCount);
    //    int item_with = 25;
    //    int item_height = 25;
    //    int margin = 10;
    int item_with = 32;
    int item_height = 32;
    int item_title_height = 25;
    int margin = 3;
    
    for (UIButton *oldBtn in [colorBgView subviews]) {
        //[oldBtn removeTarget:weakSelf action:@selector(changeImageByChangColorButton:) forControlEvents:UIControlEventTouchUpInside];
        [oldBtn removeFromSuperview];
    }

    float viewHeight = (item_height+item_title_height)*lines + (lines-1)*margin;
    float viewWidth = item_with*maxLineNum + (maxLineNum-1)*margin;
    [_colorBgView setConstraintConstant:viewHeight forAttribute:NSLayoutAttributeHeight];
    [_colorBgView setConstraintConstant:viewWidth forAttribute:NSLayoutAttributeWidth];
    
    [UIView animateWithDuration:0.3 animations:^{
        [colorBgView layoutIfNeeded];
    }];
    for (int line = 0; line < lines; line++) {
        UIView *lastView = nil;
        for (int i = line*perLines; i < (line+1)*perLines; i++) {
            if (i >= arrayCount) {
                break;
            }
            
            NSString *colorValue = nil;
            NSString *colorName = nil;
            NSObject *obj = [colorArray objectAtIndex:i];
            if ([obj isKindOfClass:[YYColorModel class]]) {
                YYColorModel  *colorModel = (YYColorModel  *)obj;
                colorValue = colorModel.value;
                colorName = colorModel.name;
            }
            
            if (colorValue) {
                if ([colorValue hasPrefix:@"#"] && [colorValue length] == 7) {
                    //                    32
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.layer.borderWidth = 1;
                    button.layer.borderColor = _define_white_color.CGColor;
                    [button addTarget:self action:@selector(changeImageByChangColorButton:) forControlEvents:UIControlEventTouchUpInside];
                    [button setUserInteractionEnabled:YES];
                    button.tag = i;
                    [colorBgView addSubview:button];
                    if (i == _currentColorIndexToShow) {
                        button.layer.borderColor = _define_black_color.CGColor;
                        _lastSelectedButton = button;
                        [ws updateScrollViewContentView];
                    }
                    
                    __weak UIView *weakContainer = colorBgView;
                    
                    
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        //make.top.and.bottom.equalTo(weakContainer);
                        make.width.mas_equalTo(item_with);
                        make.height.mas_equalTo(item_height);
                        
                        if ( lastView )
                        {
                            make.left.mas_equalTo(lastView.mas_right).with.offset(margin);
                        }
                        else
                        {
                            make.left.mas_equalTo(weakContainer.mas_left);
                        }
                        make.top.equalTo(weakContainer.mas_top).with.offset(line*(item_height+margin+item_title_height));
                        
                    }];
                    
                    //16进制的色值
                    UIColor *color = [UIColor colorWithHex:[colorValue substringFromIndex:1]];
                    SCGIFImageView *btnImageView = [[SCGIFImageView alloc] initWithImage:[UIColor createImageWithColor:color]];
                    [button addSubview:btnImageView];
                    [btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(button);
                        make.width.height.mas_equalTo(25);
                    }];
                    
                    btnImageView.layer.masksToBounds = YES;
                    btnImageView.layer.borderColor = [[_define_black_color colorWithAlphaComponent:0.2] CGColor];
                    btnImageView.layer.borderWidth = 1;
                    
                    //                    [button setBackgroundImage:[UIColor createImageWithColor:color] forState:UIControlStateNormal];
                    
                    lastView = button;
                }else{
                    //图片
                    
                    SCGIFButtonView *button = [SCGIFButtonView buttonWithType:UIButtonTypeCustom];
                    button.layer.borderWidth = 1;
                    button.layer.borderColor = _define_white_color.CGColor;
                    [button addTarget:self action:@selector(changeImageByChangColorButton:) forControlEvents:UIControlEventTouchUpInside];
                    [button setUserInteractionEnabled:YES];
                    
                    button.tag = i;
                    [colorBgView addSubview:button];
                    
                    if (i == _currentColorIndexToShow) {
                        button.layer.borderColor = _define_black_color.CGColor;
                        _lastSelectedButton = button;
                        [ws updateScrollViewContentView];
                    }
                    
                    __weak UIView *weakContainer = colorBgView;
                    
                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(item_with);
                        make.height.mas_equalTo(item_height);
                        if ( lastView ){
                            make.left.mas_equalTo(lastView.mas_right).with.offset(margin);
                        }else{
                            make.left.mas_equalTo(weakContainer.mas_left);
                        }
                        make.top.equalTo(weakContainer.mas_top).with.offset(line*(item_height+margin+item_title_height));
                        
                    }];
                    
                    SCGIFImageView *btnImageView = [[SCGIFImageView alloc] init];
                    [button addSubview:btnImageView];
                    btnImageView.contentMode = UIViewContentModeScaleToFill;
                    [btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.center.mas_equalTo(button);
                        make.width.height.mas_equalTo(25);
                    }];
                    NSString *imageRelativePath = colorValue;
                    sd_downloadWebImageWithRelativePath(NO, imageRelativePath, btnImageView, kStyleColorImageCover, 0);
                    
                    btnImageView.layer.masksToBounds = YES;
                    btnImageView.layer.borderColor = [[_define_black_color colorWithAlphaComponent:0.2] CGColor];
                    btnImageView.layer.borderWidth = 1;
                    
                    lastView = button;
                    
                }
                
                UILabel *colorTitleLabel = [UILabel getLabelWithAlignment:1 WithTitle:colorName WithFont:11.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
                [_colorBgView addSubview:colorTitleLabel];
                colorTitleLabel.hidden = YES;
                colorTitleLabel.tag = 100+i;
                colorTitleLabel.adjustsFontSizeToFitWidth = YES;
                [colorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(lastView);
                    make.width.mas_equalTo(IsPhone6_gt?230:180);
                    make.height.mas_equalTo(item_title_height);
                    make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
                }];
                
                if (i == _currentColorIndexToShow) {
                    colorTitleLabel.hidden = NO;
                    _lastSelectedLabel = colorTitleLabel;
                    [ws updateScrollViewContentView];
                }
            }
            
            
            //            item_title_height
        }
        
    }
}

#pragma TitlePagerViewDelegate
- (void)didTouchBWTitle:(NSUInteger)index {
    if (self.selectedSegmentIndex == index) {
        return;
    }
    self.currentIndex = index;
}

- (void)setCurrentIndex:(NSInteger)index {
    _selectedSegmentIndex = index;
    [UIView animateWithDuration:1 animations:^{
         [_segmentBtn adjustTitleViewByIndex:index];
    } completion:^(BOOL finished) {
       //
    }];
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"SegmentIndex",@(_selectedSegmentIndex)]];
    }
}
#pragma mark - Other

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
