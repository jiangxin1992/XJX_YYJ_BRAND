//
//  YYShoppingViewController.h
//  Yunejian
//
//  Created by Apple on 15/7/31.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYStyleInfoModel,YYOpusSeriesModel,YYOrderInfoModel,YYOpusStyleModel,YYBrandSeriesToCartTempModel;

@interface YYShoppingViewController : UIViewController

@property (nonatomic,copy) void (^seriesChooseBlock)(YYBrandSeriesToCartTempModel *brandSeriesToCardTempModel);
@property (nonatomic,assign) BOOL isFromSeries;//是否从系列中过来

@property (nonatomic, assign) BOOL isModifyOrder;
@property (nonatomic, assign) BOOL isOnlyColor;//默认为NO
//款式详情 两个只会出现一个。看当前数据有哪个
@property (nonatomic, strong) YYStyleInfoModel *styleInfoModel;
@property (nonatomic, strong) YYOpusStyleModel *opusStyleModel;
//系列信息
@property (nonatomic, strong) YYOpusSeriesModel *opusSeriesModel;

@end
