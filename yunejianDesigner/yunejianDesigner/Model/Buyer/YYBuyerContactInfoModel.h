//
//  YYBuyerContactInfoModel.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"

#import <UIKit/UIKit.h>

@protocol YYBuyerContactInfoModel @end

@interface YYBuyerContactInfoModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*contactType;//0 邮箱，1 电话，2 QQ，3 微信号'，4 固定电话
@property (strong, nonatomic) NSString <Optional>*contactValue;//联系信息
@property (strong, nonatomic) NSNumber <Optional>*auth;//0 合作可见，1, 自己可见，2 全部可见

@property (strong, nonatomic) UIView <Optional>*view;
@end
