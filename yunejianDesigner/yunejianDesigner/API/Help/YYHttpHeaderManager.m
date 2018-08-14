//
//  YYHttpHeaderManager.m
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYHttpHeaderManager.h"
#import "UserDefaultsMacro.h"
#import "YYUser.h"

@implementation YYHttpHeaderManager


+ (NSDictionary *)buildHeadderWithAction:(NSString *)action params:(NSDictionary *)params{
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *tokenValue = [YYUser getToken];

    [headers setObject:kYYCurrentVersion forKey:@"tbPhoneDesignerAppVersion"];
    if (tokenValue) {
        [headers setObject:tokenValue forKey:@"token"];
    }
    //cn和en
    if([LanguageManager currentLanguageIndex] == 0){
        [headers setObject:@"en" forKey:@"lang"];
    }else{
        [headers setObject:@"cn" forKey:@"lang"];
    }
    if (params) {
        [headers setValuesForKeysWithDictionary:params];
    }
    
    return headers;
}

@end
