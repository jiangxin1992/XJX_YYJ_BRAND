//
//  YYUserHomePageModel.m
//  Yunejian
//
//  Created by yyj on 2016/12/16.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "YYUserHomePageModel.h"

@implementation YYUserHomePageModel
-(NSString *)getuserContactInfosWithType:(UserContactInfoType )type
{
    if(self)
    {
        if(self.userContactInfos)
        {
            NSInteger _contactType=type==UserContactInfoEmail?0:type==UserContactInfoPhone?1:type==UserContactInfoQQ?2:type==UserContactInfoWechat?3:-1;
            if(_contactType>=0)
            {
                __block NSString *_contactValue=nil;
                [self.userContactInfos enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([[obj objectForKey:@"contactType"] integerValue]==_contactType)
                    {
                        _contactValue=[obj objectForKey:@"contactValue"];
                        *stop=YES;
                    }
                }];
                if(_contactValue)
                {
                    return _contactValue;
                }
                return @"";
            }
        }
    }
    return @"";
}
@end
