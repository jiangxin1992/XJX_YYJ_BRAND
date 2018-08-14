//
//  YYPackageModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol YYPackageModel @end

@interface YYPackageModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*logisticsCode;//物流编号
@property (strong, nonatomic) NSString <Optional>*logisticsName;//物流公司名称
@property (strong, nonatomic) NSNumber <Optional>*packageId;//装箱单id
@property (strong, nonatomic) NSString <Optional>*status;//状态(ON_THE_WAY,// 在途中  RECEIVED,// 已收货 TO_DELIVER//等待发货)
@property (strong, nonatomic) NSNumber <Optional>*hasException;//是否存在异常 bool 

@end
