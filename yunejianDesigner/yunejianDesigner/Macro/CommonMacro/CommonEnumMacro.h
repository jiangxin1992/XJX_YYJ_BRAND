//
//  CommonEnumMacro.h
//  yunejianDesigner
//
//  Created by yyj on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef CommonEnumMacro_h
#define CommonEnumMacro_h

#pragma mark - 用户相关
/**
 用户角色
 */
typedef NS_ENUM(NSInteger, YYUserType)
{
    YYUserTypeDesigner    = 0, //设计师
    YYUserTypeRetailer    = 1, //买手店、admin
    YYUserTypeSales       = 2, //销售代表
    YYUserTypeShowroom    = 5, //showRoom
    YYUserTypeShowroomSub = 6,//showRoom子账号
    YYUserTypeProductManager = 11,//品牌主管
    YYUserTypeStoreManager = 12,//店长
    YYUserTypeAccountant = 13,//财务
    YYUserTypeStoreAssistant = 14,//店员
    YYUserTypeWarehouseManager = 15//仓库管理员
};

/**
 用户状态（不是很理解这个，多数状态都未用到）
 */
typedef NS_ENUM(NSInteger, YYUserStatus)
{
    YYUserStatusVerifying        = 0, //待审核
    YYUserStatusOk               = 1, //正常
    YYUserStatusStop             = 2, //停用
    YYUserStatusVerifyRejected   = 3, //审核未通过
    YYUserStatusNeedMailConfirm  = 4, //邮箱待验证
    YYUserStatusNeedFileSubmit   = 5 //文件待上传
};

/**
 用户关联状态 
 */
typedef NS_ENUM(NSInteger, YYUserConnStatus)
{
    YYUserConnStatusNone         = -1, //没有关系
    YYUserConnStatusInvite       =  0, //我已发送邀请，对方未处理
    YYUserConnStatusConnected    =  1, //已为好友
    YYUserConnStatusBeInvited    =  2 //对方已发出邀请，我未处理
};

#pragma mark - 作品相关
/**
 作品查看权限
 */
typedef NS_ENUM(NSInteger, YYOpusCheckAuth)
{
    YYOpusCheckAuthPublish    = 0, //已发布
    YYOpusCheckAuthDraft      = 1 //草稿状态
};

/**
 作品权限
 */
typedef NS_ENUM(NSInteger, YYOpusAuth)
{
    YYOpusAuthBuyer          = 0, //已发布
    YYOpusAuthMe             = 1, //草稿状态
    YYOpusAuthAll            = 2, //草稿状态
    YYOpusAuthDefined        = 3, //白名单
    YYOpusAuthDefinedOther   = 4 //黑名单
};

#pragma mark - 订单相关
/**
 订单状态

 - YYOrderCode_英文描述: "中文描述 ----> APP文案体现"
 */
typedef NS_ENUM(NSInteger, kOrderCode) {
    //    YYOrderCode_DRAFT            = 3,      // "草稿 ----> 草稿"
    //    YYOrderCode_DONE             = 12,     // "订单已完成 ----> 订单已完成"
    YYOrderCode_NEGOTIATION      =  4,      // "已下单   ----> 已下单"
    YYOrderCode_NEGOTIATION_DONE =  5,      // "协商完毕 ----> 已确认"
    YYOrderCode_CONTRACT_DONE    =  6,      // "合同已签 ----> 已确认"
    YYOrderCode_MANUFACTURE      =  7,      // "生产中   ----> 已生产"
    YYOrderCode_DELIVERING       = 15,      // "发货中   ----> 发货中"
    YYOrderCode_DELIVERY         =  8,      // "已发货   ----> 已发货"
    YYOrderCode_RECEIVED         =  9,      // "已收货   ----> 已收货"
    YYOrderCode_CANCELLED        = 10,      // "已取消   ----> 已取消"
    YYOrderCode_CLOSED           = 11,      // "已关闭   ----> 已取消"
    YYOrderCode_CLOSE_REQ        = 13,      // "关闭请求 ----> 关闭请求"
    YYOrderCode_DELETED          = 14       // "已删除   ----> 已删除"(iOS未显示此状态，只在判断中用到)
};

/**
 订单关联状态
 - 已入驻：
 * 在创建订单的时候，关联已入驻的买手，将发起订单关联请求，标记为 "YYOrderConnStatusUnconfirmed" （此为初始状态）
 * 对方操作后会变成"YYOrderConnStatusLinked"、"YYOrderConnStatusRefused"中的任一一个
 - 未入驻：
 * 在创建订单的时候，关联未入驻的买手，将直接标记为关联成功 "YYOrderConnStatusNotFound"（仅此状态，不会改变）
 */

typedef NS_ENUM(NSInteger, YYOrderConnStatus) {
    YYOrderConnStatusUnknow            = -2,//未知（还未获取到数据）
    YYOrderConnStatusUnconfirmed       =  0,//发起关联请求，但对方还未确认（买手已入驻）
    YYOrderConnStatusLinked            =  1,//关联成功（买手已入驻）
    YYOrderConnStatusRefused           =  2,//发起关联请求，对方已拒绝（买手已入驻）
    YYOrderConnStatusNotFound          =  3 //关联成功（买手未入驻）
};

#pragma mark - 网络请求相关

/**
 status code
 */
typedef NS_ENUM(NSInteger, YYReqStatusCode) {
    YYReqStatusCode100            =  100,//成功
    YYReqStatusCode203            =  203,
    YYReqStatusCode406            =  406,//需要验证码（替换 token）
    YYReqStatusCode407            =  407,//验证码错误
    YYReqStatusCode402            =  402,//需要重新登录
    YYReqStatusCode300            =  300,//审核中
    YYReqStatusCode301            =  301,//审核被拒
    YYReqStatusCode304            =  304,//需要邮箱验证
    YYReqStatusCode305            =  305,//需要审核
    YYReqStatusCode306            =  306,//审核过期
    YYReqStatusCode1000           = 1000 //登录成功 客户端自定义toMainPage":true, "expireDate":1445502958000,
};

#pragma mark - 系统相关
/**
 系统语言
 */
typedef NS_ENUM(NSInteger, ELanguage)
{
    ELanguageEnglish,
    ELanguageChinese,

    ELanguageCount
};

/**
 数据源类型(仅pad中用到)
 */
typedef NS_ENUM(NSInteger, EDataReadType) {
    EDataReadTypeOnline  = 50000,//在线
    EDataReadTypeOffline = 50001,//离线
    EDataReadTypeCached  = 50002 //缓存
};

/**
 系统环境
 */
typedef NS_ENUM(NSInteger, EEnvironmentType)
{
    EEnvironmentTEST,
    EEnvironmentSHOW,

    EEnvironmentPROD
};

#endif /* CommonEnumMacro_h */
