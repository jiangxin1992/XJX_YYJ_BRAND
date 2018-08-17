//
//  Header.m
//  yunejianDesigner
//
//  Created by yyj on 2017/8/1.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "RequestURLMacro.h"

#pragma mark - 系统
/** 切换语言 */
NSString * const kSwitchLang = @"/service/lang";
/** 国省市 */
NSString * const kCountryInfo = @"/service/area";
/** 创建支付宝付款对象 */
NSString * const kAlipayCreate = @"/service/pay/appAlipayCreate";

#pragma mark - 首页相关
/** 首页banner */
NSString * const kBannerList = @"/service/topPic/list";
/** 推荐品牌 */
NSString * const KRecommendDesignerBrands = @"/service/homePage/recommendDesignerBrands";
/** 最新系列 */
NSString * const KLatestSeries = @"/service/v2/buyer/latestSeries";
/** 推荐品牌 */
NSString * const KRecommendBrands = @"/service/v2/buyer/recommendBrands";

#pragma mark - 上传图片
/** 上传图片 */
NSString * const kUploadImage = @"/file/upload";
/** 获取Qiniu UploadToken */
NSString * const kGetToken = @"/service/getToken";
/** 将返回Qiniu sdk返回的 key提交给后台（后台完成图片绑定操作）。 并返回 图片的完整路径 */
NSString * const kUploadKey = @"/service/getPath";
/** 删除指定的Qiniu 目录下的图片 */
NSString * const kDeleteKey = @"/service/fileDelate";


#pragma mark - 登录相关
/** 登录接口 */
NSString * const kLogin = @"/service/login";
/** 获取快速注册买手账号的信息 */
NSString * const kQuickBuyerInfo = @"/service/v2/buyer/quickBuyerInfo";
/** 验证码接口 */
NSString * const kCaptcha = @"/service/captcha";
/** 修改密码 */
NSString * const kPasswdUpdate = @"/service/passwdUpdate";
/** 忘记密码 */
NSString * const kForgetPassword = @"/service/forgetPassword";
/** 设计师注册 */
NSString * const kRegisterDesigner = @"/service/designer/register";
/** 买手注册 */
NSString * const kRegisterBuyer = @"/service/buyer/register";
/** 上传品牌审核文件 */
NSString * const kUploadBrandFiles = @"/service/designer/uploadBrandFiles";
/** 买手店提交审核信息 */
NSString * const kUploadCertInfo = @"/service/buyer/uploadCertInfo";
/** 买手店更新审核信息 */
NSString * const kUpdateCertInfo = @"/service/buyer/updateCertInfo";
/** 账号状态 */
NSString * const kUserStatus = @"/service/account/status";


