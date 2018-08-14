//
//  YYSeriesInfoDetailModel.h
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYDateRangeModel.h"
#import "YYOpusSeriesModel.h"
#import "YYSeriesInfoModel.h"

@interface YYSeriesInfoDetailModel : JSONModel

@property (strong, nonatomic) NSArray <Optional, ConvertOnDemand>* authBuyerIdList;
@property (strong, nonatomic) NSString <Optional>*brandName;
@property (strong, nonatomic) NSString <Optional>*brandDescription;
@property (strong, nonatomic) NSNumber <Optional>*lookBookId;
@property (strong, nonatomic) NSArray <Optional, YYDateRangeModel>*dateRanges;//时间波段
@property (strong, nonatomic) YYSeriesInfoModel <Optional>*series;

- (YYOpusSeriesModel *)toOpusSeriesModel;

@end
