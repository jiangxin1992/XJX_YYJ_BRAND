//
//  YYExpressCompanyModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YYExpressCompanyModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*id;//主键id
@property (strong, nonatomic) NSString <Optional>*code;//快递编号
@property (strong, nonatomic) NSString <Optional>*name;//快递名称
@property (strong, nonatomic) NSString <Optional>*ico;//快递公司Logo
@property (strong, nonatomic) NSString <Optional>*status;//忽略

@end
