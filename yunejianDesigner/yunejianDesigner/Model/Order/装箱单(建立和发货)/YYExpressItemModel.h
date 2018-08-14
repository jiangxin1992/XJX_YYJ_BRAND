//
//  YYExpressItemModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol YYExpressItemModel @end

@interface YYExpressItemModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*context;//物流信息
@property (strong, nonatomic) NSString <Optional>*location;//位置
@property (strong, nonatomic) NSString <Optional>*time;//时间

- (NSString *)transferTime;

@end
