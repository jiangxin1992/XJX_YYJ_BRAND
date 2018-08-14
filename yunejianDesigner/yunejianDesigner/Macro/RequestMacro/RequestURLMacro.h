//
//  Header.h
//  yunejianDesigner
//
//  Created by yyj on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//
#import <UIKit/UIKit.h>

#pragma mark - RequestBodyMacro


#pragma mark - 系统
/** 切换语言 */
UIKIT_EXTERN NSString * const kSwitchLang;
/** 国省市 */
UIKIT_EXTERN NSString * const kCountryInfo;
/** 创建支付宝付款对象 */
UIKIT_EXTERN NSString * const kAlipayCreate;

#pragma mark - 首页相关
/** 首页banner */
UIKIT_EXTERN NSString * const kBannerList;
/** 推荐品牌 */
UIKIT_EXTERN NSString * const KRecommendDesignerBrands;
/** 最新系列 */
UIKIT_EXTERN NSString * const KLatestSeries;
/** 推荐品牌 */
UIKIT_EXTERN NSString * const KRecommendBrands;

#pragma mark - 上传图片
/** 上传图片 */
UIKIT_EXTERN NSString * const kUploadImage;
/** 获取Qiniu UploadToken */
UIKIT_EXTERN NSString * const kGetToken;
/** 将返回Qiniu sdk返回的 key提交给后台（后台完成图片绑定操作）。 并返回 图片的完整路径 */
UIKIT_EXTERN NSString * const kUploadKey;
/** 删除指定的Qiniu 目录下的图片 */
UIKIT_EXTERN NSString * const kDeleteKey;


#pragma mark - 登录相关
/** 登录接口 */
UIKIT_EXTERN NSString * const kLogin;
/** 获取快速注册买手账号的信息 */
UIKIT_EXTERN NSString * const kQuickBuyerInfo;
/** 验证码接口 */
UIKIT_EXTERN NSString * const kCaptcha;
/** 修改密码 */
UIKIT_EXTERN NSString * const kPasswdUpdate;
/** 忘记密码 */
UIKIT_EXTERN NSString * const kForgetPassword;
/** 设计师注册 */
UIKIT_EXTERN NSString * const kRegisterDesigner;
/** 买手注册 */
UIKIT_EXTERN NSString * const kRegisterBuyer;
/** 上传品牌审核文件 */
UIKIT_EXTERN NSString * const kUploadBrandFiles;
/** 买手店提交审核信息 */
UIKIT_EXTERN NSString * const kUploadCertInfo;
/** 买手店更新审核信息 */
UIKIT_EXTERN NSString * const kUpdateCertInfo;
/** 账号状态 */
UIKIT_EXTERN NSString * const kUserStatus;


#pragma mark - 用户相关
/** 获取买手基础信息 */
UIKIT_EXTERN NSString * const kGetBuyerInfo;
/** 更改头像 logo */
UIKIT_EXTERN NSString * const kModifyLogoInfo;
/** 修改买手用户名或电话 */
UIKIT_EXTERN NSString * const kUpdateBuyerUsernameOrPhone;
/** 修改设计师用户名或电话 */
UIKIT_EXTERN NSString * const kUpdateDesignerUsernameOrPhone;
/** 修改店铺品牌信息 */
UIKIT_EXTERN NSString * const kStoreUpdate;
/** 用户反馈 */
UIKIT_EXTERN NSString * const kSubmitFeedback;
/** 设计师个人信息接口 */
UIKIT_EXTERN NSString * const kDesignerBasicInfo;
/** 设计师品牌信息接口 */
UIKIT_EXTERN NSString * const kDesignerBrandInfo;
/** 买手店信息接口 */
UIKIT_EXTERN NSString * const kBuyerStorBasicInfo;
/** 销售代表列表接口 */
UIKIT_EXTERN NSString * const kSalesManList;
/** 销售代表列表接口 */
UIKIT_EXTERN NSString * const kSalesManListNew;
/** 收件地址列表接口 */
UIKIT_EXTERN NSString * const kAddressList;
/** 买手-删除地址 */
UIKIT_EXTERN NSString * const kDeleteAddress;
/** 停用或启用销售代表 */
UIKIT_EXTERN NSString * const kUpdateSalesmanStatuse;
/** 添加销售代表 */
UIKIT_EXTERN NSString * const kaddSalesman;
/** 修改设计师品牌信息 设计师端 */
UIKIT_EXTERN NSString * const kBrandInfoUpdate_brand;
/** 修改设计师品牌信息 买手端 */
UIKIT_EXTERN NSString * const kBrandInfoUpdate_buyer;
/** 修改收件地址 */
UIKIT_EXTERN NSString * const kModifyAddress;
/** 添加收件地址 */
UIKIT_EXTERN NSString * const kAddAddress;
/** 首页lookBook和产品介绍 */
UIKIT_EXTERN NSString * const kHomePageInfoNew;
/** 首页lookBook和产品介绍 */
UIKIT_EXTERN NSString * const kHomePageInfo;
/** lookBook信息 */
UIKIT_EXTERN NSString * const kLookBookInfo;
/** 首页图集 */
UIKIT_EXTERN NSString * const kHomePageIndexPics;
/** 更新产品介绍 */
UIKIT_EXTERN NSString * const kHomeUpdateBrandInfo;
/** 更新产品介绍 在pad中用到 */
UIKIT_EXTERN NSString * const kHomeUpdateBrandInfoNew;
/** 新建（修改）首页图集 */
UIKIT_EXTERN NSString * const kHomeUpdateIndexPics;
/** 品牌信息简介 */
UIKIT_EXTERN NSString * const kOrderDesignerInfo;
/** 发送订单到邮箱 */
UIKIT_EXTERN NSString * const kSendOrderByMail;
/** 发送订单到邮箱 */
UIKIT_EXTERN NSString * const kReSendMailConfirmMail;
/** 已发布新闻列表 */
UIKIT_EXTERN NSString * const kNewsList;
/** 买手店首页信息 */
UIKIT_EXTERN NSString * const kBuyerHomeInfo;
/** 设计师首页信息 */
UIKIT_EXTERN NSString * const kDesignerHomeInfo;


