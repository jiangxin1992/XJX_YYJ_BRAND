//
//  CommonHelper.h
//  CMNewspaper
//
//  Created by xuy on 13-12-30.
//  Copyright (c) 2013年 xuy. All rights reserved.
//
/***********************公共类***********************/
#import <UIKit/UIKit.h>

#import "CommonEnumMacro.h"

@class YYOrderStyleModel,YYStylesAndTotalPriceModel,YYOrderBuyerAddress,YYOrderOneColorModel,StyleDateRange,YYDateRangeModel;

EEnvironmentType currentEnvironment();

char charToBinary(char value);

NSString *GetApplicationPath(NSString *applicationPathName);

NSString *GetCachePath(NSString *applicationPathName, NSString *cachePathName, BOOL willCreate);

NSString *getMD5String(NSString *str);

NSData *hexStringToByte(NSString *str);

//获取yyj文件路径
NSString *yyjDocumentsDirectory();

//点击网址（打开链接／复制网址）
void clickWebUrl_phone(NSString *webUrl);
void clickWebUrl_pad(NSString *webUrl ,UIView *clickView);

//打电话
void callSomeone(NSString *realPhoneNum, NSString *showPhoneNum);

//发邮件
void sendEmail(NSString *email);

//获取Window当前显示的ViewController
UIViewController *getCurrentViewController();

//获取当前屏幕中present出来的viewcontroller
UIViewController *getPresentedViewController();

//固定内容 字体下 获取高度
CGFloat getHeightWithWidth(CGFloat width, NSString *content, UIFont *font);

//固定内容 字体下 获取宽度
CGFloat getWidthWithHeight(CGFloat height,NSString *content, UIFont *font);

//获取文本高度
NSInteger getTxtHeight(float txtWidth,NSString *text,NSDictionary *txtDict);

//获取导航栏
//UIView *setNavView(NSString *title,UIView *supview);

//将时间戳转换成时间
NSDate *getDate(long time);

//时间戳转时间
NSString *getTimeStr(long time,NSString *formatter);

//获取网址+http
NSString *getWebUrl(NSString *website);

//获取html、content 内容、font 字体大小、字体颜色
NSString *getHTMLStringWithContent_phone(NSString *content,NSString *font,NSString *color);
NSString *getHTMLStringWithContent_pad(NSString *content,NSString *font,NSString *color);

NSString *trimWhitespaceOfStr(NSString *string);

//历史账号存放路径
NSString *getUsersStorePath();
//历史订单搜索数据
NSString *getOrderSearchNoteStorePath();
//历史库存存放路径
NSString *getInventorySearchNoteStorePath();
//弹出窗口添加白色，60%透明背影层
void popWindowAddBgView(UIView *superView);

//添加暂无数据视图
UIView *addNoDataView_phone(UIView *superView,NSString *title,NSString *titleColor,NSString *img);
UIView *addNoDataView_pad(UIView *superView,NSString *title,NSString *titleColor,NSString *img);

//添加子视图时加上动画
void addAnimateWhenAddSubview(UIView *view);
//使用动画从父视图中删除
void removeFromSuperviewUseUseAnimateAndDeallocViewController(UIView *view,UIViewController *viewController);
//根据格式获取显示时间
NSString *getShowDateByFormatAndTimeInterval(NSString *format,NSString *timeInterval);
NSComparisonResult compareNowDate(NSString *timeInterval);
//防止icloud备份
BOOL addSkipBackupAttributeToItemAtURL(NSURL *URL);

//根据一个款式计算该款式所有件数
int calculateTotalsForOneStyle(YYOrderStyleModel *orderStyleModel);

//获取本地购物车中的款式数量
YYStylesAndTotalPriceModel *getLocalShoppingCartStyleCount(NSArray *cartbarndInfo);

//创建订单的分享码
NSString *createOrderSharecode();
//买家地址格式
NSString *getBuyerAddressStr_phone(YYOrderBuyerAddress *buyerAddress);
NSString *getBuyerAddressStr_pad(YYOrderBuyerAddress *buyerAddress);
//设置menuUI
void setMenuUI_phone(id controller,UIView *view,NSArray *menuData);
void setMenuUI_pad(id controller,UIView *view,NSArray *menuData);

UIButton *creatMenuBtn_phone(NSString *icon, NSString *titel,CGRect frame ,NSInteger tag);
UIButton *creatMenuBtn_pad(NSString *icon, NSString *titel,CGRect frame ,NSInteger tag);

void writeImageWithRelativePath(NSString *imageRelativePath, NSString *storePath,UIImage *image, NSString *size);

//订单关联状态名称
NSString *getOrderConnStatusName_brand(NSInteger status, BOOL needFlag);
NSString *getOrderConnStatusName_buyer(NSInteger status);
NSString *getOrderConnStatusName_pad(NSInteger status);
//获取订单状态
NSInteger getOrderTransStatus(NSNumber *designerTransStatus,NSNumber *buyerTransStatus);
//订单状态名称
NSString *getOrderStatusName_detail(NSInteger transStatus,BOOL needNum);
NSString *getOrderStatusName_short(NSInteger status);
//订单状态按钮名称
NSString *getOrderStatusBtnName_brand(NSInteger status);
NSString *getOrderStatusBtnName_buyer(NSInteger status);
NSString *getOrderStatusBtnName_pad(NSInteger status);

NSString *getOrderStatusAlertTip(NSInteger status);
//订单状态按钮名称
NSInteger getOrderNextStatus(NSInteger status);
//订单状态按钮提示
NSString *getOrderStatusDesignerTip_phone(NSInteger status);
NSString *getOrderStatusDesignerTip_pad(NSInteger status);
//订单状态按钮提示
NSString *getOrderStatusBuyerTip(NSInteger status);

