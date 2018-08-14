//
//  YYColorModel.h
//  Yunejian
//
//  Created by yyj on 15/7/27.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@protocol YYColorModel @end

@interface YYColorModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*name;
@property (strong, nonatomic) NSString <Optional>*value;
@property (strong, nonatomic) NSNumber <Optional>*id;

@property (strong, nonatomic) NSArray <Optional>*imgs;

@property (nonatomic, strong) NSString <Optional>*styleCode;//编号
@property (nonatomic, strong) NSString <Optional>*materials;//材质
@property (nonatomic, strong) NSNumber <Optional>*tradePrice;//批发价
@property (nonatomic, strong) NSNumber <Optional>*retailPrice;//零售价
@property (nonatomic, strong) NSNumber <Optional>*stock;//库存数
@property (nonatomic, strong) NSArray <Optional>*sizeStocks;//各尺码库存数

@property (strong, nonatomic) NSNumber <Optional>*isSelect;//临时属性（区分该颜色是否选中）

@end
