//
//  YYOpusSeriesAuthTypeBuyerListModel.h
//  yunejianDesigner
//
//  Created by Apple on 16/11/3.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YYOpusSeriesAuthTypeBuyerModel.h"

@interface YYOpusSeriesAuthTypeBuyerListModel : JSONModel
@property (strong, nonatomic) NSArray<YYOpusSeriesAuthTypeBuyerModel, Optional,ConvertOnDemand>* result;

@end
