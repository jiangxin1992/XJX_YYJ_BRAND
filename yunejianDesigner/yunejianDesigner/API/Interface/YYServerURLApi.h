//
//  YYServerURLApi.h
//  Yunejian
//
//  Created by Apple on 15/12/29.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYServerURLApi : NSObject
+(void)getAppServerURLWidth:(void (^)(NSString *serverURL,BOOL isNeedUpdate,NSError *error))block;
@end
