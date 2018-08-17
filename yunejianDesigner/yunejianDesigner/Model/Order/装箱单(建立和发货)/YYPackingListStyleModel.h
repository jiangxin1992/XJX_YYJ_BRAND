//
//  YYPackingListStyleModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYPackingListColorModel.h"

@protocol YYPackingListStyleModel @end

@interface YYPackingListStyleModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*seriesId;//系列id
@property (strong, nonatomic) NSString <Optional>*seriesName;//系列名称
@property (strong, nonatomic) NSNumber <Optional>*styleId;//款式id
@property (strong, nonatomic) NSString <Optional>*styleName;//款式名称
@property (strong, nonatomic) YYPackingListColorModel <Optional>*color;//款式下颜色明细

@end
