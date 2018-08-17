//
//  CommonRegularMacro.h
//  yunejianDesigner
//
//  Created by yyj on 2017/8/2.
//  Copyright © 2017年 Apple. All rights reserved.
//

#ifndef CommonRegularMacro_h
#define CommonRegularMacro_h

// 临时检测代码执行时间
#define CURRENTTIME double start =  CFAbsoluteTimeGetCurrent()*1000;

#define DIFFTIME NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent()*1000 - start);

#pragma mark - 常用
/** 默认翻页数量 */
#define kPageSize 16
/** 默认最大翻页数量 */
#define kMaxPageSize 500
/** toast动画持续时间 单位（毫秒） */
#define kAlertToastDuration 2000
/** 添加弹框视图时，动画时间 */
#define kAddSubviewAnimateDuration 0.5
/** app远程资源路径 */
#define kYYServerResURL @"http://cdn2.ycosystem.com/yej-tb/ios/"
/** 官网 */
#define KYYYcoFoundationURL @"http://www.ycofoundation.com"

/** 服务端地址 */
#define kLastYYServerURL @"kLastYYServerURL"
/** 更新服务端地址版本 */
#define kLastServerVersin @"kLastServerVersin"
/** 更新介绍页版本 */
#define lastIntroductionVersin @"LastIntroductionViewVersion"
/** 打包版本号 */
#define kYYCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/** 封面图片尺寸 */
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
/** 弱网络提示 */
#define kNetworkIsOfflineTips NSLocalizedString(@"当前网络不通，请检查您的网络",nil)
/** 弱指针 */
#define WeakSelf(ws) __weak __typeof(&*self)ws = self
/** 强指针 */
#define StrongSelf(weakSelf)  __strong __typeof(weakSelf)strongSelf = weakSelf;
/** 判断当前系统是否为iOS 9以上 */
#define kIOSVersions_v9 [[[UIDevice currentDevice] systemVersion] floatValue]>=9.0


#pragma mark - Color
/** 默认图片背景颜色 */
#define kDefaultImageColor @"efefef"
/** 默认label颜色 phone */
#define kDefaultTitleColor_phone @"919191"
/** 默认label颜色 pad */
#define kDefaultTitleColor_pad @"646464"
/** 默认边框颜色 */
#define kDefaultBorderColor @"afafaf"
/** 另一种边框颜色 */
#define kBorderColor [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]
/** 默认蓝色 */
#define kDefaultBlueColor @"47a3dc"
/** 默认视图背景颜色 */
#define kDefaultBGColor @"fafafa"
/** 黑色 平常使用 不要用[UIColor blackColor] ，用_define_black_color */
#define _define_black_color [UIColor blackColor]
/** 白色 平常使用 不要用[UIColor whiteColor] ，用_define_white_color */
#define _define_white_color [UIColor whiteColor]
/** 其他颜色 */
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)


#pragma mark - 图片尺寸
/** 系列列表的封面 */
#define kSeriesCover IS_RETINA?@"-z320.png":@"-z160.png"
/** 款式列表的封面 */
#define kStyleCover IS_RETINA?@"-z400.png":@"-z200.jpg"
/** 款式大图 */
#define kStyleDetailCover IS_RETINA?@"-z1200.png":@"-z600.jpg"
/** 款式颜色图片 */
#define kStyleColorImageCover IS_RETINA?@"-z88.png":@"-z44.png"
/** 买家名片图片 */
#define kBuyerCardImage @"-z500.jpg"
/** 账户界面LOGO封面 */
#define kLogoCover IS_RETINA?@"-z260.png":@"-z130.png"
/** 名片 */
#define kUserCard @"-z1000.png"
/** lookBook封面 */
#define kLookBookCover IS_RETINA?@"-z400.png":@"-z200.jpg"
/** lookBook图片 */
#define kLookBookImage IS_RETINA?@"-z1200.png":@"-z600.jpg"
/** 新闻封面 */
#define kNewsCover IS_RETINA?@"-z400.png":@"-z200.jpg"
/** 聊天图片 */
#define kSendMessageImage IS_RETINA?@"-z160.png":@"-z80.jpg"
#define kSendMessageBigImage  IS_RETINA?@"-z1200.png":@"-z600.jpg"


