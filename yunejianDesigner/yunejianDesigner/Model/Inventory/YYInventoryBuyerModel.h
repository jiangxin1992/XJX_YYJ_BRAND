//
//  YYInventoryBuyerModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol YYInventoryBuyerModel @end

@interface YYInventoryBuyerModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>*buyerId;
@property (strong, nonatomic) NSString <Optional>*buyerName;

@property (strong, nonatomic) NSString <Optional>*buyerLogo;
@property (strong, nonatomic) NSArray <Optional>*orderCodes;

@property (strong, nonatomic) NSString <Optional>*address;//": "广东 江门",
@property (strong, nonatomic) NSString <Optional>*mail;//": "hy_wang0826@163.com",
@property (strong, nonatomic) NSString <Optional>*webUrl;//": "www.baidu.com",
@property (strong, nonatomic) NSString <Optional>*wechatNo;//": "695810552"
@end