#pragma mark - 用户相关
/** 获取买手基础信息 */
NSString *const kGetBuyerInfo = @"/service/connect/coop_status";
/** 更改头像 logo */
NSString * const kModifyLogoInfo = @"/service/modifyLogo";
/** 修改买手用户名或电话 */
NSString * const kUpdateBuyerUsernameOrPhone = @"/service/buyer/basicInfoUpdate";
/** 修改设计师用户名或电话 */
NSString * const kUpdateDesignerUsernameOrPhone = @"/service/designer/basicInfoUpdate";
/** 修改店铺品牌信息 */
NSString * const kStoreUpdate = @"/service/buyer/storeUpdate";
/** 用户反馈 */
NSString * const kSubmitFeedback = @"/service/submitFeedback";
/** 设计师个人信息接口 */
NSString * const kDesignerBasicInfo = @"/service/designer/basicInfo";
/** 设计师品牌信息接口 */
NSString * const kDesignerBrandInfo = @"/service/designer/brandInfo";
/** 买手店信息接口 */
NSString * const kBuyerStorBasicInfo = @"/service/buyer/basicInfo";
/** 销售代表列表接口 */
NSString * const kSalesManList = @"/service/designer/salesmanList";
/** 销售代表列表接口 */
NSString * const kSalesManListNew = @"/service/showroom/order/users";
/** 收件地址列表接口 */
NSString * const kAddressList = @"/service/buyer/addressList";
/** 买手-删除地址 */
NSString * const kDeleteAddress = @"/service/buyer/deleteAddress";
/** 停用或启用销售代表 */
NSString * const kUpdateSalesmanStatuse = @"/service/designer/updateSalesmanStatus";
/** 添加销售代表 */
NSString * const kaddSalesman = @"/service/designer/addSalesman";
/** 修改设计师品牌信息 设计师端 */
NSString * const kBrandInfoUpdate_brand = @"/service/designerIndex/brandInfoUpdate";
/** 修改设计师品牌信息 买手端 */
NSString * const kBrandInfoUpdate_buyer = @"/service/designer/brandInfoUpdate";
/** 修改收件地址 */
NSString * const kModifyAddress = @"/service/buyer/modifyAddress";
/** 添加收件地址 */
NSString * const kAddAddress = @"/service/buyer/addAddress";
/** 首页lookBook和产品介绍 */
NSString * const kHomePageInfoNew = @"/service/designerIndex/brandInfo";
/** 首页lookBook和产品介绍 */
NSString * const kHomePageInfo = @"/service/homePage/index";
/** lookBook信息 */
NSString * const kLookBookInfo = @"/service/homePage/lookBookDetail";
/** 首页图集 */
NSString * const kHomePageIndexPics = @"/service/homePage/indexPics";
/** 更新产品介绍 */
NSString * const kHomeUpdateBrandInfo = @"/service/homePage/updateBrandIntroduction";
/** 更新产品介绍 在pad中用到 */
NSString * const kHomeUpdateBrandInfoNew = @"/service/designerIndex/brandInfoUpdate";
/** 新建（修改）首页图集 */
NSString * const kHomeUpdateIndexPics = @"/service/homePage/uploadIndexPics";
/** 品牌信息简介 */
NSString * const kOrderDesignerInfo = @"/service/homePage/orderDesignerInfo";
/** 发送订单到邮箱 */
NSString * const kSendOrderByMail = @"/service/order/sendOrderByMail";
/** 发送订单到邮箱 */
NSString * const kReSendMailConfirmMail = @"/service/reSendMailConfirmMail";
/** 已发布新闻列表 */
NSString * const kNewsList = @"/service/news/releasedList/app";
/** 买手店首页信息 */
NSString * const kBuyerHomeInfo = @"/service/buyerIndex/buyerInfo";
/** 设计师首页信息 */
NSString * const kDesignerHomeInfo = @"/service/designerIndex/brandInfo";


#pragma mark - 作品相关
/** 设计师作品系列列表 */
NSString * const kSeriesList_brand = @"/service/v2/series/list";
/** 设计师作品系列列表 */
NSString * const kSeriesList_buyer = @"/service/style/seriesList";
/** 设计师作品系列列表 */
NSString * const kSeriesList_yco = @"/service/v2/series/list";
/** 分享系列 */
NSString * const kSeriesLineSheet = @"/service/v2/series/lineSheet";
/** 设计师作品系列中的款式列表 */
NSString * const kStyleList_yco = @"/service/v2/style/list";
/** 款式详情 */
NSString * const kStyleInfo = @"/service/v2/style/detail";
/** 判断是否存在多币种 */
NSString * const kStyleHasMultiCurrency = @"/service/style/hasMultiCurrency";
/** 离线包 */
NSString * const kSeriesOffline1 = @"/service/offline/downloadSeriesInfo";
/** 更改系列权限 */
NSString * const kUpdateSeriesAuthType_brand = @"/service/seriesAuth/updateSeriesAuthType";
/** 更改系列权限 */
NSString * const kUpdateSeriesAuthType_buyer = @"/service/style/updateSeriesAuthType";
/** 更改系列权限 */
NSString * const kUpdateSeriesAuthType_yco = @"/service/seriesAuth/updateSeriesAuthType";
/** 设计师系列详情 */
NSString * const kSeriesInfo_brand = @"/service/style/seriesInfo";
/** 设计师系列详情 */
NSString * const kSeriesInfo_buyer = @"/service/style/seriesInfo";
/** 设计师系列详情 */
NSString * const kSeriesInfo_yco = @"/service/v2/series/detail";
/** 更改系列发布状态与权限/service/style/ */
NSString * const kUpdateSeriesPubStatus = @"/service/seriesAuth/updateSeriesPubStatus";
/** 获取系列发布权限名单 */
NSString * const kGetSeriesAuthBuyers = @"/service/seriesAuth/list/app";
/** 取消收藏款式 */
NSString * const kRemoveStyle = @"/service/buyer/collect/removeStyle";
/** 收藏款式 */
NSString * const kAddStyle = @"/service/buyer/collect/addStyle";
/** 取消收藏系列 */
NSString * const kRemoveSeries = @"/service/buyer/collect/removeSeries";
/** 收藏系列 */
NSString * const kAddSeries = @"/service/buyer/collect/addSeries";
/** 款式收藏列表 */
NSString * const kCollectionStyleList = @"service/buyer/collect/styleList";
/** 系列收藏列表 */
NSString * const kCollectionSeriesList = @"service/buyer/collect/seriesList";


