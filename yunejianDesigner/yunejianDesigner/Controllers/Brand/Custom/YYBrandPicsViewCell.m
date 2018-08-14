//
//  YYBrandPicsViewCell.m
//  YunejianBuyer
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandPicsViewCell.h"

#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

@implementation YYBrandPicsViewCell{
    NSMutableArray *tmpImagArr;
}
static NSInteger curCellWidth;
-(void)updateUI{
    _nameLabel.text = _brandName;
    
    _logoImageView.layer.cornerRadius = CGRectGetHeight(_logoImageView.frame)/2;
    //_logoImageView.layer.borderColor = [UIColor colorWithHex:kDefaultImageColor].CGColor;
    //_logoImageView.layer.borderWidth = 3;
    _logoImageView.layer.masksToBounds = YES;
    sd_downloadWebImageWithRelativePath(NO, _logoPath, _logoImageView, kLogoCover, 0);
    
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    //UIView *superView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    //[MBProgressHUD showHUDAddedTo:superView animated:YES];
    //float curCellHeight =  (float)curCellWidth*260/375;
    //[_scrollView setConstraintConstant:curCellHeight forAttribute:NSLayoutAttributeHeight];

    //_scrollView.layer.borderWidth = 1;
    //_scrollView.layer.borderColor = kBorderColor.CGColor;
    [self updateScrollView];
}

-(void)updateScrollView{
    if(_pics==nil || [_pics count] == 0){
        _pageControl.hidden = YES;
        return;
    }
    _pageControl.hidden = NO;

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
        
    
//    _scrollView.defaultImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
    _scrollView.images = tmpImagArr;
    __block UIPageControl *weakpageControl = _pageControl;
    _pageControl.numberOfPages = [tmpImagArr count];
    [_scrollView show:^(NSInteger index) {
        
    } finished:^(NSInteger index) {
        weakpageControl.hidden = NO;
        _pageControl.currentPage = index;
    }];
    }
}

+(float)HeightForCell:(NSInteger )cellWidth{
    //375 260 350
    curCellWidth = cellWidth;
    float curCellHeight =  (float)curCellWidth*260/375;
    
    return 350 + curCellHeight-260;
}
@end
