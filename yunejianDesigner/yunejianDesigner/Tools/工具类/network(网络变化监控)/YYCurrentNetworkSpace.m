//
//  YYCurrentNetworkSpace.m
//  yunejianDesigner
//
//  Created by chuanjun sun on 2017/9/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYCurrentNetworkSpace.h"

@implementation YYCurrentNetworkSpace

+ (BOOL)isNetwork{
    YYCurrentNetworkSpace *currentNetwork = [YYCurrentNetworkSpace shareModel];
    if (currentNetwork.currentNetwork == kYYNetworkWifi || currentNetwork.currentNetwork == kYYNetworkWWAN) {
        return YES;
    }else{
        return NO;
    }

}

@end