#pragma mark - 订单相关
/** 包裹异常详情 */
NSString * const kParcelExceptionDetail = @"/service/v2/order/order_package/exception";
/** 包裹单列表 */
NSString * const kPackagesList = @"/service/v2/order/order_packages";
/** 品牌端收货完成 */
NSString * const kDesignerReceived = @"/service/order/designerReceived";
/** 绑定物流信息并发货 */
NSString * const kSaveDeliverPackage = @"/service/v2/order/deliver_package";
/** 发货时的仓库列表 */
NSString * const kWarehouseListWhenDelivery = @"/service/warehouse/options";
/** 快递列表 */
NSString * const kExpressCompany = @"/service/trade/express_company";
/** 保存装箱单 */
NSString * const kSaveParcel = @"/service/v2/order/order_package";
/** 单个包裹单详情 */
NSString * const kParcelDetail = @"/service/v2/order/order_package";
/** 订单商品详情 */
NSString * const kPackingListDetail = @"/service/v2/order/items";
/** 确认订单 */
NSString * const kOrderConfirm = @"/service/order/confirm";
/** 拒绝确认订单 */
NSString * const kOrderRefuse = @"/service/order/reject";
/** 订单列表 仅买手相关角色可以调用 */
NSString * const kBuyerOrderList = @"/service/buyer/orderInfoListNew";
/** 订单列表 仅设计师相关角色可以调用*/
NSString * const kBrandOrderList = @"/service/order/orderInfoListNew";
/** 订单列表item */
NSString * const kOrderListItem = @"/service/v2/order/list/item";
/** 发现款式列表 */
NSString * const kChooseStyleList = @"/service/v2/buyer/styles";
/** 订单信息 */
NSString * const kOrderInfo = @"/service/v2/order/detail";
/** 订单信息 */
NSString * const kOrderSettingInfo = @"/service/designer/prefer/orderSettingInfo";
/** 最少起订额 */
NSString * const kOrderUnitPrice = @"/service/preference/orderUnitPrice";
/** 添加或修改买手收件地址 */
NSString * const kAddOrModifyBuyerAddress = @"/service/order/addOrderBuyerAddress";
/** 订单创建或修改 */
NSString * const kOrderCreate = @"/service/v2/order/add/pad";
/** 订单创建或修改 */
NSString * const kOrderModify = @"/service/v2/order/modify/pad";
/** 订单追单 */
NSString * const kOrderAppend = @"/service/append/add/pad";
/** 取消订单 */
NSString * const kCancelOrder = @"/service/order/cancelOrder";
/** 买手店取消订单 */
NSString * const kBuyerCancelOrder = @"/service/buyer/cancelOrder";
/** 取消订单 */
NSString * const kDeleteOrder_brand = @"/service/order/deleteOrder";
/** 取消订单 */
NSString * const kDeleteOrder_buyer = @"/service/buyer/deleteOrder";
/** 取消订单 */
NSString * const kDeleteOrder_yco = @"/service/order/deleteOrder";
/** 单个订单的操作记录(分页) */
NSString * const kGetSingleOrderInfoDynamics = @"/service/order/singleOrderInfoDynamics";
/** 获取通知消息列表 */
NSString * const kGetNotifyMsgList = @"/service/notify/notifyMsgList";
/** 未读消息条数查询 */
NSString * const kGetUnreadNotifyMsgAmount = @"/service/notify/unread";
/** 买手操作订单关联请求 */
NSString * const kopWithOrderConn = @"/service/order/opWithOrderConn";
/** 标记同一类型通知消息为已读 */
NSString * const kMarkAsRead = @"/service/notify/markAllAsRead";
/** 获取某个订单的分享状态信息 */
NSString * const kGetorderConnStatus = @"/service/connect/orderConnStatus";
/** 更新订单流转状态 */
NSString * const kUpdateTransStatus = @"/service/order/updateTransStatus";
/** 当前订单流转状态 */
NSString * const kCrtTransStatus = @"/service/order/crtTransStatus";
/** 设计师发货接口 */
NSString * const kDesignerSendOut = @"/service/designer/designerSendOut";
/** 退款 */
NSString * const kAddRefundNote = @"/service/payment/addRefundNote";
/** 添加付款（收款）记录 */
NSString * const kAddPaymentNote = @"/service/payment/addPaymentNote";
/** 订单收款记录 */
NSString * const kPaymentNoteList = @"/service/payment/paymentNoteList";
/** 关闭订单请求(买手,设计师) */
NSString * const kOrderCloseRequest = @"/service/order/orderCloseRequest";
/** 处理关闭订单请求(买手,设计师) */
NSString * const kDealOrderCloseRequest = @"/service/order/dealOrderCloseRequest";
/** 撤销关闭订单请求(买手,设计师) */
NSString * const kRevokeOrderCloseRequest = @"/service/order/revokeOrderCloseRequest";
/** 款式是否过期 */
NSString * const kIsStyleModify = @"/service/order/isStyleModify";
/** 买手收货接口 */
NSString * const kBuyerReceived = @"/service/buyer/buyerReceived";
/** 查看对方是否订单关闭 */
NSString * const kOrderCloseStatus = @"/service/order/orderCloseStatus";
/** 关闭订单 */
NSString * const kCloseOrder = @"/service/order/closeOrder";
/** 删除付款记录 */
NSString * const kDeletePaymentNote = @"/service/payment/delete";
/** 开启或关闭补货 */
NSString * const kOrderSimpleStyleList = @"/service/v2/style/simpleStyleList/app";
/** 追单初始化创建 */
NSString * const kOrderPreAppend_brand = @"/service/append/preAdd/pad";
/** 追单初始化创建 */
NSString * const kOrderPreAppend_buyer = @"/service/append/preAdd/pad";
/** 追单初始化创建 */
NSString * const kOrderPreAppend_yco = @"/service/append/preAdd";
/** 确认付款记录 */
NSString * const kPaymentConfirm = @"/service/payment/confirm";
/** 废弃付款记录 */
NSString * const kPaymentDiscard = @"/service/payment/discard";
/** 删除付款记录 */
NSString * const kPaymentDelete = @"/service/payment/delete";
/** 创建支付宝付款对象 */
NSString * const kAliPayIsAvailable = @"/service/account/isAvailable";
/** 订单关联相关信息 */
NSString * const kOrderMessageConfirmInfo = @"/service/connect/orderConfirmInfo";


