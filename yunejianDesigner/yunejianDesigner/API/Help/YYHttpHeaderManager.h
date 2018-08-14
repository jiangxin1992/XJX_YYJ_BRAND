//
//  YYHttpHeaderManager.h
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYHttpHeaderManager : NSObject

+ (NSDictionary *)buildHeadderWithAction:(NSString *)action params:(NSDictionary *)params;

@end
