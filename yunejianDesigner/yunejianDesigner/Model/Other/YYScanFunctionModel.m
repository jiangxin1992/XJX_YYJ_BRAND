//
//  YYScanFunctionModel.m
//  YunejianBuyer
//
//  Created by yyj on 2017/9/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYScanFunctionModel.h"

@implementation YYScanFunctionModel

+(instancetype )TestModel{
    YYScanFunctionModel *testModel = [[YYScanFunctionModel alloc] init];
    testModel.env = @"TEST";
    testModel.type = @"STYLE";
    testModel.id = @"3299";
    return testModel;
}

/**
 检测系统环境和二维码环境是否相同

 @return ...
 */
-(BOOL )isRightEnvironment{
    EEnvironmentType environmentType = currentEnvironment();
    if(([self.env isEqualToString:@"TEST"] && environmentType == EEnvironmentTEST)||([self.env isEqualToString:@"SHOW"] && environmentType == EEnvironmentSHOW)||([self.env isEqualToString:@"PROD"] && environmentType == EEnvironmentPROD)){\
        return YES;
    }
    return NO;
}
@end