#pragma mark - showroom相关
/** showroom信息接口 */
NSString * const kShowroomInfo = @"/service/showroom/showroomInfo";
/** 获取showroom首页列表 */
NSString * const kShowroomList = @"/service/showroom/frontBrand";
/** 获取showroom主页信息 */
NSString * const kShowroomHomePageInfo = @"/service/showroom/homeInfo";
/** 停用showroom子账号 */
NSString * const kShowroomUpdateSalesmanStatusOFF = @"/service/showroom/disableSubShowroom";
/** 启用showroom子账号 */
NSString * const kShowroomUpdateSalesmanStatusON = @"/service/showroom/enableSubShowroom";
/** 添加showroom子账号 */
NSString * const kShowroomAddSalesman = @"/service/showroom/newSubShowroom";
/** 更新showroom子账号权限 */
NSString * const kShowroomCreateOrUpdatePower = @"/service/showroom/auth/check";
/** 查询showroom子账号权限 */
NSString * const kSubShowroomCreatePower = @"/service/showroom/auth/list";
/** 删除showroom子账号权限 */
NSString * const kShowroomDeleteNotActive = @"/service/showroom/user/remove";
/** 更改头像showroom logo */
NSString * const kShowroomModifyLogoInfo = @"/service/showroom/modifyShowroomUserLogo";
/** showroom到品牌 */
NSString * const kShowroomToBrand = @"/service/showroom/showroomToBrand";
/** 品牌到showroom */
NSString * const kShowroomBrandToShowroom = @"/service/showroom/brandToShowroom";
/** 品牌页面中token失效处理 */
NSString * const kGetShowroomBrandToken = @"/service/showroom/getShowroomBrandToken";
/** 根据设计师获取showroom用户 */
NSString * const kGetShowroomInfoByDesigner = @"/service/showroom/getShowroomInfoByDesigner";
/** 获取代理协议 */
NSString * const KGetShowroomAgentContentWeb = @"/service/showroom/getAgentContentWeb";
/** 获取showroom对应款式的访问权限 */
NSString * const KGetShowroomPermissionToVisitStyle = @"/service/showroom/check_permission";
/** sr订货会权限查询(调用权限：仅showroom_sub) */
NSString * const KGetShowroomPermissionToOrdering = @"/service/sr_appointment/auth";
/** sr订货会消息 获取/清空 */
NSString * const KGetShowroomHasOrderingMsg = @"/service/sr_appointment/msg";
/** sr订货会列表 */
NSString * const KGetShowroomOrderingList = @"/service/sr_appointment/list";
/** 预约列表 */
NSString * const KGetShowroomOrderingCheckList = @"/service/appointment/applies";

