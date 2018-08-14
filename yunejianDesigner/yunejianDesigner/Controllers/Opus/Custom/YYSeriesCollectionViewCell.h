//
//  YYSeriesCollectionViewCell.h
//  Yunejian
//
//  Created by yyj on 15/9/4.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YYSeriesCollectionViewCellDelegate
-(void)operateHandler:(NSInteger)section androw:(NSInteger)row type:(NSString*)type;
-(UIView *)getview;
@end
@interface YYSeriesCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *startBtn;//设置隐私状态

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *imageRelativePath;
@property (nonatomic,strong) NSString *order;
@property (nonatomic,strong) NSString *styleAmount;
@property (nonatomic,weak)id<YYSeriesCollectionViewCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger authType;
@property (nonatomic,assign) NSInteger supplyStatus;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) NSNumber *whiteAuthCount;
@property (nonatomic,assign) NSComparisonResult compareResult;
- (void)updateUI;
+ (float)cellHeight:(NSInteger) cellWidth;
@end
