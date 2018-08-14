//
//  YYUser.m
//  Yunejian
//
//  Created by yyj on 15/7/10.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYUser.h"
#import "UserDefaultsMacro.h"
#import "JpushHandler.h"

#define kYYUsernameKey @"kYYUsernameKey"
#define kYYUserEmailKey @"kYYUserEmailKey"
#define kYYPasswordKey @"kYYPasswordKey"
#define kYYUserTypeKey @"kYYUserTypeKey"
#define kYYUserBrandIDKey @"kYYUserBrandIDKey"
#define kYYUserIdKey @"kYYUserIdKey"
#define kYYUserLogoKey @"kYYUserLogoKey"
#define kYYUserStatusKey @"kYYUserStatusKey"
#define kYYUserNewsKey @"kYYUserNewsKey"

@implementation YYUser
static YYUser *currentUser = nil;

/**
 * 判断当前用户角色是否是brand角色（showroom———>品牌）
 * 判断本地的kTempUserLoginTokenKey对应的有没有值
 * 有值返回true
 * 没有值返回false
 */
+(BOOL)isShowroomToBrand{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:kTempUserLoginTokenKey])
    {
        return YES;
    }
    return NO;
}

/**
 * 获取当前用户token
 * 通过isShowroomToBrand方法，判断是否是brand角色（showroom———>品牌）
 * 如果不是、通过kUserLoginTokenKey获取token
 * 如果是、通过kTempUserLoginTokenKey获取token
 */