#pragma mark - 作品相关
/** 设计师作品系列列表 */
UIKIT_EXTERN NSString * const kSeriesList_brand;
/** 设计师作品系列列表 */
UIKIT_EXTERN NSString * const kSeriesList_buyer;
/** 设计师作品系列列表 */
UIKIT_EXTERN NSString * const kSeriesList_yco;
/** 分享系列 */
UIKIT_EXTERN NSString * const kSeriesLineSheet;
/** 设计师作品系列中的款式列表 */
UIKIT_EXTERN NSString * const kStyleList_yco;
/** 款式详情/service/style/styleInfo */
UIKIT_EXTERN NSString * const kStyleInfo;
/** 判断是否存在多币种 */
UIKIT_EXTERN NSString * const kStyleHasMultiCurrency;
/** 离线包 */
UIKIT_EXTERN NSString * const kSeriesOffline1;
/** 更改系列权限 */
UIKIT_EXTERN NSString * const kUpdateSeriesAuthType_brand;
/** 更改系列权限 */
UIKIT_EXTERN NSString * const kUpdateSeriesAuthType_buyer;
/** 更改系列权限 */
UIKIT_EXTERN NSString * const kUpdateSeriesAuthType_yco;
/** 设计师系列详情 */
UIKIT_EXTERN NSString * const kSeriesInfo_brand;
/** 设计师系列详情 */
UIKIT_EXTERN NSString * const kSeriesInfo_buyer;
/** 设计师系列详情 */
UIKIT_EXTERN NSString * const kSeriesInfo_yco;
/** 更改系列发布状态与权限/service/style/ */
UIKIT_EXTERN NSString * const kUpdateSeriesPubStatus;
/** 获取系列发布权限名单 */
UIKIT_EXTERN NSString * const kGetSeriesAuthBuyers;
/** 取消收藏款式 */
UIKIT_EXTERN NSString * const kRemoveStyle;
/** 收藏款式 */
UIKIT_EXTERN NSString * const kAddStyle;
/** 取消收藏系列 */
UIKIT_EXTERN NSString * const kRemoveSeries;
/** 收藏系列 */
UIKIT_EXTERN NSString * const kAddSeries;
/** 款式收藏列表 */
UIKIT_EXTERN NSString * const kCollectionStyleList;
/** 系列收藏列表 */
UIKIT_EXTERN NSString * const kCollectionSeriesList;


