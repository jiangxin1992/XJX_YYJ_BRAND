//
//  YYAddress.h
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYAddress : NSObject<NSCopying,NSCoding>

@property (strong, nonatomic) NSString *detailAddress;
@property (strong, nonatomic) NSString *receiverName;
@property (strong, nonatomic) NSString *receiverPhone;
@property (assign, nonatomic) BOOL defaultShipping;
@property (assign, nonatomic) BOOL defaultBilling;

@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSString *street;

@property (strong, nonatomic) NSString *nation;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *nationEn;
@property (strong, nonatomic) NSString *provinceEn;
@property (strong, nonatomic) NSString *cityEn;
@property (strong, nonatomic) NSNumber *nationId;
@property (strong, nonatomic) NSNumber *provinceId;
@property (strong, nonatomic) NSNumber *cityId;

@property (strong, nonatomic) NSString *addressId;
@end
