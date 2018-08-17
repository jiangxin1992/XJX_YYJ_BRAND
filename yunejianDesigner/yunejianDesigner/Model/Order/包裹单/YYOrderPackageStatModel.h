//
//  YYOrderPackageStatModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YYOrderPackageStatModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*receivedAmount;//已入库数
@property (strong, nonatomic) NSNumber <Optional>*receivedPackages;//已处理的包裹数
@property (strong, nonatomic) NSNumber <Optional>*totalPackages;//总的包裹数(不包含未发货的)
@property (strong, nonatomic) NSNumber <Optional>*sentAmount;//发货数量

@end
