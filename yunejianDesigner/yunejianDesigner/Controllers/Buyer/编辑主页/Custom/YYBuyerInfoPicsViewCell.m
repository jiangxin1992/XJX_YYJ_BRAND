//
//  YYBuyerInfoPicsViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerInfoPicsViewCell.h"
#import "SCLoopScrollView.h"
#import "TitlePagerView.h"
#import "YYUser.h"
#import "SCGIFImageView.h"
@interface YYBuyerInfoPicsViewCell ()<TitlePagerViewDelegate>{
    NSMutableArray *tmpImagArr;
}
@property (weak, nonatomic) IBOutlet SCLoopScrollView *scrollView;
@property (weak, nonatomic) IBOutlet TitlePagerView *segmentBtn;
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@end

@implementation YYBuyerInfoPicsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateUI{
    self.segmentBtn.font = [UIFont boldSystemFontOfSize:15];
    self.segmentBtn.pageIndicatorHeight = 4;
    NSArray *titleArray = @[NSLocalizedString(@"关于买手店",nil),NSLocalizedString(@"联系买手店",nil)];
    [self.segmentBtn addObjects:titleArray];
    self.segmentBtn.delegate = self;
    YYUser *user = [YYUser currentUser];
    _nameLabel.text =user.name;
    NSString *_city = [LanguageManager isEnglishLanguage]?_homeInfoModel.cityEn:_homeInfoModel.city;
    _cityLabel.text = _city;
    _logoImageView.layer.cornerRadius = CGRectGetHeight(_logoImageView.frame)/2;
    _logoImageView.layer.masksToBounds = YES;
    NSString *_logoPath = _homeInfoModel.logoPath;
    sd_downloadWebImageWithRelativePath(NO, _logoPath, _logoImageView, kLogoCover, 0);
    
    [self updateScrollView];
}

-(void)updateScrollView{
    NSArray *_pics = _homeInfoModel.storeImgs;
    if(_pics==nil || [_pics count] == 0){
        return;
    }
    
    NSInteger count = [_pics count];
    if(tmpImagArr == nil){
        tmpImagArr = [[NSMutableArray alloc] initWithCapacity:count];
        if(count > 0){
            for(int i = 0 ; i < count; i++){
                NSString *imageName =[NSString stringWithFormat:@"%@",[_pics objectAtIndex:i]];
                NSString *_imageRelativePath = imageName;
                NSString *imgInfo = [NSString stringWithFormat:@"%@%@|%@",_imageRelativePath,kLookBookImage,@""];
                [tmpImagArr addObject:imgInfo];
            }
        }
        _scrollView.images = tmpImagArr;
        [_scrollView show:^(NSInteger index) {
            
        } finished:^(NSInteger index) {
        }];
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
    WeakSelf(ws);
    [UIView animateWithDuration:1 animations:^{
        [ws.segmentBtn adjustTitleViewByIndex:index];
    } completion:^(BOOL finished) {
        //
    }];
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[@"SegmentIndex",@(_selectedSegmentIndex)]];
    }
}

@end
