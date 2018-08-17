//
//  YYMessageUnreadModel.h
//  yunejianDesigner
//
//  Created by Victor on 2018/3/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class YYMessageButton;

@interface YYMessageUnreadModel : JSONModel

@property (nonatomic, strong) NSNumber <Optional>*orderAmount;//未读订单消息数量
@property (nonatomic, strong) NSNumber <Optional>*connAmount;//未读合作消息数量
@property (nonatomic, strong) NSNumber <Optional>*newsAmount;//未读新闻消息数量
@property (nonatomic, strong) NSNumber <Optional>*personalMessageAmount;//未读私信消息数量
@property (nonatomic, strong) NSNumber <Optional>*skuAmount;//未读库存消息数量
@property (nonatomic, strong) NSString <Optional>*stockStatus;//库存开通状态（VOID_未申请过,INIT_申请中,NORMAL_已开通,CLOSED_已关闭）

- (void)cleanUnreadMessageAmount;

- (void)setUnreadMessageAmount:(YYMessageButton *)messageButton;

@end
