//
//  YYSalesManListModel.h
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYSalesManModel.h"

@interface YYSalesManListModel : JSONModel

@property (strong, nonatomic) NSArray<YYSalesManModel,Optional, ConvertOnDemand>* result;

/**
 * 排序
 * 按照 showroom主账号-showroom子账号-设计师-销售代表
 */
-(void)sortModelWithAddArr:(NSArray *)addArr;

/**
 * 获取销售代表list
 */
-(void)getTrueSalesMainList;

-(NSNumber *)getTypeWithID:(NSNumber *)CreateID WithName:(NSString *)CreateName;

@end
