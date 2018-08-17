//
//  YYPackingListColorModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYPackingListSizeModel.h"

@interface YYPackingListColorModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*colorId;//颜色id
@property (strong, nonatomic) NSString <Optional>*colorName;//颜色名称
@property (strong, nonatomic) NSString <Optional>*colorValue;//色值
@property (strong, nonatomic) NSArray <YYPackingListSizeModel, Optional,ConvertOnDemand>*sizes;//颜色下尺码明细
@property (strong, nonatomic) NSString <Optional>*styleImg;//款式图片
@property (strong, nonatomic) NSString <Optional>*styleCode;//款号

@end
