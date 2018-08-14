//
//  YYCountryListModel.h
//  yunejianDesigner
//
//  Created by yyj on 2017/6/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYCountryModel.h"

@interface YYCountryListModel : JSONModel

@property (strong, nonatomic) NSArray<YYCountryModel, Optional,ConvertOnDemand>* result;

@end