#pragma mark - 订单相关
/** 包裹异常详情 */
UIKIT_EXTERN NSString * const kParcelExceptionDetail;
/** 包裹单列表 */
UIKIT_EXTERN NSString * const kPackagesList;
/** 品牌端收货完成 */
UIKIT_EXTERN NSString * const kDesignerReceived;
/** 绑定物流信息并发货 */
UIKIT_EXTERN NSString * const kSaveDeliverPackage;
/** 发货时的仓库列表 */
UIKIT_EXTERN NSString * const kWarehouseListWhenDelivery;
/** 快递列表 */
UIKIT_EXTERN NSString * const kExpressCompany;
/** 保存装箱单 */
UIKIT_EXTERN NSString * const kSaveParcel;
/** 单个包裹单详情 */
UIKIT_EXTERN NSString * const kParcelDetail;
/** 订单商品详情 */
UIKIT_EXTERN NSString * const kPackingListDetail;
/** 确认订单 */
UIKIT_EXTERN NSString * const kOrderConfirm;
/** 拒绝确认订单 */
UIKIT_EXTERN NSString * const kOrderRefuse;
/** 订单列表 仅买手相关角色可以调用 */
UIKIT_EXTERN NSString * const kBuyerOrderList;
/** 订单列表 仅设计师相关角色可以调用*/
UIKIT_EXTERN NSString * const kBrandOrderList;
/** 订单列表item */
UIKIT_EXTERN NSString * const kOrderListItem;
/** 发现款式列表 */
UIKIT_EXTERN NSString * const kChooseStyleList;
/** 订单信息 */
UIKIT_EXTERN NSString * const kOrderInfo;
/** 订单信息 */
UIKIT_EXTERN NSString * const kOrderSettingInfo;
/** 最少起订额 */
UIKIT_EXTERN NSString * const kOrderUnitPrice;
/** 添加或修改买手收件地址 */
UIKIT_EXTERN NSString * const kAddOrModifyBuyerAddress;
/** 订单创建或修改 */
UIKIT_EXTERN NSString * const kOrderCreate;
/** 订单创建或修改 */
UIKIT_EXTERN NSString * const kOrderModify;
/** 订单追单 */
UIKIT_EXTERN NSString * const kOrderAppend;
/** 取消订单 */
UIKIT_EXTERN NSString * const kCancelOrder;
/** 买手店取消订单 */
UIKIT_EXTERN NSString * const kBuyerCancelOrder;
/** 取消订单 */
UIKIT_EXTERN NSString * const kDeleteOrder_brand;
/** 取消订单 */
UIKIT_EXTERN NSString * const kDeleteOrder_buyer;
/** 取消订单 */
UIKIT_EXTERN NSString * const kDeleteOrder_yco;
/** 单个订单的操作记录(分页) */
UIKIT_EXTERN NSString * const kGetSingleOrderInfoDynamics;
/** 获取通知消息列表 */
UIKIT_EXTERN NSString * const kGetNotifyMsgList;
/** 未读消息条数查询 */
UIKIT_EXTERN NSString * const kGetUnreadNotifyMsgAmount;
/** 买手操作订单关联请求 */
UIKIT_EXTERN NSString * const kopWithOrderConn;
/** 标记同一类型通知消息为已读 */
UIKIT_EXTERN NSString * const kMarkAsRead;
/** 获取某个订单的分享状态信息 */
UIKIT_EXTERN NSString * const kGetorderConnStatus;
/** 更新订单流转状态 */
UIKIT_EXTERN NSString * const kUpdateTransStatus;
/** 当前订单流转状态 */
UIKIT_EXTERN NSString * const kCrtTransStatus;
/** 设计师发货接口 */
UIKIT_EXTERN NSString * const kDesignerSendOut;
/** 退款 */
UIKIT_EXTERN NSString * const kAddRefundNote;
/** 添加付款（收款）记录 */
UIKIT_EXTERN NSString * const kAddPaymentNote;
/** 订单收款记录 */
UIKIT_EXTERN NSString * const kPaymentNoteList;
/** 关闭订单请求(买手,设计师) */
UIKIT_EXTERN NSString * const kOrderCloseRequest;
/** 处理关闭订单请求(买手,设计师) */
UIKIT_EXTERN NSString * const kDealOrderCloseRequest;
/** 撤销关闭订单请求(买手,设计师) */
UIKIT_EXTERN NSString * const kRevokeOrderCloseRequest;
/** 款式是否过期 */
UIKIT_EXTERN NSString * const kIsStyleModify;
/** 买手收货接口 */
UIKIT_EXTERN NSString * const kBuyerReceived;
/** 查看对方是否订单关闭 */
UIKIT_EXTERN NSString * const kOrderCloseStatus;
/** 关闭订单 */
UIKIT_EXTERN NSString * const kCloseOrder;
/** 删除付款记录 */
UIKIT_EXTERN NSString * const kDeletePaymentNote;
/** 开启或关闭补货 */
UIKIT_EXTERN NSString * const kOrderSimpleStyleList;
/** 追单初始化创建 */
UIKIT_EXTERN NSString * const kOrderPreAppend_brand;
/** 追单初始化创建 */
UIKIT_EXTERN NSString * const kOrderPreAppend_buyer;
/** 追单初始化创建 */
UIKIT_EXTERN NSString * const kOrderPreAppend_yco;
/** 确认付款记录 */
UIKIT_EXTERN NSString * const kPaymentConfirm;
/** 废弃付款记录 */
UIKIT_EXTERN NSString * const kPaymentDiscard;
/** 删除付款记录 */
UIKIT_EXTERN NSString * const kPaymentDelete;
/** 创建支付宝付款对象 */
UIKIT_EXTERN NSString * const kAliPayIsAvailable;
/** 订单关联相关信息 */
UIKIT_EXTERN NSString * const kOrderMessageConfirmInfo;


