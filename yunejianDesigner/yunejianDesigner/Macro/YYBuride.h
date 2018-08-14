//
//  YYBuride.h
//  yunejianDesigner
//
//  Created by chuanjun sun on 2017/8/7.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef YYBuride_h
#define YYBuride_h

#import <UMMobClick/MobClick.h>

#define currentServerUrlRelease(monitor, placeholder) [[[NSUserDefaults standardUserDefaults] objectForKey: kLastYYServerURL] containsString:@"http://ycosystem.com"]? monitor: placeholder

//原订单内容
#define kYYPageOriginalOrderDetail currentServerUrlRelease(@"YYOriginalOrderDetail", @"not-release")
//强制发货（操作确认页面）
#define kYYPageDeliveringDoneConfirm currentServerUrlRelease(@"YYDeliveringDoneConfirm", @"not-release")
//查看异常反馈
#define kYYPageParcelExceptionDetail currentServerUrlRelease(@"YYParcelExceptionDetail", @"not-release")
//包裹单详情
#define kYYPagePackageDetail currentServerUrlRelease(@"YYPackageDetail", @"not-release")
//包裹单列表
#define kYYPagePackageList currentServerUrlRelease(@"YYPackageList", @"not-release")
//发货时的编辑地址
#define kYYPageDeliverModifyAddress currentServerUrlRelease(@"YYDeliverModifyAddress", @"not-release")
//发货时选择仓库
#define kYYPageChooseWarehouse currentServerUrlRelease(@"YYChooseWarehouse", @"not-release")
//发货时选择物流公司
#define kYYPageChooseLogistics currentServerUrlRelease(@"YYChooseLogistics", @"not-release")
//建立和编辑装箱单界面
#define kYYPagePackingList currentServerUrlRelease(@"YYPackingList", @"not-release")
//发货界面
#define kYYPageDeliver currentServerUrlRelease(@"YYDeliver", @"not-release")

// 产品介绍页（安装后的三张介绍）
#define kYYPageIntroduction currentServerUrlRelease(@"YYIntroduction", @"not-release")
// 登录
#define kYYPageLogin currentServerUrlRelease(@"YYLogin", @"not-release")
// 主界面
#define kYYPageMain currentServerUrlRelease(@"YYMain", @"not-release")

// showroom主页
#define kYYPageShowroomMain currentServerUrlRelease(@"YYShowroomMain", @"not-release")
// showroom的设计师页
#define kYYPageShowroomBrand currentServerUrlRelease(@"YYShowroomBrand", @"not-release")
// showroom介绍页（设置-我的showroom主页-）
#define kYYPageShowroomHomePage currentServerUrlRelease(@"YYShowroomHomePage", @"not-release")

// 作品(第一页)
#define kYYPageOpus currentServerUrlRelease(@"YYOpus", @"not-release")
// 订单(第一页)
#define kYYPageOrderList currentServerUrlRelease(@"YYOrderList", @"not-release")
// 买手店(第一页)
#define kYYPageBuyer currentServerUrlRelease(@"YYBuyer", @"not-release")
// 我的(第一页)
#define kYYPageAccountDetail currentServerUrlRelease(@"YYAccountDetail", @"not-release")

// 自定义查看权限
#define kYYPageOpusSettingDefined currentServerUrlRelease(@"YYOpusSettingDefined", @"not-release")
// 设计师系列详情
#define kYYPageBrandSeries currentServerUrlRelease(@"YYBrandSeries", @"not-release")
// 商品详情
#define kYYPageStyleDetail currentServerUrlRelease(@"YYStyleDetail", @"not-release")
// 加入购物车
#define kYYPageShopping currentServerUrlRelease(@"YYShopping", @"not-release")
// 购物车
#define kYYPageCartDetail currentServerUrlRelease(@"YYCartDetail", @"not-release")
// 税率选择
#define kYYPageTaxChoose currentServerUrlRelease(@"YYTaxChoose", @"not-release")

/// ---------- OrderModify start  ---------
// 确认订单
#define kYYPageOrderModifyConfirm currentServerUrlRelease(@"YYOrderModify_confirm", @"not-release")
// 修改订单
#define kYYPageOrderModifyUpdate currentServerUrlRelease(@"YYOrderModify_update", @"not-release")
// 补货追单
#define kYYPageOrderModifyReplenishment currentServerUrlRelease(@"YYOrderModify_replenishment", @"not-release")
/// ---------- OrderModify  end   ---------

