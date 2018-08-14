//
//  YYSizeModel.h
//  Yunejian
//
//  Created by yyj on 15/8/5.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@protocol YYSizeModel @end

@interface YYSizeModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*id;
@property (strong, nonatomic) NSString <Optional>*value;

-(NSString *)getSizeShortStr;

@end
