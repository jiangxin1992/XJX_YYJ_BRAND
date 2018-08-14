//
//  jpushHandler.h
//  YunejianBuyer
//
//  Created by Apple on 16/5/3.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPUSHService.h"
@interface JpushHandler : NSObject
+ (void)setupJpush:(NSDictionary *)launchOptions;
+ (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias;
+ (NSString *)logSet:(NSSet *)dic;
//+ (void)sendUserIdToAlias;
+ (void)sendTagsAndAlias;
+ (void)sendEmptyAlias;
+ (void)handleUserInfo:(NSDictionary *)userInfo;
+ (void)setLocalNotification;
@end
