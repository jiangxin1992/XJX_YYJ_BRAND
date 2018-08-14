//
//  YYDetailContentTopViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/3/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCLoopScrollView.h"
#import "YYStyleInfoModel.h"
#import "YYOpusStyleModel.h"
#import "TitlePagerView.h"

@interface YYDetailContentTopViewCell : UITableViewCell<TitlePagerViewDelegate>

@property (weak, nonatomic) IBOutlet SCLoopScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *colorBgView;
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stylePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleTradePriceLabel;
@property (weak, nonatomic) IBOutlet TitlePagerView *segmentBtn;

@property (nonatomic,strong) YYStyleInfoModel *styleInfoModel;
@property(nonatomic,strong)YYOpusStyleModel *currentOpusStyleModel;
@property(nonatomic) NSInteger currentColorIndexToShow;
@property(nonatomic) NSInteger selectedSegmentIndex;
@property(nonatomic,weak)id<YYTableCellDelegate> delegate;
@property(nonatomic,copy)NSIndexPath * indexPath;
@property(nonatomic,assign)NSInteger selectTaxType;

- (void)updateUI;
+ (float)cellHeight:(NSInteger)arrayCount;

@end
