//
//  YYOrderSimpleStyleList.h
//  Yunejian
//
//  Created by Apple on 16/8/9.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYOpusStyleModel.h"

@interface YYOrderSimpleStyleList : JSONModel
@property (strong, nonatomic) NSArray<YYOpusStyleModel, Optional,ConvertOnDemand>* result;
@end
