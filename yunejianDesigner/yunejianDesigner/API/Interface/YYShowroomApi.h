//
//  YYShowroomApi.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YYRspStatusAndMessage.h"
#import "YYUserModel.h"

@class YYShowroomBrandListModel,YYShowroomHomePageModel,YYShowroomInfoByDesignerModel,YYShowroomOrderingListModel,YYShowroomOrderingCheckListModel;

@interface YYShowroomApi : NSObject

/**
*
* sr订货会权限查询(调用权限：仅showroom_sub)
*
*/
+ (void)hasPermissionToVisitOrderingWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,BOOL hasPermission,NSError *error))block;

/**
 *
 * sr订货会是否有消息
 *
 */
+ (void)hasOrderingMsgWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,BOOL hasMsg,NSError *error))block;
/**
 *
 * 清空sr订货会消息
 *
 */
+ (void)clearOrderingMsgWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;
/**
 *
 * sr订货会列表
 *
 */
+ (void)getOrderingListWithPageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomOrderingListModel *showroomOrderingListModel,NSError *error))block;
/**
 *
 * 预约列表
 *
 */
+ (void)getOrderingCheckListWithAppointmentId:(NSNumber *)appointmentId status:(NSString *)status PageIndex:(NSInteger )pageIndex pageSize:(NSInteger )pageSize andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomOrderingCheckListModel *showroomOrderingCheckListModel,NSError *error))block;

/**
 *
 * 预约申请审核 通过
 *
 */
+ (void)agreeOrderingApplicationWithIds:(NSString *)ids andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;
/**
 *
 * 预约申请审核 拒绝
 *
 */
+ (void)refuseOrderingApplicationWithIds:(NSString *)ids andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;
/**
 *
 * 是否有权限访问该款式
 *
 */
+ (void)hasPermissionToVisitStyleWithStyleId:(NSInteger)styleId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,BOOL hasPermission,NSNumber *brandId,NSError *error))block;

/**
 * 获取Showroom首页信息
 */
+ (void)getShowroomBrandListWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomBrandListModel *brandListModel,NSError *error))block;

/**
 * 获取Showroom主页信息
 */
+ (void)getShowroomHomePageInfoWithBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomHomePageModel *ShowroomHomePageModel,NSError *error))block;
/**
 * 停用或启用销售代表
 */
+ (void)updateSubShowroomStatusWithId:(NSInteger)userId status:(NSInteger)status andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 * 新建subshowroom
 */
+ (void)createSubShowroomWithUsername:(NSString *)username email:(NSString *)email password:(NSString *)password andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSNumber *userId, NSError *error))block;

/**
 * 添加／修改showroom子账号权限
 */
+ (void)subShowroomPowerUserId:(NSNumber *)userId authList:(NSArray *)authList andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error))block;

/**
 * 查询showroom子账号权限
 */
+ (void)selectSubShowroomPowerUserId:(NSNumber *)userId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage, NSArray *powerArray, NSError *error))block;

/**
 * 删除showroom子账号
 */
+ (void)deleteNotActiveSubShowroomUserId:(NSNumber *)userId andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,NSError *error))block;

/**
 * showroom到品牌
 */
+ (void)showroomToBrandWithBrandID:(NSNumber *)brandID andBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYUserModel *userModel,NSError *error))block;
/**
 * 品牌到showroom
 */
+ (void)brandToShowroomBlock:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYUserModel *userModel,NSError *error))block;
/**
 * 品牌页面中token失效处理
 */
+ (void)getShowroomToBrandToken:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYUserModel *userModel,NSError *error))block;

/**
 * 根据设计师获取showroom用户
 */
+ (void)getShowroomInfoByDesigner:(void (^)(YYRspStatusAndMessage *rspStatusAndMessage,YYShowroomInfoByDesignerModel *showroomInfoByDesignerModel,NSError *error))block;
@end