+(NSString *)getToken{
    NSString *tokenValue = @"";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([YYUser isShowroomToBrand])
    {
        tokenValue = [userDefaults objectForKey:kTempUserLoginTokenKey];
    }else
    {
        tokenValue = [userDefaults objectForKey:kUserLoginTokenKey];
    }
    return tokenValue;
}
+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        currentUser = [super allocWithZone:zone];
    });
    return currentUser;
}
+ (BOOL )getNewsReadStateWithType:(NSInteger )type
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *typeStr = type==1?@"newHomePage":@"newEdit";
    YYUser *user = [YYUser currentUser];
    NSString *email = user.email;
    if(![NSString isNilOrEmpty:typeStr]&&![NSString isNilOrEmpty:email])
    {
        if([userDefaults objectForKey:kYYUserNewsKey])
        {
            //有值
            if([[userDefaults objectForKey:kYYUserNewsKey] objectForKey:typeStr])
            {
                NSArray *tempArr = [[userDefaults objectForKey:kYYUserNewsKey] objectForKey:typeStr];
                __block BOOL isexit = NO;
                __block NSUInteger tempidx = 0;
                [tempArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([[obj objectForKey:@"email"]isEqualToString:email])
                    {
                        isexit = YES;
                        tempidx = idx;
                        *stop = YES;
                    }
                }];
                if(!isexit)
                {
                    return NO;
                }else
                {
                    return [[[tempArr objectAtIndex:tempidx] objectForKey:@"isread"] boolValue];
                }
            }else
            {
                return NO;
            }
        }else
        {
            return NO;
        }
    }
    return NO;
}
+ (void )saveNewsReadStateWithType:(NSInteger )type
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *typeStr = type==1?@"newHomePage":@"newEdit";
    YYUser *user = [YYUser currentUser];
    NSString *email = user.email;
    if(![NSString isNilOrEmpty:typeStr]&&![NSString isNilOrEmpty:email])
    {
        
        if([userDefaults objectForKey:kYYUserNewsKey])
        {
            //有值
            if([[userDefaults objectForKey:kYYUserNewsKey] objectForKey:typeStr])
            {
                //有值
                NSMutableDictionary *tempDict = [[userDefaults objectForKey:kYYUserNewsKey] mutableCopy];
                NSMutableArray *tempArr = [[[userDefaults objectForKey:kYYUserNewsKey] objectForKey:typeStr] mutableCopy];
                __block BOOL isexit = NO;
                __block NSUInteger tempidx = 0;
                [tempArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(![NSString isNilOrEmpty:[obj objectForKey:@"email"]])
                    {
                        if([[obj objectForKey:@"email"] isEqualToString:email])
                        {
                            isexit = YES;
                            tempidx = idx;
                        }
                    }
                }];
                if(!isexit)
                {
                    [tempArr addObject:@{@"email":email,@"isread":@(YES)}];
                }else
                {
                    BOOL tempisread = [[[tempArr objectAtIndex:tempidx] objectForKey:@"isread"] boolValue];
                    if(!tempisread)
                    {
                        [tempArr replaceObjectAtIndex:tempidx withObject:@{@"email":email,@"isread":@(YES)}];
                    }
                }
                [tempDict setObject:[tempArr copy] forKey:typeStr];
                [userDefaults setObject:tempDict forKey:kYYUserNewsKey];
            }else
            {
                NSMutableDictionary *tempDict = [[userDefaults objectForKey:kYYUserNewsKey] mutableCopy];
                [tempDict setObject:@[@{@"email":email,@"isread":@(YES)}] forKey:typeStr];
                [userDefaults setObject:tempDict forKey:kYYUserNewsKey];
            }
        }else
        {
            [userDefaults setObject:@{typeStr:@[@{@"email":email,@"isread":@(YES)}]} forKey:kYYUserNewsKey];
        }
        [userDefaults synchronize];
    }
}
+ (YYUser *)currentUser
{
    
    if (!currentUser) {
        currentUser = [[self alloc] init];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    currentUser.name = [userDefaults objectForKey:kYYUsernameKey];
    currentUser.email = [userDefaults objectForKey:kYYUserEmailKey];
    currentUser.password = [userDefaults objectForKey:kYYPasswordKey];
    currentUser.userType = [userDefaults integerForKey:kYYUserTypeKey];
    currentUser.brandId = [userDefaults objectForKey:kYYUserBrandIDKey];
    currentUser.userId = [userDefaults objectForKey:kYYUserIdKey];
    currentUser.logo = [userDefaults objectForKey:kYYUserLogoKey];
    currentUser.status = [userDefaults objectForKey:kYYUserStatusKey];
    return currentUser;
}

- (void)saveUserWithEmail:(NSString *)email username:(NSString *)username password:(NSString *)password userType:(NSInteger)userType userId:(NSString*)userId logo:(NSString *)logo status:(NSString*)status brandId:(NSString *)brandId{
    currentUser.name = username;
    currentUser.email = email;
    currentUser.password = password;
    currentUser.userType = userType;
    currentUser.userId = userId;
    currentUser.logo = logo;
    currentUser.status = status;
    currentUser.brandId = brandId;
    [self saveUserData];
//    [JpushHandler sendUserIdToAlias];
    [JpushHandler sendTagsAndAlias];
}

- (void)saveUserData{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_name forKey:kYYUsernameKey];
    [userDefaults setObject:_email forKey:kYYUserEmailKey];
    [userDefaults setObject:_password forKey:kYYPasswordKey];
    [userDefaults setInteger:_userType forKey:kYYUserTypeKey];
    [userDefaults setObject:_brandId forKey:kYYUserBrandIDKey];
    [userDefaults setObject:_userId forKey:kYYUserIdKey];
    [userDefaults setObject:_logo forKey:kYYUserLogoKey];
    [userDefaults setObject:_status forKey:kYYUserStatusKey];

    [userDefaults synchronize];
    YYUser *user = [YYUser currentUser];
    NSLog(@"user=%@",user);
}


- (void)loginOut{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:kYYUsernameKey];
    [userDefaults setObject:nil forKey:kYYUserEmailKey];
    [userDefaults setObject:nil forKey:kYYPasswordKey];
    [userDefaults setObject:nil forKey:kYYUserBrandIDKey];
    [userDefaults setInteger:-1 forKey:kYYUserTypeKey];
    [userDefaults setObject:nil forKey:kYYUserIdKey];
    [userDefaults setObject:nil forKey:kYYUserLogoKey];
    
    [userDefaults setObject:nil forKey:kUserLoginTokenKey];
    [userDefaults setObject:nil forKey:kScrtKey];
    [userDefaults setObject:nil forKey:kYYUserStatusKey];
    
    [userDefaults synchronize];
    [JpushHandler sendEmptyAlias];
}

/**
 * 清空 kTempUserLoginTokenKey、kTempBrandID
 * 其实就是使brand角色（showroom———>品牌）登出
 */
+ (void )removeTempUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:nil forKey:kTempUserLoginTokenKey];
    [userDefaults setObject:nil forKey:kTempBrandID];
    
    [userDefaults synchronize];
}

@end