#pragma mark - showroom相关
/** showroom信息接口 */
UIKIT_EXTERN NSString * const kShowroomInfo;
/** 获取showroom首页列表 */
UIKIT_EXTERN NSString * const kShowroomList;
/** 获取showroom主页信息 */
UIKIT_EXTERN NSString * const kShowroomHomePageInfo;
/** 停用showroom子账号 */
UIKIT_EXTERN NSString * const kShowroomUpdateSalesmanStatusOFF;
/** 启用showroom子账号 */
UIKIT_EXTERN NSString * const kShowroomUpdateSalesmanStatusON;
/** 添加showroom子账号 */
UIKIT_EXTERN NSString * const kShowroomAddSalesman;
/** 更新showroom子账号权限 */
UIKIT_EXTERN NSString * const kShowroomCreateOrUpdatePower;
/** 查询showroom子账号权限 */
UIKIT_EXTERN NSString * const kSubShowroomCreatePower;
/** 删除showroom子账号权限 */
UIKIT_EXTERN NSString * const kShowroomDeleteNotActive;
/** 更改头像showroom logo */
UIKIT_EXTERN NSString * const kShowroomModifyLogoInfo;
/** showroom到品牌 */
UIKIT_EXTERN NSString * const kShowroomToBrand;
/** 品牌到showroom */
UIKIT_EXTERN NSString * const kShowroomBrandToShowroom;
/** 品牌页面中token失效处理 */
UIKIT_EXTERN NSString * const kGetShowroomBrandToken;
/** 根据设计师获取showroom用户 */
UIKIT_EXTERN NSString * const kGetShowroomInfoByDesigner;
/** 获取代理协议 */
UIKIT_EXTERN NSString * const KGetShowroomAgentContentWeb;
/** 获取showroom对应款式的访问权限 */
UIKIT_EXTERN NSString * const KGetShowroomPermissionToVisitStyle;
/** sr订货会权限查询(调用权限：仅showroom_sub) */
UIKIT_EXTERN NSString * const KGetShowroomPermissionToOrdering;
/** sr订货会消息 获取/清空 */
UIKIT_EXTERN NSString * const KGetShowroomHasOrderingMsg;
/** sr订货会列表 */
UIKIT_EXTERN NSString * const KGetShowroomOrderingList;
/** 预约列表 */
UIKIT_EXTERN NSString * const KGetShowroomOrderingCheckList;


#pragma mark - 买手店相关
/** 按条件查询所有买手店 */
UIKIT_EXTERN NSString * const kBuyerList;
/** 买手-收件地址列表 */
UIKIT_EXTERN NSString * const kBuyerAddressList;
/** 设计师作品系列列表 */
UIKIT_EXTERN NSString * const kBuyerAvailableSeries;
/** 买手修改订单可用的款式 */
UIKIT_EXTERN NSString * const kBuyerAvailableStyles;
/** 设计师查询买手店详情 */
UIKIT_EXTERN NSString * const kBuyerPubInfo;
/** 设计师查询买手店详情 new */
UIKIT_EXTERN NSString * const kBuyerPubInfoNew;


