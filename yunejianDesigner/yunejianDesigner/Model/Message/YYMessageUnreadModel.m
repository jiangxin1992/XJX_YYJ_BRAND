//
//  YYMessageUnreadModel.m
//  yunejianDesigner
//
//  Created by Victor on 2018/3/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYMessageUnreadModel.h"

@implementation YYMessageUnreadModel

- (void)cleanUnreadMessageAmount {
    self.orderAmount = @(0);
    self.connAmount = @(0);
    self.inventoryAmount = @(0);
    self.newsAmount = @(0);
    self.personalMessageAmount = @(0);
    self.skuAmount = @(0);
}

@end
