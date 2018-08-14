//
//  YYScanFunctionModel.h
//  YunejianBuyer
//
//  Created by yyj on 2017/9/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YYScanFunctionModel : JSONModel

/** 环境: TEST,SHOW,PROD*/
@property (strong, nonatomic) NSString <Optional>*env;
/** 类型: STYLE*/
@property (strong, nonatomic) NSString <Optional>*type;
/** 惟一标识*/
@property (strong, nonatomic) NSString <Optional>*id;

/**
 测试数据

 @return ...
 */
+(instancetype )TestModel;

/**
 检测系统环境和二维码环境是否相同

 @return ...
 */
-(BOOL )isRightEnvironment;

@end
