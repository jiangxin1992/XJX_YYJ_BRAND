//
//  YYNewsInfoModel.h
//  YunejianBuyer
//
//  Created by Apple on 16/9/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"
@protocol YYNewsInfoModel @end
@interface YYNewsInfoModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*content;//":"",
@property (strong, nonatomic) NSNumber <Optional>*count;//":321,
@property (strong, nonatomic) NSString <Optional>*coverImg;//":"http://source.yunejian.com/ufile/20160906/eedb80ef4c4e48d0974c5b3ee1c4f6a3",
@property (strong, nonatomic) NSNumber <Optional>*createTime;//":1472435340000,
@property (strong, nonatomic) NSString <Optional>*digest;//":"新闻摘要",
@property (strong, nonatomic) NSNumber <Optional>*id;//":1,
@property (strong, nonatomic) NSNumber <Optional>*modifyTime;//":1473134116000,
@property (strong, nonatomic) NSNumber <Optional>*sort;//":1,
@property (strong, nonatomic) NSNumber <Optional>*status;//":1,
@property (strong, nonatomic) NSString <Optional>*title;//":"测试新闻",
@property (strong, nonatomic) NSNumber <Optional>*type;//":0
@property (strong, nonatomic) NSString <Optional>*detailURL;
@end