#pragma mark - 机型判断
/** 判断是否为5.8英寸屏幕 */
#define kIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断是否为5.5英寸屏幕 */
#define kIPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断是否为4.7寸屏幕 */
#define kIPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断是否为4英寸屏幕 */
#define kIPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断是否3.5英寸屏幕 */
#define kIPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 判断当前设备是否为iPhone 6Plus以上 */
#define IsPhone6Plus_gt kIPhoneX||kIPhone6Plus
/** 判断当前设备是否为iPhone 6以上 */
#define IsPhone6_gt kIPhoneX||kIPhone6Plus||kIPhone6
/** 判断当前设备是否为iPhone 5以上 */
#define IsPhone5_gt kIPhoneX||kIPhone6Plus||kIPhone6||kIPhone5s
/** 是否是pad */
#define _isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/** 是否是phone */
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


#pragma mark - 检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#pragma mark - 消息类型

//App BecomeActive
#define kApplicationDidBecomeActive @"kApplicationDidBecomeActive"

//面板调整消息类型
#define kShowAccountNotification @"kShowAccountNotification"
#define kNeedLoginNotification @"kNeedLoginNotification"
#define kShowBrandListNotification @"kShowBrandListNotification"
#define kShowOrderListNotification @"kShowOrderListNotification"
#define kOrderAddStyleNotification @"kOrderAddStyleNotification"
#define kUpdateShoppingCarNotification @"kUpdateShoppingCarNotification"
//#define kShowInventoryNotification @"kShowInventoryNotification"
#define kShowStyleNotification @"kShowStyleNotification"

//不再提醒类别
#define kNoLongerRemindBrandRegister @"kNoLongerRemindBrandRegister"

//通知
#define UserTypeChangeNotification  @"LastIntroductionViewVersion"//角色类型变更 更新界面
#define UserTypeChangeKey @"UserTypeChangeKey" //角色类型变化
#define UserCheckStatusChangeNotification @"UserCheckStatusChangeNotification" //隐身用户checkStatus
#define UnreadMsgAmountChangeNotification @"UnreadMsgAmountChangeNotification" //消息中心变化
#define UnreadMsgAmountStatusChangeNotification @"UnreadMsgAmountStatusChangeNotification"//预约申请状态变更
//#define UnreadNewsNotifyMsgAmount @"UnreadNewsNotifyMsgAmount" //新闻消息变化
#define UnreadInventoryNotifyMsgAmount @"UnreadInventoryNotifyMsgAmount" //库存消息变化
#define UnreadOrderNotifyMsgAmount @"UnreadOrderNotifyMsgAmount" //唯独消息变化
#define UnreadConnNotifyMsgAmount @"UnreadConnNotifyMsgAmount" //唯独消息变化
#define VisibleInfoPostIsOk @"visibleInfoPostIsOk" //隐形账号填写信息完成后返回界面

//库存开通状态
#define StockStatusVoid @"VOID" //未申请通过
#define StockStatusInit @"INIT" //申请中
#define StockStatusNormal @"NORMAL" //已开通
#define StockStatusClosed @"CLOSED" //已关闭

// 网络状态变化
#define kNetWorkSpaceChangedNotification @"kNetWorkSpaceChangedNotification"

#pragma mark - 其他
//款式排序
//SERIES 按系列创建时间升序
//SERIES_DESC按系列创建时间降序
//MODIFYTIME 按款式修改时间升序
//MODIFYTIME_DESC 按款式修改时间降序
#define kSORT_STYLE_CODE @"STYLE_CODE"//STYLE_CODE 按款号升序
#define kSORT_STYLE_CODE_DESC @"STYLE_CODE_DESC"//STYLE_CODE_DESC按款号降序


#pragma mark - 日志相关
//-------------------打印日志-------------------------

#ifdef DEBUG
// 自定义打印时使用
#define NSLog(FORMAT, ...) printf("%s: [Line %d]: %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

// 网络日志
#define NETLog(FORMAT, ...) printf("[Line %d]: %s\n",__LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

#else

#define NSLog(format, ...)
#define NETLog(format, ...)

#endif


#endif /* CommonRegularMacro_h */

