//
//  YYShowroomOrderingCheckModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/3/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol YYShowroomOrderingCheckModel @end

typedef NS_ENUM(NSInteger, YYOrderingCheckStatus){
    YYOrderingCheckStatus_TO_BE_VERIFIED,// 待审核
    YYOrderingCheckStatus_VERIFIED,// 已通过
    YYOrderingCheckStatus_REJECTED,// 已拒绝
    YYOrderingCheckStatus_CANCELLED,// 已取消
    YYOrderingCheckStatus_INVALIDATED,// 已失效
    YYOrderingCheckStatus_DELETED,// 已删除
    YYOrderingCheckStatus_UNKNOW//未知状态
};

@interface YYShowroomOrderingCheckModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*id;//申请单id
@property (strong, nonatomic) NSString <Optional>*shopName;//店名
@property (strong, nonatomic) NSString <Optional>*contactUser;//联系人/预约人
@property (strong, nonatomic) NSString <Optional>*contactPhone;//电话
@property (strong, nonatomic) NSString <Optional>*contactEmail;//邮箱
@property (strong, nonatomic) NSString <Optional>*appointmentName;//订货会名称
@property (strong, nonatomic) NSDate <Optional>*selectedDate;//预约日期
@property (strong, nonatomic) NSString <Optional>*range;//选择的时段
@property (strong, nonatomic) NSDate <Optional>*applyTime;//申请时间
@property (strong, nonatomic) NSNumber <Optional>*buyerId;//买手id
@property (strong, nonatomic) NSString <Optional>*level;

/**
 *     审核状态
 *     TO_BE_VERIFIED,// 待审核
 *     VERIFIED,// 已通过
 *     REJECTED,// 已拒绝
 *     INVALIDATED,// 已失效
 *     CANCELLED,// 已取消
 *     DELETED,// 已删除
 */
@property (strong, nonatomic) NSString <Optional>*status;//审核状态

- (YYOrderingCheckStatus)getEnumStatus;

- (NSString *)getStrStatus;

+ (NSString *)getStatusParameter:(YYOrderingCheckStatus)status;

@end
