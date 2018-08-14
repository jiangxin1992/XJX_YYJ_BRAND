//
//  YYParcelExceptionModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol YYParcelExceptionModel @end

@interface YYParcelExceptionModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*styleId;//款式id
@property (strong, nonatomic) NSString <Optional>*styleName;//款式名称
@property (strong, nonatomic) NSString <Optional>*styleCode;//款式编码
@property (strong, nonatomic) NSString <Optional>*styleImg;//款式图片
@property (strong, nonatomic) NSNumber <Optional>*colorId;//颜色id
@property (strong, nonatomic) NSString <Optional>*colorName;//颜色名称
@property (strong, nonatomic) NSString <Optional>*colorValue;//色值
@property (strong, nonatomic) NSNumber <Optional>*sizeId;//尺码id
@property (strong, nonatomic) NSString <Optional>*sizeName;//尺码名称
@property (strong, nonatomic) NSString <Optional>*note;//异常说明
@property (strong, nonatomic) NSNumber <Optional>*amount;//异常数
@property (strong, nonatomic) NSArray <Optional>*imgs;//异常图片列表
@property (strong, nonatomic) NSNumber <Optional>*sent;//发货数量
@property (strong, nonatomic) NSNumber <Optional>*received;//入库数量

@end
