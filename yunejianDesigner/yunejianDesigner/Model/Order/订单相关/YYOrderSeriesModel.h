//
//  YYOrderSeriesModel.h
//  Yunejian
//
//  Created by Apple on 16/5/18.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "JSONModel.h"
@protocol YYOrderSeriesModel @end

@interface YYOrderSeriesModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>*seriesId;//系列编号
@property (strong, nonatomic) NSString <Optional>*name;//
@property (nonatomic, strong) NSString <Optional>*note;//现货发货备注
@property (strong, nonatomic) NSNumber <Optional>*orderAmountMin;
@property (strong, nonatomic) NSNumber <Optional>*supplyStatus;
@end
