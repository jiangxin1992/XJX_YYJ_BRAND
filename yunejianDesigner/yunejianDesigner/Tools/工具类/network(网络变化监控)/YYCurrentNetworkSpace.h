//
//  YYCurrentNetworkSpace.h
//  yunejianDesigner
//
//  Created by chuanjun sun on 2017/9/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "CJRootModel.h"
//AFNetworkReachabilityStatusUnknown     = 未知
//AFNetworkReachabilityStatusNotReachable   = 没有网络
//AFNetworkReachabilityStatusReachableViaWWAN = 手机网络
//AFNetworkReachabilityStatusReachableViaWiFi = WIFI

typedef NS_ENUM(NSInteger, currentNetwork) {
    /** 未知网络状态 */
    kYYNetworkUnknow = 0,
    /** 无网络状态 */
    kYYNetworkNotReachable = 1,
    /** 蜂窝网络状态 */
    kYYNetworkWWAN = 2,
    /** Wi-Fi网络状态 */
    kYYNetworkWifi = 3,
};

@interface YYCurrentNetworkSpace : CJRootModel

/** 当前网络状态 */
@property (nonatomic, assign) currentNetwork currentNetwork;

/**
 * 有网返回yes，无网返回no，不考虑是否是Wi-Fi
 * @return 网络状态
 */
+ (BOOL)isNetwork;

@end
