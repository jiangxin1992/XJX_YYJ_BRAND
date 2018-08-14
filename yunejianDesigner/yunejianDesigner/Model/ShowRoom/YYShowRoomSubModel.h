//
//  YYShowroomSubModel.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/8.
//  Copyright © 2017年 Apple. All rights reserved.
//
/**
 ****status***
 * 主账号时
 * NORMAL正常/INIT合同未生效/STOP停用,不能登录/EXPIRE合同已过期
 * 只有NORMAL的时候才能登陆
 * 子账号时候
 * NORMAL正常/INIT未激活/STOP停用
 */
#import <JSONModel/JSONModel.h>

@protocol YYShowRoomSubModel @end

@interface YYShowRoomSubModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*status;//状态 NORMAL正常/INIT未激活/STOP停用
@property (strong, nonatomic) NSString <Optional>*contractEndTime;//合同起止结束时间
@property (strong, nonatomic) NSString <Optional>*contractStartTime;
@property (strong, nonatomic) NSNumber <Optional>*createTime;//创建时间
@property (strong, nonatomic) NSString <Optional>*email;//登录邮箱
@property (strong, nonatomic) NSNumber <Optional>*showroomUserId;//Showroom ID
@property (strong, nonatomic) NSString <Optional>*logo;//子账号头像
@property (strong, nonatomic) NSNumber <Optional>*majorId;//主账号ID
@property (strong, nonatomic) NSString <Optional>*manager;//manager名 登录账号的名称 用户名
@property (strong, nonatomic) NSString <Optional>*managerPhone;//manager电话号码
@property (strong, nonatomic) NSString <Optional>*name;//子账号名称 Showroom名称 固定的
@property (strong, nonatomic) NSString <Optional>*type;//区分主次账号 MAJOR主账号/SUB子账号

@end
