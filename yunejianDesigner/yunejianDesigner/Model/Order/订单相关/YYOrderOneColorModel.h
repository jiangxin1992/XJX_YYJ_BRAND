//
//  YYOrderOneColorModel.h
//  Yunejian
//
//  Created by yyj on 15/8/6.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYOrderSizeModel.h"

@protocol YYOrderOneColorModel @end

@interface YYOrderOneColorModel : JSONModel

@property (nonatomic, strong) NSNumber <Optional>*isColorSelect;//是否锁定color

@property (strong, nonatomic) NSNumber <Optional>*colorId;//颜色ID
@property (strong, nonatomic) NSString <Optional>*name;//颜色名称
@property (strong, nonatomic) NSString <Optional>*materials;//材料
@property (strong, nonatomic) NSString <Optional>*value;//颜色值，如果以#开头，是16进制色值，否则是图片相对地址
@property (nonatomic, strong) NSString <Optional>*styleCode;
@property (nonatomic, strong) NSArray <Optional>*imgs;
@property (nonatomic, strong) NSNumber <Optional>*originalPrice;//批发价
@property (nonatomic, strong) NSNumber <Optional>*finalPrice;//折扣价
@property (nonatomic, strong) NSNumber <Optional>*retailPrice;//零售价

@property (nonatomic, strong) NSNumber <Optional>*curType;//货币类型

//该款颜色，所购买的尺寸情况
@property (strong, nonatomic) NSArray<YYOrderSizeModel, Optional,ConvertOnDemand>* sizes;

- (NSInteger)getTotalAmount;

@end
