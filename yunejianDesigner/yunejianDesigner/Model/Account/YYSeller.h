//
//  YYSeller.h
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYSeller : NSObject<NSCopying,NSCoding>

@property (assign, nonatomic) NSInteger salesmanId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (assign, nonatomic) NSInteger status;

@end
