//
//  YYUserInfo.m
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYUserInfo.h"

@implementation YYUserInfo

- (id)copyWithZone:(NSZone *)zone
{

    YYUserInfo *info = [[[self class] allocWithZone:zone] init];
    
    info.userId = self.userId;
    info.email= self.email;
    info.username = self.username;
    info.phone = self.phone;
    info.brandName = self.brandName;
    info.brandLogoName = self.brandLogoName;
    info.userType = self.userType;
    info.addressArray = self.addressArray;

    return info;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.userId forKey:@"userId"];
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.brandName forKey:@"brandName"];
    [coder encodeObject:self.brandLogoName forKey:@"brandLogoName"];
    [coder encodeInteger:self.userType forKey:@"userType"];
    [coder encodeObject:self.addressArray forKey:@"addressArray"];

}

- (id)initWithCoder:(NSCoder *) coder
{
    self = [super init];
    if (self)
    {
        self.userId = [coder decodeObjectForKey:@"userId"];
        self.email = [coder decodeObjectForKey:@"email"];
        self.username = [coder decodeObjectForKey:@"username"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.brandName = [coder decodeObjectForKey:@"brandName"];
        self.brandLogoName = [coder decodeObjectForKey:@"brandLogoName"];
        self.userType = [coder decodeIntegerForKey:@"chapterID"];
        self.addressArray = [coder decodeObjectForKey:@"addressArray"];
    }
    return self;
}

@end
