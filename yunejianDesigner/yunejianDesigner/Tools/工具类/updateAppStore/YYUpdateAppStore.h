//
//  Update_AppStore.h
//  FT
//
//  Created by yourentang on 15/8/4.
//  Copyright (c) 2015年 yourentang. All rights reserved.
//  App Store版应用更新方法，直接打开ituns让用户去更新

#import <Foundation/Foundation.h>

@interface YYUpdateAppStore : NSObject 

/*
  Checks the installed version of your application against the version currently available on the iTunes store.
  If a newer version exists in the AppStore, it prompts the user to update your app.
 */
+ (void)checkVersion;

@end
