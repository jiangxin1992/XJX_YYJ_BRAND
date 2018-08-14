//
//  YYSeriesInfoViewCell.h
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYDateRangeModel.h"

@class YYSeriesInfoModel;

@interface YYSeriesInfoViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger selectCount;

@property (nonatomic, strong) YYSeriesInfoModel *seriesModel;
@property (nonatomic, copy) NSString *seriesDescription;
@property (strong, nonatomic) NSArray<Optional,YYDateRangeModel>*dateRanges;//时间波段
@property (strong, nonatomic) YYDateRangeModel *selectDateRange;
@property (assign, nonatomic) NSInteger selectTaxType;
@property (nonatomic) BOOL isDetail;

@property (nonatomic,assign) NSComparisonResult orderDueCompareResult;

@property (weak, nonatomic) id<YYTableCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)updateUI;

+ (float)cellHeight:(NSString *)desc isDetail:(BOOL)detail showMinPrice:(BOOL)isShow;

@end
