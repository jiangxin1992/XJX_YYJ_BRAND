//
//  YYInventoryAllottingModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YYInventoryStyleDemandModel.h"
@protocol YYInventoryAllottingModel @end
@interface YYInventoryAllottingModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>*msgId;//": 1221,
@property (strong, nonatomic) NSString <Optional>*albumImg;//": "http://source.yunejian.com/ufile/20160707/cf4a07f8631647838c12ed80640d72ba",
@property (strong, nonatomic) NSNumber <Optional>*colorId;//": 1515,
@property (strong, nonatomic) NSString <Optional>*colorName;//": "黄色",
@property (strong, nonatomic) NSString <Optional>*colorValue;//": "#FFFF00",
@property (strong, nonatomic) NSArray<YYInventoryStyleDemandModel,Optional, ConvertOnDemand>* demands;//
@property (strong, nonatomic) NSNumber <Optional>*hasRead;//": false,
@property (strong, nonatomic) NSArray<YYInventoryStyleDemandModel,Optional, ConvertOnDemand>* inventories;//
@property (strong, nonatomic) NSString <Optional>*styleCode;//": "WOB507W",
@property (strong, nonatomic) NSNumber <Optional>*styleId;//": 1221,
@property (strong, nonatomic) NSString <Optional>*styleName;//": "简约大气风衣"

@end
