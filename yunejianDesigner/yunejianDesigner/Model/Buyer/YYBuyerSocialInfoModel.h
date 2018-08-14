//
//  YYBuyerSocialInfoModel.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"
#import <UIKit/UIKit.h>

@protocol YYBuyerSocialInfoModel @end
@interface YYBuyerSocialInfoModel : JSONModel
@property (strong, nonatomic) NSNumber <Optional>*socialType;//0 新浪微博，1 微信公众号，2 Facebook，3 Ins'
@property (strong, nonatomic) NSString <Optional>*url;//地址
@property (strong, nonatomic) NSString <Optional>*image;//图片（微信公众号可用）
@property (strong, nonatomic) NSString <Optional>*socialName;//昵称

@property (strong, nonatomic) UIView <Optional>*view;

@end
