//
//  YYInventoryDetailStyleInfoCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYInventoryDetailStyleInfoCell.h"

#import "TitlePagerView.h"
#import "SCGIFImageView.h"

@interface YYInventoryDetailStyleInfoCell()<TitlePagerViewDelegate>
@property (weak, nonatomic) IBOutlet SCGIFImageView *styleImageView;
@property (weak, nonatomic) IBOutlet UILabel *styleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet SCGIFImageView *colorImageView;
@property (weak, nonatomic) IBOutlet TitlePagerView *segmentBtn;
@property (weak, nonatomic) IBOutlet UILabel *styleCodeLabel;

@end
@implementation YYInventoryDetailStyleInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *imageRelativePath = _allottingModel.albumImg;
    sd_downloadWebImageWithRelativePath(NO, imageRelativePath, _styleImageView, kStyleCover, 0);
    _styleImageView.layer.cornerRadius = 2.5;
    _styleImageView.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
    _styleImageView.layer.borderWidth = 1;
    _styleImageView.layer.masksToBounds = YES;
    
    _styleCodeLabel.text = _allottingModel.styleCode;
    _styleNameLabel.text = _allottingModel.styleName;
    _colorLabel.text = _allottingModel.colorName;
    NSString *colorValue = _allottingModel.colorValue;
    _colorImageView.layer.borderWidth = 1;
    _colorImageView.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;;
    if (colorValue) {
        if ([colorValue hasPrefix:@"#"] && [colorValue length] == 7) {
            //16进制的色值
            UIColor *color = [UIColor colorWithHex:[colorValue substringFromIndex:1]];
            [_colorImageView setImage:[UIColor createImageWithColor:color]];
        }else{
            //图片
            NSString *imageRelativePath = colorValue;
            if(imageRelativePath)
                sd_downloadWebImageWithRelativePath(NO, imageRelativePath, _colorImageView, kStyleColorImageCover, 0);
        }
    }
    
    self.segmentBtn.font = [UIFont systemFontOfSize:15];
    NSArray *titleArray = @[NSLocalizedString(@"补货需求",nil),NSLocalizedString(@"收到库存",nil)];

    self.segmentBtn.pageIndicatorHeight = 4;
    float titlePagerViewWidth= [TitlePagerView calculateTitleWidth:titleArray withFont:[UIFont systemFontOfSize:15] ];
    float titlePagerViewSpace = SCREEN_WIDTH - 140 - titlePagerViewWidth;
    self.segmentBtn.dynamicTitlePagerViewTitleSpace= MIN(titlePagerViewSpace,70);
    [self.segmentBtn addObjects:titleArray];
    self.segmentBtn.delegate = self;
    
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

@end
