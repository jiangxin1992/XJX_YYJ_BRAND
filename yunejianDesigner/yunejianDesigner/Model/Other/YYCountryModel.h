//
//  YYCountryModel.h
//  yunejianDesigner
//
//  Created by yyj on 2017/6/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol YYCountryModel @end

@interface YYCountryModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*impId;//当前地址id
@property (strong, nonatomic) NSString <Optional>*name;//当前地址名称
@property (strong, nonatomic) NSString <Optional>*nameEn;//当前地址英文
@property (strong, nonatomic) NSNumber <Optional>*parentImpId;//父级地址. 重要: 当父级地址为空时，表示只有二级地址

@end
