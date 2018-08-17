//
//  YYInventoryOrderModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol YYInventoryOrderModel @end
@interface YYInventoryOrderModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>*amount;//": 30,
@property (strong, nonatomic) NSNumber <Optional>*curType;//": 0,
@property (strong, nonatomic) NSNumber <Optional>*finalTotalPrice;//": 43290,
@property (strong, nonatomic) NSString <Optional>*orderCode;//": "1148035479528",
@property (strong, nonatomic) NSNumber <Optional>*orderCreateTime;//": 1470279659000,
@property (strong, nonatomic) NSNumber <Optional>*orderId;//": 6133,
@property (strong, nonatomic) NSNumber <Optional>*styleCount;//": 6
@end