// 订单修改记录
#define kYYPageOrderModifyLog currentServerUrlRelease(@"YYOrderModifyLog", @"not-release")

// 线下订货会详情，带js交互
#define kYYPageOrderingDetail currentServerUrlRelease(@"YYOrderingDetail", @"not-release")

// 消息中心
#define kYYPageGroupMessage currentServerUrlRelease(@"YYGroupMessage", @"not-release")
// 合作消息
#define kYYPageConnMsgList currentServerUrlRelease(@"YYConnMsgList", @"not-release")
// 订单消息
#define kYYPageOrderMessage currentServerUrlRelease(@"YYOrderMessage", @"not-release")
// yco新闻
#define kYYPageNews currentServerUrlRelease(@"YYNews", @"not-release")
// 聊天室
#define kYYPageMessageDetail currentServerUrlRelease(@"YYMessageDetail", @"not-release")

// 买手店信息
#define kYYPageBuyerHomePage currentServerUrlRelease(@"YYBuyerHomePage", @"not-release")

// 订单列表
#define kYYPageOrderListTable currentServerUrlRelease(@"YYOrderListTable", @"not-release")
/// ---------- OrderDetail start ----------
// 订单详情
#define kYYPageOrderDetail currentServerUrlRelease(@"YYOrderDetail", @"not-release")
// 追单详情
#define kYYPageOrderDetailAppend currentServerUrlRelease(@"YYOrderDetail_Append", @"not-release")
/// ---------- OrderDetail  end  ----------

// 帮助(如何理解订单状态/新手帮助)
#define kYYPageOrderHelp currentServerUrlRelease(@"YYOrderHelp", @"not-release")
// 添加收款记录
#define kYYPageOrderAddMoneyLog currentServerUrlRelease(@"YYOrderAddMoneyLog", @"not-release")
// 收款记录列表
#define kYYPageOrderPayLog currentServerUrlRelease(@"YYOrderPayLog", @"not-release")

/// ---------- Register start ----------
// 设计师入驻
#define kYYPageRegisterDesignerTypeEmailRegisterType currentServerUrlRelease(@"YYRegister_designerType|EmailRegisterType", @"not-release")
// 找回密码
#define kYYPageForgetPasswordTypeEmailPasswordType currentServerUrlRelease(@"YYRegister_forgetPasswordType|EmailPasswordType", @"not-release")
// 品牌验证
#define kYYPageBrandRegisterStep1TypeBrandRegisterStep2Type currentServerUrlRelease(@"YYRegister_brandRegisterStep1Type|BrandRegisterStep2Type", @"not-release")
// 修改品牌信息
#define kYYPageBrandInfoType currentServerUrlRelease(@"YYRegister_brandInfoType", @"not-release")
// 线下收款记录
#define kYYPagePayLogRegisterType currentServerUrlRelease(@"YYRegister_payLogRegisterType", @"not-release")
// 其他
#define kYYPageRegisterOther currentServerUrlRelease(@"YYRegister_Other", @"not-release")
/// ---------- Register  end   ---------
// 搜索买手店
#define kYYPageOrderAddressList currentServerUrlRelease(@"YYOrderAddressList", @"not-release")

// 选择追单款式
#define kYYPageOrderAppend currentServerUrlRelease(@"YYOrderAppend", @"not-release")
// 修改／新建 买手店收获地址
#define kYYPageCreateOrModifyAddress currentServerUrlRelease(@"YYCreateOrModifyAddress", @"not-release")
// 编辑折扣
#define kYYPageDiscount currentServerUrlRelease(@"YYDiscount", @"not-release")
// 款式备注
#define kYYPageOrderStylesRemark currentServerUrlRelease(@"YYOrderStylesRemark", @"not-release")
// 样式列表（修改订单／补货追单--添加样式）
#define kYYPageStyleDetailList currentServerUrlRelease(@"YYStyleDetailList", @"not-release")

// 新闻详情
#define kYYPageNewsDetail currentServerUrlRelease(@"YYNewsDetail", @"not-release")