#pragma mark - 买手店相关
/** 按条件查询所有买手店 */
NSString * const kBuyerList = @"/service/designer/queryBuyer";
/** 买手-收件地址列表 */
NSString * const kBuyerAddressList = @"/service/designer/buyerAddresses";
/** 设计师作品系列列表 */
NSString * const kBuyerAvailableSeries = @"/service/buyer/availableSeries";
/** 买手修改订单可用的款式 */
NSString * const kBuyerAvailableStyles = @"/service/buyer/availableStyles";
/** 设计师查询买手店详情 */
NSString * const kBuyerPubInfo = @"/service/designer/buyerPubInfo";
/** 设计师查询买手店详情 new */
NSString * const kBuyerPubInfoNew = @"/service/buyerIndex/buyerInfo";


#pragma mark - 合作
/** 设计师添加买手店(买手添加设计师)（共用）店 */
NSString * const kConnInvite = @"/service/connect/invite";
/** 设计师合作的买手店（所有） */
NSString * const kConnBuyers = @"/service/connect/connBuyers";
/** 设计师对买手合作关系的操作（原设计师移除与买手店的合作关系接口） */
NSString * const kConnWithBuyerOp = @"/service/connect/connWithBuyerOp";
/** 对设计师的邀请请求操作 */
NSString * const kConnWithDesignerBrandOp = @"/service/connect/connWithDesignerBrandOp";
/** 正在被邀请的品牌(收到的邀请<设计师品牌列表>) */
NSString * const kBeingInvitedBrands = @"/service/buyer/beingInvitedBrands";
/** 买手店的所有合作品牌 */
NSString * const kAllAlreadyConnBrands = @"/service/buyer/allAlreadyConnBrands";
/** 查询最新入驻品牌是否有更新 */
NSString * const kHasNewBrands = @"/service/v2/buyer/has_new_brands";
/** 清除最新入驻品牌的消息 */
NSString * const kClearNewBrands = @"/service/v2/buyer/clear_new_brands";
/** 合作设计师的系列列表 */
NSString * const kConnSeriesList = @"/service/buyer/designerSeriesList";
/** 合作设计师系列详情 /service/buyer/designerSeriesInfo */
NSString * const kConnSeriesInfo_brand = @"/service/v2/series/detail";
/** 合作设计师系列详情 /service/buyer/designerSeriesInfo*/
NSString * const kConnSeriesInfo_buyer = @"/service/v2/series/detail";
/** 合作设计师系列详情 */
NSString * const kConnSeriesInfo_yco = @"/service/buyer/designerSeriesInfo";
/** 合作设计师款式列表（带搜索）/service/buyer/designerStyleList */
NSString * const kConnStyleList_brand = @"/service/v2/style/list";
/** 合作设计师款式列表（带搜索）/service/buyer/designerStyleList */
NSString * const kConnStyleList_buyer = @"/service/v2/style/list";
/** 合作设计师款式列表（带搜索） */
NSString * const kConnStyleList_yco = @"/service/buyer/designerStyleList";
/** 买手店按条件查询所有设计师(更全) */
NSString * const kConnNewQueryDesignerWithPage = @"/service/connect/brandsPhone";
/** 获取brand分类 */
NSString * const kConnClassifications = @"/service/v2/buyer/classifications";
/** 设计师按条件查询所有买手店(带分页,目前邀请状态) */
NSString * const kConnQueryBuyerList = @"/service/connect/queryBuyerWithPage";
/** 获取最新入驻品牌 */
NSString * const kConnNewBrands = @"/service/v2/buyer/new_brands";
/** 批量判断买手店是否在合作状态中 */
NSString * const kCheckConnBuyers = @"/service/seriesAuth/isConnected";
/** 判断买手是否有访问某系列权限 */
NSString * const kISSeriesPubToBuyer = @"/service/seriesAuth/isSeriesPubToBuyer";

