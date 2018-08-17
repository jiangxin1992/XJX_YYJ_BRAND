//
//  YYExpressItemModel.m
//  yunejianDesigner
//
//  Created by yyj on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYExpressItemModel.h"

@implementation YYExpressItemModel

- (NSString *)transferTime{
    if(self && ![NSString isNilOrEmpty:_time]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *lastTime = _time;
        NSDate *lastDate = [formatter dateFromString:lastTime];
        double firstStamp = [lastDate timeIntervalSince1970];

        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:firstStamp];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"YYYY.MM.dd  HH:mm:ss"];
        NSString * currentDateStr = [dateFormatter stringFromDate:detaildate];
        return currentDateStr;
    }
    return @"";
}

@end
