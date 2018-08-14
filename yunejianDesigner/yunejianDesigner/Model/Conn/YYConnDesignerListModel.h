//
//  YYConnDesignerListModel.h
//  Yunejian
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
#import "YYPageInfoModel.h"
#import "YYConnDesignerModel.h"
@interface YYConnDesignerListModel : JSONModel
@property (strong, nonatomic) NSArray<YYConnDesignerModel,Optional, ConvertOnDemand>* result;
@property (strong, nonatomic) YYPageInfoModel <Optional>*pageInfo;

@end
