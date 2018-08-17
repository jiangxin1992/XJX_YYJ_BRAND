//
//  YYExpressInfoModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "YYExpressItemModel.h"

@interface YYExpressInfoModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*com;
@property (strong, nonatomic) NSString <Optional>*condition;
@property (strong, nonatomic) NSArray <YYExpressItemModel, Optional, ConvertOnDemand>*data;//物流信息
@property (strong, nonatomic) NSString <Optional>*ischeck;
@property (strong, nonatomic) NSString <Optional>*message;//ok的时候说明有物流信息 && 物流信息查询成功
@property (strong, nonatomic) NSString <Optional>*nu;
@property (strong, nonatomic) NSString <Optional>*state;
@property (strong, nonatomic) NSString <Optional>*status;

@end
