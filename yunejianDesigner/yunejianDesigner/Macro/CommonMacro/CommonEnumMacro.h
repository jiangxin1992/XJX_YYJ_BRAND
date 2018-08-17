//
//  CommonEnumMacro.h
//  yunejianDesigner
//
//  Created by yyj on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef CommonEnumMacro_h
#define CommonEnumMacro_h

//订单互连状态
#define kOrderStatusNUll  -2//未知，
#define kOrderStatus  -1//未入驻，
#define kOrderStatus0  0//关联中，
#define kOrderStatus1  1//关联成功，
#define kOrderStatus2  2//已拒绝,
#define kOrderStatus3  3//已解除合作


//关系类型 -1 没有关系  0 我已发送邀请，对方未处理  1 已为好友   2 对方已发出邀请，我未处理
#define kConnStatus  -1
#define kConnStatus0  0
#define kConnStatus1  1
#define kConnStatus2  2

//作品权限
#define  kAuthTypeBuyer 0
#define  kAuthTypeMe 1
#define  kAuthTypeAll 2
#define  kAuthTypeDefined 3//白名单
#define  kAuthTypeDefinedOther 4//黑名单

//查看权限 0 publish, 2, draft
#define kOpusPublish  0
#define kOpusDraft 2

//user status
#define kUserStatusVerifying 0 //待审核
#define kUserStatusOk 1//正常
#define kUserStatusStop 2//停用
#define kUserStatusVerifyRejected 3//审核未通过
#define kUserStatusNeedMailConfirm 4//邮箱待验证
#define kUserStatusNeedFileSubmit 5//文件待上传

//status code
#define kCode100 100
#define kCode203 203
#define kCode406 406 //需要验证码（替换 token）
#define kCode407 407 //验证码错误
#define kCode402 402 //需要重新登录

#define kCode300 300 //审核中
#define kCode301 301 //审核被拒
#define kCode304 304 //需要邮箱验证
#define kCode305 305 //需要审核
#define kCode306 306 //审核过期
#define kCode1000 1000 //登录成功 客户端自定义toMainPage":true, "expireDate":1445502958000,

/**
 OrderCode

 - kOrderCode_英文描述: "中文描述 ----> APP文案体现"
 */
typedef NS_ENUM(NSInteger, kOrderCode) {
//    kOrderCode_DRAFT            = 3,      // "草稿 ----> 草稿"
//    kOrderCode_DONE             = 12,     // "订单已完成 ----> 订单已完成"
    kOrderCode_NEGOTIATION      = 4,      // "已下单 ----> 已下单"
    kOrderCode_NEGOTIATION_DONE = 5,      // "协商完毕 ----> 已确认"
    kOrderCode_CONTRACT_DONE    = 6,      // "合同已签 ----> 已确认"
    kOrderCode_MANUFACTURE      = 7,      // "生产中 ----> 已生产"
    kOrderCode_DELIVERY         = 8,      // "已发货 ----> 已发货"
    kOrderCode_RECEIVED         = 9,      // "已收货 ----> 已收货"
    kOrderCode_CANCELLED         = 10,     // "已取消 ----> 已取消"
    kOrderCode_CLOSED           = 11,     // "已关闭 ----> 已取消"
    kOrderCode_CLOSE_REQ        = 13,     // "关闭请求 ----> 关闭请求"
    kOrderCode_DELETED          = 14,     // "已删除 ----> 已删除"(iOS未显示此状态，只在判断中用到)
};

typedef NS_ENUM(NSInteger, DataReadType) {
    DataReadTypeOnline = 50000,
    DataReadTypeOffline = 50001,
    DataReadTypeCached = 50002
};

typedef NS_ENUM(NSInteger, ELanguage)
{
    ELanguageEnglish,
    ELanguageChinese,

    ELanguageCount
};

typedef NS_ENUM(NSInteger, EEnvironmentType)
{
    EEnvironmentTEST,
    EEnvironmentSHOW,

    EEnvironmentPROD
};

/**
 *
 *账户相关
 *
 */

//角色类型
#define kBuyerStorUserType 1 //买手店
#define kDesignerType 0 //设计师
#define kSellerType 2 //销售代表
#define kShowroomType 5 //showRoom
#define kShowroomSubType 6 //showRoom子账号

#endif /* CommonEnumMacro_h */