#pragma mark - 合作
/** 设计师添加买手店(买手添加设计师)（共用）店 */
UIKIT_EXTERN NSString * const kConnInvite;
/** 设计师合作的买手店（所有） */
UIKIT_EXTERN NSString * const kConnBuyers;
/** 设计师对买手合作关系的操作（原设计师移除与买手店的合作关系接口） */
UIKIT_EXTERN NSString * const kConnWithBuyerOp;
/** 对设计师的邀请请求操作 */
UIKIT_EXTERN NSString * const kConnWithDesignerBrandOp;
/** 正在被邀请的品牌(收到的邀请<设计师品牌列表>) */
UIKIT_EXTERN NSString * const kBeingInvitedBrands;
/** 买手店的所有合作品牌 */
UIKIT_EXTERN NSString * const kAllAlreadyConnBrands;
/** 查询最新入驻品牌是否有更新 */
UIKIT_EXTERN NSString * const kHasNewBrands;
/** 清除最新入驻品牌的消息 */
UIKIT_EXTERN NSString * const kClearNewBrands;
/** 合作设计师的系列列表 */
UIKIT_EXTERN NSString * const kConnSeriesList;
/** 合作设计师系列详情 /service/buyer/designerSeriesInfo */
UIKIT_EXTERN NSString * const kConnSeriesInfo_brand;
/** 合作设计师系列详情 /service/buyer/designerSeriesInfo*/
UIKIT_EXTERN NSString * const kConnSeriesInfo_buyer;
/** 合作设计师系列详情 */
UIKIT_EXTERN NSString * const kConnSeriesInfo_yco;
/** 合作设计师款式列表（带搜索）/service/buyer/designerStyleList */
UIKIT_EXTERN NSString * const kConnStyleList_brand;
/** 合作设计师款式列表（带搜索）/service/buyer/designerStyleList */
UIKIT_EXTERN NSString * const kConnStyleList_buyer;
/** 合作设计师款式列表（带搜索） */
UIKIT_EXTERN NSString * const kConnStyleList_yco;
/** 买手店按条件查询所有设计师(更全) */
UIKIT_EXTERN NSString * const kConnNewQueryDesignerWithPage;
/** 获取brand分类 */
UIKIT_EXTERN NSString * const kConnClassifications;
/** 设计师按条件查询所有买手店(带分页,目前邀请状态) */
UIKIT_EXTERN NSString * const kConnQueryBuyerList;
/** 获取最新入驻品牌 */
UIKIT_EXTERN NSString * const kConnNewBrands;
/** 批量判断买手店是否在合作状态中 */
UIKIT_EXTERN NSString * const kCheckConnBuyers;
/** 判断买手是否有访问某系列权限 */
UIKIT_EXTERN NSString * const kISSeriesPubToBuyer;

#pragma mark - 站内信
/** 消息历史记录 */
UIKIT_EXTERN NSString * const kMessageTalkHistory;
/** 会话列表 */
UIKIT_EXTERN NSString * const kMessageUserChatList;
/** 删除会话 */
UIKIT_EXTERN NSString * const kMessageUserChatDelete;
/** 发送私信 */
UIKIT_EXTERN NSString * const kMessageSend;
/** 已读 */
UIKIT_EXTERN NSString * const kMessageMarkAsRead;
/** 获取库存消息列表 */
UIKIT_EXTERN NSString * const kGetSkuNotifyMsgList;
UIKIT_EXTERN NSString * const kMarkSkuAsRead;

#pragma mark - 线下订货会
/** 线下订货会列表 */
UIKIT_EXTERN NSString * const KOrderingList;
UIKIT_EXTERN NSString * const KOrderingListIndex;
/** 我的预约列表 */
UIKIT_EXTERN NSString * const KOrderingHistoryList;
/** 取消预约 */
UIKIT_EXTERN NSString * const KOrderingCancel;
/** 删除预约 */
UIKIT_EXTERN NSString * const KOrderingDelete;
/** 清空订货会消息 */
UIKIT_EXTERN NSString * const KOrderingClear;
/** 获取预约申请状态变更消息 */
UIKIT_EXTERN NSString * const KOrderingStatusCount;
/** 获取预约申请状态变更消息 */
UIKIT_EXTERN NSString * const KOrderingStatusCountDelete;

#pragma mark - 埋点
/** 新增一条日活记录 */
UIKIT_EXTERN NSString * const KBurideStatDaily;
/** 新增一条pv */
UIKIT_EXTERN NSString * const KBurideStatPv;

#pragma mark - 隐藏买手账号信息
/** 获取隐藏账号信息 */
UIKIT_EXTERN NSString * const KGetInvisibleInfo;
/** 完善隐藏账号信息 */
UIKIT_EXTERN NSString * const KPostInvisibleInfo;

