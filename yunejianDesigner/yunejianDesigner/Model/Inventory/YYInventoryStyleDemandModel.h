//
//  YYInventoryDemandModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol YYInventoryStyleDemandModel @end

@interface YYInventoryStyleDemandModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>*id;//": 24,

@property (strong, nonatomic) NSNumber <Optional>*amount;//": 24,
@property (strong, nonatomic) NSNumber <Optional>*retailerCount;//": 1,
@property (strong, nonatomic) NSNumber <Optional>*sizeId;//": 17,
@property (strong, nonatomic) NSString <Optional>*sizeName;//": "2",
@property (strong, nonatomic) NSNumber <Optional>*sortId;//": 17
//详情里信息
@property (strong, nonatomic) NSNumber <Optional>*created;//": 24,
@property (strong, nonatomic) NSNumber <Optional>*buyerId;//": 24,
@property (strong, nonatomic) NSString <Optional>*buyerLogo;//": "2",
@property (strong, nonatomic) NSString <Optional>*buyerName;//": "2",
@property (strong, nonatomic) NSNumber <Optional>*status;//": 17

@end
