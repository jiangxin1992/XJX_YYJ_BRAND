//
//  YYNewStyleDetailCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/3/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderStyleModel, YYOrderOneInfoModel;
#import "YYOrderSeriesModel.h"

@interface YYNewStyleDetailCell : UITableViewCell<YYTableCellDelegate>

@property(nonatomic,strong) YYOrderStyleModel *orderStyleModel;
@property(nonatomic,strong) YYOrderOneInfoModel *orderOneInfoModel;
@property (nonatomic, strong) YYOrderSeriesModel *orderSeriesModel;
@property (nonatomic, assign) BOOL hiddenTopHeader;
@property (nonatomic,strong) NSMutableArray *menuData;
@property(nonatomic,assign) BOOL showRemarkButton;//备注
@property(nonatomic,assign) NSInteger isModifyNow;//当前是否是修改状态0 没有修改  1购物车 2购物车编辑 3订单修改 4订单失效 5追单
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,weak)id<YYTableCellDelegate> delegate;
@property(nonatomic,assign) NSInteger selectTaxType;
@property (assign, nonatomic) BOOL isAppendOrder;

- (void)updateUI;

+ (float)CellHeight:(NSInteger)num showHelpFlag:(BOOL)isShow showTopHeader:(BOOL)isShowHeader;

@end
