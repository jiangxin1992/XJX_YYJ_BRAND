//
//  YYSeller.m
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYSeller.h"

@implementation YYSeller

- (id)copyWithZone:(NSZone *)zone
{
    
    YYSeller *info = [[[self class] allocWithZone:zone] init];
    
    info.email= self.email;
    info.salesmanId = self.salesmanId;
    info.name = self.name;
    info.status = self.status;
    
    return info;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.email forKey:@"email"];
    [coder encodeInteger:self.salesmanId forKey:@"salesmanId"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.status forKey:@"status"];
    
}

- (id)initWithCoder:(NSCoder *) coder
{
    self = [super init];
    if (self)
    {
        self.email = [coder decodeObjectForKey:@"email"];
        self.salesmanId = [coder decodeIntegerForKey:@"salesmanId"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.status = [coder decodeIntegerForKey:@"status"];
    }
    return self;
}

@end
