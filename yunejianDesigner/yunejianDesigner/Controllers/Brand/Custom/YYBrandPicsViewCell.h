//
//  YYBrandPicsViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLoopScrollView.h"
#import "SCGIFImageView.h"
@interface YYBrandPicsViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SCLoopScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *connStatusImg;

@property (nonatomic,strong)NSString *logoPath;
@property (nonatomic,strong)NSString *brandName;
@property (nonatomic,copy)NSArray *pics;
-(void)updateUI;
+(float)HeightForCell:(NSInteger )cellWidth;
@end
