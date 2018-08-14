//
//  YYAddress.m
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYAddress.h"

@implementation YYAddress

- (id)copyWithZone:(NSZone *)zone
{
    
    YYAddress *info = [[[self class] allocWithZone:zone] init];
    
    info.detailAddress= self.detailAddress;
    info.receiverName = self.receiverName;
    info.receiverPhone = self.receiverPhone;
    info.defaultShipping = self.defaultShipping;
    info.addressId = self.addressId;
    info.defaultBilling = self.defaultBilling;
    
    info.zipCode = self.zipCode;
    
    info.nation = self.nation;
    info.province = self.province;
    info.city = self.city;
    
    info.nationEn = self.nationEn;
    info.provinceEn = self.provinceEn;
    info.cityEn = self.cityEn;
    
    info.nationId = self.nationId;
    info.provinceId = self.provinceId;
    info.cityId = self.cityId;
    
    return info;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.addressId forKey:@"addressId"];
    [coder encodeObject:self.detailAddress forKey:@"detailAddress"];
    [coder encodeObject:self.receiverName forKey:@"receiverName"];
    [coder encodeObject:self.receiverPhone forKey:@"receiverPhone"];
    [coder encodeBool:self.defaultShipping forKey:@"defaultShipping"];
    [coder encodeBool:self.defaultBilling forKey:@"defaultBilling"];
    
    [coder encodeObject:self.zipCode forKey:@"zipCode"];
    
    [coder encodeObject:self.nation forKey:@"nation"];
    [coder encodeObject:self.province forKey:@"province"];
    [coder encodeObject:self.city forKey:@"city"];
    [coder encodeObject:self.nationEn forKey:@"nationEn"];
    [coder encodeObject:self.provinceEn forKey:@"provinceEn"];
    [coder encodeObject:self.cityEn forKey:@"cityEn"];
    [coder encodeObject:self.nationId forKey:@"nationId"];
    [coder encodeObject:self.provinceId forKey:@"provinceId"];
    [coder encodeObject:self.cityId forKey:@"cityId"];
    
}

- (id)initWithCoder:(NSCoder *) coder
{
    self = [super init];
    if (self)
    {
        self.addressId = [coder decodeObjectForKey:@"addressId"];
        self.detailAddress = [coder decodeObjectForKey:@"detailAddress"];
        self.receiverName = [coder decodeObjectForKey:@"receiverName"];
        self.receiverPhone = [coder decodeObjectForKey:@"receiverPhone"];
        self.defaultShipping = [coder decodeBoolForKey:@"defaultShipping"];
        self.defaultBilling = [coder decodeBoolForKey:@"defaultBilling"];
        
        self.zipCode = [coder decodeObjectForKey:@"zipCode"];
        
        self.nation = [coder decodeObjectForKey:@"nation"];
        self.province = [coder decodeObjectForKey:@"province"];
        self.city = [coder decodeObjectForKey:@"city"];
        self.nationEn = [coder decodeObjectForKey:@"nationEn"];
        self.provinceEn = [coder decodeObjectForKey:@"provinceEn"];
        self.cityEn = [coder decodeObjectForKey:@"cityEn"];
        self.nationId = [coder decodeObjectForKey:@"nationId"];
        self.provinceId = [coder decodeObjectForKey:@"provinceId"];
        self.cityId = [coder decodeObjectForKey:@"cityId"];
    }
    return self;
}

@end
