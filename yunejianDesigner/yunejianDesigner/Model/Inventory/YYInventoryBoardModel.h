//
//  YYInventoryBoardModel.h
//  YunejianBuyer
//
//  Created by Apple on 16/8/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"
#import "YYOrderSizeModel.h"
@protocol YYInventoryBoardModel @end
@interface YYInventoryBoardModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*albumImg;//": "http://source.yunejian.com/ufile/20160707/cf4a07f8631647838c12ed80640d72ba",
@property (strong, nonatomic) NSString <Optional>*brandName;//": "YCO System",
@property (strong, nonatomic) NSString <Optional>*brandLogo;
@property (strong, nonatomic) NSNumber <Optional>*colorId;//": 1515,
@property (strong, nonatomic) NSString <Optional>*colorName;//": "黄色",
@property (strong, nonatomic) NSString <Optional>*colorValue;//": "#FFFF00",
@property (strong, nonatomic) NSNumber <Optional>*designerId;//": 18,
@property (strong, nonatomic) NSNumber <Optional>*hasInventory;//": true,
@property (strong, nonatomic) NSNumber <Optional>*hasRead;//": false,
@property (strong, nonatomic) NSNumber <Optional>*modified;//": 1472022431000,
@property (strong, nonatomic) NSNumber <Optional>*msgId;//": 7,
@property (strong, nonatomic) NSArray<YYOrderSizeModel, Optional,ConvertOnDemand>* sizes;
@property (strong, nonatomic) NSString <Optional>*styleCode;//": "WOB507W",
@property (strong, nonatomic) NSNumber <Optional>*styleId;//": 1221,
@property (strong, nonatomic) NSString <Optional>*styleName;//": "简约大气风衣"
@property (strong, nonatomic) NSString <Optional>*seriesName;


@property (strong, nonatomic) NSNumber <Optional>*seriesId;
@property (strong, nonatomic) NSNumber <Optional>*orderAmountMin;
@property (strong, nonatomic) NSNumber <Optional>*supplyStatus;
//0 已发布 1 已删除 2草稿
@property (strong, nonatomic) NSNumber <Optional>*seriesStatus;



@end
