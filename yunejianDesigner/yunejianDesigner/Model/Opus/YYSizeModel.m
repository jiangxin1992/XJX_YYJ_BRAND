//
//  YYSizeModel.m
//  Yunejian
//
//  Created by yyj on 15/8/5.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYSizeModel.h"

@implementation YYSizeModel

-(NSString *)getSizeShortStr{
    if(_value != nil){
        NSArray *sizeValueArr = [_value componentsSeparatedByString:@"/"];
        return  [sizeValueArr objectAtIndex:0];
    }
    return nil;
}

@end