#pragma mark - 站内信
/** 消息历史记录 */
NSString * const kMessageTalkHistory = @"/service/message/talkHistory";
/** 会话列表 */
NSString * const kMessageUserChatList = @"/service/message/userLog";
/** 删除会话 */
NSString * const kMessageUserChatDelete = @"/service/message/deleteTalk";
/** 发送私信 */
NSString * const kMessageSend = @"/service/message/send";
/** 已读 */
NSString * const kMessageMarkAsRead = @"/service/message/readed";
/** 获取库存消息列表 */
NSString * const kGetSkuNotifyMsgList = @"/service/notify/sku_mgs";
/** 标记库存消息已读 */
NSString * const kMarkSkuAsRead = @"/service/notify/markSkuAsRead";


#pragma mark - 线下订货会
/** 线下订货会列表 */
NSString * const KOrderingList = @"/service/appointment/list";
NSString * const KOrderingListIndex = @"/service/appointment/list_phone";
/** 我的预约列表 */
NSString * const KOrderingHistoryList = @"/service/appointment/applyList";
/** 取消预约 */
NSString * const KOrderingCancel = @"/service/appointment/cancelApply";
/** 删除预约 */
NSString * const KOrderingDelete = @"/service/appointment/deleteApply";
/** 清空订货会消息 */
NSString * const KOrderingClear = @"/service/notify/appointment/clear";
/** 获取预约申请状态变更消息 */
NSString * const KOrderingStatusCount = @"/service/notify/appointment/apply";
/** 获取预约申请状态变更消息 */
NSString * const KOrderingStatusCountDelete = @"/service/notify/appointment/apply";

#pragma mark - 埋点
/** 新增一条日活记录 */
NSString * const KBurideStatDaily = @"/service/stat/daily_op";
/** 新增一条pv */
NSString * const KBurideStatPv = @"/service/stat/pv";

#pragma mark - 隐藏买手账号信息
/** 获取隐藏账号信息 */
NSString * const KGetInvisibleInfo = @"/service/v2/buyer/quickBuyerInfo";
/** 完善隐藏账号信息 */
NSString * const KPostInvisibleInfo = @"/service/v2/buyer/uploadQuickBuyerInfo";


