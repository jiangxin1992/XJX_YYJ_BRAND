//
//  YYDateRangeModel.m
//  Yunejian
//
//  Created by Apple on 16/5/16.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "YYDateRangeModel.h"
@implementation YYDateRangeModel
-(NSString *)getShowStr{
    return  [NSString stringWithFormat:NSLocalizedString(@"%@ :%@-%@",nil),_name,getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd",[_start stringValue]),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd",[_end stringValue])];
}
@end