NSLayoutConstraint *getUIViewLayoutConstraint(UIView *ui ,NSLayoutAttribute layoutAttribute);
//压缩图片
UIImage *compressImage(UIImage *image, NSInteger maxFileSize);
//是否某个颜色款式有数量
BOOL checkOrderOneColorHasAmount(YYOrderOneColorModel *orderOneColorModel);
//替换某个货币字符
NSString *replaceMoneyFlag(NSString *txt,NSInteger moneyType);
//获取某个品牌moneyType
NSInteger getMoneyType(NSInteger designerId);
//md5
NSString * md5(NSString *inPutText);
//精确的货币计算
NSString *decimalNumberMutiplyWithString(NSString *multiplierValue,NSString *multiplicandValue);
//波段类型转换
StyleDateRange *transferToStyleDateRange(YYDateRangeModel* dateRangeModel);
YYDateRangeModel*transferToYYDateRangeModel(StyleDateRange *dateRange);

//json
NSString* DataTOjsonString(id object);
id toArrayOrNSDictionary(NSString *jsonString);
//数组装json
NSString * objArrayToJSON(NSArray *array);
// 把格式化的JSON格式的字符串转换成字典
NSDictionary *dictionaryWithJsonString(NSString *jsonString);

//获取中文字体
UIFont *getFont(CGFloat font);

//获取中文粗体
UIFont *getSemiboldFont(CGFloat font);

//获取英文字体
UIFont *get_en_Font(CGFloat font);

void setBorder(UIView *view);
void setCornerRadiusBorder(UIView *view);
void setBorderCustom(UIView *view,CGFloat borderWidth,UIColor *borderColor);

UIAlertController *alertTitleCancel_Simple(NSString *title,void (^block)());

/****************解析数据****************/
/**
 * +82 15868191992 ----> 82
 * +82 中国 ----> 82
 *  ++ 15868191992 ----> ++ (好去判断这个状态)
 *  ++ 美国 ----> ++ (好去判断这个状态)
 *     15868191992 ----> 空
 */
NSString *getCountryCode(NSString *completePhoneDes);

/**
 * +82 15868191992 ----> +82 韩国
 *  ++ 15868191992 ----> +86 中国
 *     15868191992 ----> +86 中国
 */
NSString *getCountryCodeDetailDes(NSString *completePhoneDes);
/**
 * +82 ----> +82 韩国
 *  ++ ----> +86 中国
 *  空 ----> +86 中国
 */
NSString *getCountryCodeDetailDesByCode(NSString *_countryCode);

/**
 * +82 15868191992 ----> 15868191992
 *  ++ 15868191992 ----> 15868191992
 *     15868191992 ----> 15868191992
 *             +86 ----> 空
 *              空 ----> 空
 */
NSString *getPhoneNum(NSString *completePhoneDes);

/**
 * 浙江 ----> 浙江
 *   - ----> 空
 *  空 ----> 空
 */
NSString *getProvince(NSString *provinceStr);

/**
 * +82 15868191992 | 91 ---->+91 15868191992
 *  ++ 15868191992 | 91 ---->+91 15868191992
 *     15868191992 | 91 ---->+91 15868191992
 *             +86 | 91 ---->+91
 *              空 | 91 ---->+91
 */
NSString *changeCountryCodeDetailDesByNewCode(NSString *completePhoneDes,NSInteger NewCountryCode);

/**
 * +82 15868191992 | 15555555555 ---->+82 15555555555
 *  ++ 15868191992 | 15555555555 ---->++ 15555555555
 *     15868191992 | 15555555555 ---->15555555555
 *             +82 | 15555555555 ---->+82 15555555555
 *              空 | 15555555555 ---->15555555555
 */
NSString *changeCountryCodeDetailDesByNewPhoneNum(NSString *completePhoneDes,NSString *NewPhoneNum);

/****************查询本地数据****************/
//根据格式获取区号数组
NSArray *getContactLocalData();
//根据区号code 获取区号信息
NSString *getContactLocalType(NSInteger type);

//联系权限数据
NSArray *getContactLimitData();
NSString *getContactLimitType(NSInteger type);

/****************税率相关****************/
//判断是否显示加税
BOOL needPayTaxView(NSInteger moneyType);
//加税显示数据
NSArray *getPayTaxData(BOOL isTxt);
NSString *getPayTaxType(NSInteger type,BOOL isTxt);
//NSInteger getPayTaxTypeToService(NSInteger type);
//NSInteger getPayTaxTypeFormService(NSInteger value);


/**
 * 获取税率初始化数据 不加税/17%税/自定义税率
 */
NSMutableArray *getPayTaxInitData();

/**
 * 注：只提供修改自定义税率接口 更安全😊
 *    其他类型税率是不变的
 * DES 修改自定义税率
 */
void updateCustomTaxValue(NSMutableArray *taxData,NSNumber *value,BOOL shouldClear);

/**
 * 获取对应的描述
 *   %17 VAT | 1 ------> 17%税
 *  Tax Free | 0 ------> Tax
 *   taxData | 2 ------> 0.22
 */

NSString *getPayTaxValue(NSMutableArray *taxData,NSInteger type,BOOL isTxt);

/**
 * 获取对应的描述
 *   taxData | 0 ------> 0
 *   taxData | 1 ------> 17
 *   taxData | 2 ------> 22
 */
NSInteger getPayTaxTypeToServiceNew(NSMutableArray *taxData,NSInteger value);

/**
 * 获取整数形式税率对应的index
 *   taxData | 0 ------> 0
 *   taxData | 17 ------> 1
 *   taxData | 30 ------> 2
 */
NSInteger getPayTaxTypeFormServiceNew(NSMutableArray *taxData,NSInteger value);

