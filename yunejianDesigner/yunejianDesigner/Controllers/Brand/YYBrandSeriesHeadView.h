//
//  YYBrandSeriesHeadView.h
//  yunejianDesigner
//
//  Created by yyj on 2018/1/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBrandSeriesHeadView : UIView

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) NSInteger selectCount;

@property (nonatomic,assign) NSComparisonResult orderDueCompareResult;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak, nonatomic) id<YYTableCellDelegate>  delegate;

-(void)updateUI;

@end
