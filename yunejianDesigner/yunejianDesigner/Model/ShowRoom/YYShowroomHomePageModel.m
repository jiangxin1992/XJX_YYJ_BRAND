//
//  YYShowroomHomePageModel.m
//  yunejianDesigner
//
//  Created by yyj on 2017/3/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYShowroomHomePageModel.h"

@implementation YYShowroomHomePageModel

-(NSString *)getTitleStr{
    NSString *headstr = @"";
    NSString *footstr = @"";
    if(self.adYear)
    {
        if([NSString isNilOrEmpty:self.adSeasonShow])
        {
            headstr = [[NSString alloc] initWithFormat:@"%ld",[self.adYear longValue]];
        }else
        {
            headstr = [[NSString alloc] initWithFormat:@"%ld%@",[self.adYear longValue],self.adSeasonShow];
        }
    }
    
    if(![NSString isNilOrEmpty:self.adTitle])
    {
        footstr = self.adTitle;
    }
    
    if(![NSString isNilOrEmpty:footstr]){
        if(![NSString isNilOrEmpty:headstr]){
            return [[NSString alloc] initWithFormat:@"%@ · %@",headstr,footstr];
        }else
        {
            return footstr;
        }
    }else
    {
        if(![NSString isNilOrEmpty:headstr]){
            return headstr;
        }else
        {
            return @"";
        }
    }
    
}


@end
