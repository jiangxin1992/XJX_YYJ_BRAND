//
//  YYMessageUnreadModel.h
//  yunejianDesigner
//
//  Created by Victor on 2018/3/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YYMessageUnreadModel : JSONModel

@property (nonatomic, strong) NSNumber <Optional>*orderAmount;
@property (nonatomic, strong) NSNumber <Optional>*connAmount;
@property (nonatomic, strong) NSNumber <Optional>*inventoryAmount;
@property (nonatomic, strong) NSNumber <Optional>*newsAmount;
@property (nonatomic, strong) NSNumber <Optional>*personalMessageAmount;
@property (nonatomic, strong) NSNumber <Optional>*skuAmount;
@property (nonatomic, strong) NSString <Optional>*stockStatus;//StockStatus

- (void)cleanUnreadMessageAmount;

@end
