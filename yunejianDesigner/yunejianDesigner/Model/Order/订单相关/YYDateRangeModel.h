//
//  YYDateRangeModel.h
//  Yunejian
//
//  Created by Apple on 16/5/16.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "JSONModel.h"
@protocol YYDateRangeModel @end
@interface YYDateRangeModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>*end;//":1459222482000,
@property (strong, nonatomic) NSNumber <Optional>*id;//":1,
@property (strong, nonatomic) NSString <Optional>*name;//:"youmoo",
@property (strong, nonatomic) NSNumber <Optional>*seriesId;//":139,
@property (strong, nonatomic) NSNumber <Optional>*start;//":1458531221000,
@property (strong, nonatomic) NSNumber <Optional>*status;//":0
-(NSString *)getShowStr;
@end
