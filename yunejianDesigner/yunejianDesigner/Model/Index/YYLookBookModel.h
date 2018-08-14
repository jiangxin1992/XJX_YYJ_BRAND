//
//  YYLookBookModel.h
//  Yunejian
//
//  Created by Apple on 15/9/14.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
@protocol YYLookBookModel @end

@interface YYLookBookModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*coverPic;
@property (strong, nonatomic) NSString <Optional>*createTime;
@property (strong, nonatomic) NSNumber <Optional>*designerId;
@property (strong, nonatomic) NSNumber <Optional>*id;
@property (strong, nonatomic) NSNumber <Optional>*isOnHomepage;
@property (strong, nonatomic) NSString <Optional>*name;
@property (strong, nonatomic) NSString <Optional>*note;
@property (strong, nonatomic) NSNumber <Optional>*picCount;
@property (strong, nonatomic) NSNumber <Optional>*status;
@property (strong, nonatomic) NSArray < Optional,ConvertOnDemand>*picUrls;
@end