// 邀请合作买手店
#define kYYPageBuyerInvite currentServerUrlRelease(@"YYBuyerInvite", @"not-release")

// 我的品牌主页
#define kYYPageBrandHomePage currentServerUrlRelease(@"YYBrandHomePage", @"not-release")
// 编辑主页信息
#define kYYPageBrandModifyInfo currentServerUrlRelease(@"YYBrandModifyInfo", @"not-release")

/// ---------- BrandModifyInfoCell start  ---------
// 编辑主页信息-每项
// 品牌简介
#define kYYPageBrandModifyInfoCellDesc currentServerUrlRelease(@"YYBrandModifyInfoCell_desc", @"not-release")
// 列举三个合作买手店
#define kYYPageBrandModifyInfoCellConnBrand currentServerUrlRelease(@"YYBrandModifyInfoCell_connBrand", @"not-release")
// 网站
#define kYYPageBrandModifyInfoCellWebsite currentServerUrlRelease(@"YYBrandModifyInfoCell_website", @"not-release")
// email
#define kYYPageBrandModifyInfoCellContactTxtEmail currentServerUrlRelease(@"YYBrandModifyInfoCell_contactTxtEmail", @"not-release")
// 微信
#define kYYPageBrandModifyInfoCellContactTxtWeChat currentServerUrlRelease(@"YYBrandModifyInfoCellWeChat", @"not-release")
// QQ
#define kYYPageBrandModifyInfoCellQQ currentServerUrlRelease(@"YYBrandModifyInfoCell_QQ", @"not-release")
// 手机
#define kYYPageBrandModifyInfoCellContactMobile currentServerUrlRelease(@"YYBrandModifyInfoCell_contactMobile", @"not-release")
// 固定电话
#define kYYPageBrandModifyInfoCellContactTelephone currentServerUrlRelease(@"YYBrandModifyInfoCell_contactTelephone", @"not-release")
// 微信公众号
#define kYYPageBrandModifyInfoCellSocialWeChat currentServerUrlRelease(@"YYBrandModifyInfoCell_socialWeChat", @"not-release")
// 新浪微博
#define kYYPageBrandModifyInfoCellSocialSina currentServerUrlRelease(@"YYBrandModifyInfoCell_socialSina", @"not-release")
// ins
#define kYYPageBrandModifyInfoCellIns currentServerUrlRelease(@"YYBrandModifyInfoCell_ins", @"not-release")
// facebook
#define kYYPageBrandModifyInfoCellFacebook currentServerUrlRelease(@"YYBrandModifyInfoCell_facebook", @"not-release")
/// ---------- BrandModifyInfoCell  end   ---------

// 修改mima
#define kYYPageModifyPassword currentServerUrlRelease(@"YYModifyPassword", @"not-release")

/// ---------- BrandModifyInfoCell start  ---------
// 修改用户名
#define kYYPageModifyName currentServerUrlRelease(@"YYModifyNameOrPhone_name", @"not-release")
// 修改手机号
#define kYYPageModifyPhone currentServerUrlRelease(@"YYModifyNameOrPhone_phone", @"not-release")
/// ---------- BrandModifyInfoCell  end   ---------

// 代理showroom
#define kYYPageShowroomAgent currentServerUrlRelease(@"YYShowroomAgent", @"not-release")
// 销售代表
#define kYYPageSellerList currentServerUrlRelease(@"YYSellerList", @"not-release")
// 新建销售代表
#define kYYPageCreateOrModifySeller currentServerUrlRelease(@"YYCreateOrModifySeller", @"not-release")

// 关于我们
#define kYYPageAboutUs currentServerUrlRelease(@"YYAboutUs", @"not-release")
// 网页（URL、隐私协议、服务协议）
#define kYYPageProtocol currentServerUrlRelease(@"YYProtocol", @"not-release")
// 设置
#define kYYPageSetting currentServerUrlRelease(@"YYSetting", @"not-release")
// 意见反馈
#define kYYPageFeedback currentServerUrlRelease(@"YYFeedback", @"not-release")
// 帮助中心·设计师
#define kYYPageHelp currentServerUrlRelease(@"YYHelp", @"not-release")

#endif /* YYBuride_h */
