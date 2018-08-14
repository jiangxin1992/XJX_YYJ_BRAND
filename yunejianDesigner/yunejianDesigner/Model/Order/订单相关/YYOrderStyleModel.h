//
//  YYOrderStyleModel.h
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYSizeModel.h"
#import "YYOrderOneColorModel.h"
#import "YYDateRangeModel.h"
@protocol YYOrderStyleModel @end

@interface YYOrderStyleModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*styleId;//款式ID

@property (strong, nonatomic) NSString <Optional>*albumImg;//款式封面相对地址
@property (strong, nonatomic) NSString <Optional>*name;//款式名称

@property (strong, nonatomic) NSNumber <Optional>*finalPrice;//最后价格
@property (strong, nonatomic) NSNumber <Optional>*originalPrice;//原价
@property (strong, nonatomic) NSNumber <Optional>*retailPrice;//零售价
@property (strong, nonatomic) NSNumber <Optional>*orderAmountMin;//最小起订量
@property (strong, nonatomic) NSString <Optional>*styleCode;//款号

@property (strong, nonatomic) NSNumber <Optional>*styleModifyTime;//服务端快照要用

//该款尺寸列表，显示专用
@property (strong, nonatomic) NSArray<YYSizeModel, Optional,ConvertOnDemand>* sizeNameList;

@property (nonatomic, strong) NSNumber <Optional>*stockEnabled;//是否可使用库存管理
@property (nonatomic, strong) YYDateRangeModel <Optional>*dateRange;

//该款所购买的颜色列表
@property (strong, nonatomic) NSArray<YYOrderOneColorModel, Optional,ConvertOnDemand>* colors;

@property (strong, nonatomic) NSNumber <Optional>*curType;//货币类型
@property (strong, nonatomic) NSNumber <Optional>*seriesId;
@property (strong, nonatomic) NSNumber <Optional>*supportAdd;// 是否支持补货
@property (strong, nonatomic) NSString <Optional>*remark;//款式备注
//tmp
@property (strong, nonatomic) YYDateRangeModel <Optional>*tmpDateRange;
@property (strong, nonatomic) NSString <Optional>*tmpRemark;//款式备注

- (CGFloat)getMinOriginalPrice;
- (CGFloat)getMaxOriginalPrice;
- (CGFloat)getTotalOriginalPrice;

@end
