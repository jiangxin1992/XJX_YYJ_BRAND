//
//  YYShowroomHomePageModel.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/9.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YYShowroomHomePageModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*adAddress;//地址
@property (strong, nonatomic) NSNumber <Optional>*adStartTime;//活动开始时间
@property (strong, nonatomic) NSNumber <Optional>*adEndTime;//活动结束时间
@property (strong, nonatomic) NSString <Optional>*adMemo;//活动备注
@property (strong, nonatomic) NSString <Optional>*adSeason;//活动季节
@property (strong, nonatomic) NSString <Optional>*adSeasonShow;//显示的活动季节 （缩写）
@property (strong, nonatomic) NSString <Optional>*adTitle;//活动标题
@property (strong, nonatomic) NSNumber <Optional>*adYear;//活动时间
@property (strong, nonatomic) NSString <Optional>*brief;//活动说明
@property (strong, nonatomic) NSString <Optional>*logo;//Showroom头像
@property (strong, nonatomic) NSString <Optional>*name;//Showroom名称
@property (strong, nonatomic) NSString <Optional>*pic;//Showroom海报

-(NSString *)getTitleStr;

@end

