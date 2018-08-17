//
//  YYWarehouseModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol YYWarehouseModel @end

@interface YYWarehouseModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*address;//仓库地址
@property (strong, nonatomic) NSNumber <Optional>*id;//仓库id
@property (strong, nonatomic) NSString <Optional>*name;//仓库名称
@property (strong, nonatomic) NSString <Optional>*phone;//仓库联系电话
@property (strong, nonatomic) NSString <Optional>*receiver;//收件人

@end
