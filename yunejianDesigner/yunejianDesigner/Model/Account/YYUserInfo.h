//
//  YYUserInfo.h
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYUserInfo : NSObject<NSCopying,NSCoding>

@property (nonatomic, copy)   NSString  *userId;
@property (nonatomic, copy)   NSString  *email;
@property (nonatomic, copy)   NSString  *username;
@property (nonatomic, copy)   NSString  *phone;
@property (nonatomic, copy)   NSString  *brandName;
@property (nonatomic, copy)   NSString  *brandLogoName;
@property (nonatomic, copy)   NSString  *status;
@property (nonatomic, assign) YYUserType userType;

@property (nonatomic,copy) NSArray *sellersArray;

@property (nonatomic,copy) NSArray *addressArray;

@property (strong, nonatomic) NSString *nation;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *nationEn;
@property (strong, nonatomic) NSString *provinceEn;
@property (strong, nonatomic) NSString *cityEn;
@property (strong, nonatomic) NSNumber *nationId;
@property (strong, nonatomic) NSNumber *provinceId;
@property (strong, nonatomic) NSNumber *cityId;

@end
