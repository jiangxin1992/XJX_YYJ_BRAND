//
//  YYBrandIntroductionModel.h
//  Yunejian
//
//  Created by Apple on 15/9/14.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@interface YYBrandIntroductionModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*brandIntroduction;
@property (strong, nonatomic) NSString <Optional>*brandName;
@property (strong, nonatomic) NSString <Optional>*note;
@property (strong, nonatomic) NSNumber <Optional>*designerId;
@property (strong, nonatomic) NSString <Optional>*email;
@property (strong, nonatomic) NSString <Optional>*phone;
@property (strong, nonatomic) NSString <Optional>*qq;
@property (strong, nonatomic) NSString <Optional>*weixin;
@end
