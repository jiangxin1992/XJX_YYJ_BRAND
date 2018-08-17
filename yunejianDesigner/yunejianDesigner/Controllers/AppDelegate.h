//
//  AppDelegate.h
//  Yunejian
//
//  Created by yyj on 15/7/3.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderInfoModel,YYOpusSeriesModel,YYStyleOneColorModel,YYOrderStyleModel,YYOrderOneInfoModel,YYOpusStyleModel,YYBrandSeriesToCartTempModel,YYMessageUnreadModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) NSInteger leftMenuIndex;//跳转tabIndex
@property (nonatomic, strong) NSString *openURLInfo;//跳转url跳转信息
@property (nonatomic, assign) CGFloat keyBoardHeight;
@property (nonatomic, assign) BOOL keyBoardIsShowNow;

@property (nonatomic, strong) YYMessageUnreadModel *messageUnreadModel;

@property (nonatomic, strong) YYOrderInfoModel *cartModel;//购物车对象
@property (nonatomic, strong) NSMutableArray *seriesArray;//系列数组

@property (atomic, strong) NSMutableArray *cartDesignerIdArray;//购物车品牌关键数组

@property (nonatomic, strong) YYOrderInfoModel *orderModel;//订单对象，修改订单中的添加款式要用到
@property (nonatomic, strong) NSMutableArray *orderSeriesArray;//订单系列数组，修改订单中的添加款式要用到
@property (nonatomic, strong) YYOrderInfoModel *currentYYOrderInfoModel;//修改订单临时数据

@property (nonatomic, strong) UINavigationController *mainViewController;//首页视图

@property (nonatomic) bool inRunLoop;
@property (nonatomic, strong) NSThread* myThread;

/**
 清空本地购物车
 */
- (void)clearBuyCar;

/**
 初始化或更新(brandName和brandLogo)购物车信息
 */
- (void)initOrUpdateShoppingCarInfo:(NSNumber *)designerId;

/**
 清空delegate下的临时数据
 */
- (void)delegateTempDataClear;

/**
 获取用户未读消息数量，并更新
 */
- (void)checkNoticeCount;

/**
 根据index更新首页的模块视图

 @param index ...
 */
- (void)reloadRootViewController:(NSInteger)index;

/**
 进入主页
 */
- (void)enterMainIndexPage;

/**
 进入登录页面
 */
- (void)enterLoginPage;

/**
 进入系列详情

 @param designerId ...
 @param seriesId ...
 @param viewController ...
 */
- (void)showSeriesInfoViewController:(NSNumber*)designerId seriesId:(NSNumber*)seriesId parentViewController:(UIViewController*)viewController;

- (void)showBuildOrderViewController:(YYOrderInfoModel *)orderInfoModel parent:(UIViewController *)parentViewController isCreatOrder:(Boolean)isCreatOrder isReBuildOrder:(Boolean)isReBuildOrder isAppendOrder:(Boolean)isAppendOrder isFromCardDetail:(BOOL )isFromCardDetail modifySuccess:(ModifySuccess)modifySuccess;
- (void)showBuyerInfoViewController:(NSNumber *)buyerId WithBuyerName:(NSString *)buyerName parentViewController:(UIViewController *)viewController WithReqSuccessBlock:(void(^)())reqSuccessblock WithHomePageCancelBlock:(CancelButtonClicked )cancelblock WithModifySuccessBlock:(ModifySuccess )modifySuccessblock;
- (void)showStyleInfoViewController:(YYOrderInfoModel *)infoModel oneInfoModel:(YYOrderOneInfoModel *)oneInfoModel orderStyleModel:(YYOrderStyleModel *)styleModel parentViewController:(UIViewController*)viewController;
- (void)showStyleInfoViewController:(YYStyleOneColorModel *)infoModel parentViewController:(UIViewController*)viewController IsShowroomToScan:(BOOL)isShowroomToScan;
- (void)showShoppingView:(BOOL )isModifyOrder styleInfoModel:(id )styleInfoModel seriesModel:(id)seriesModel opusStyleModel:(YYOpusStyleModel *)opusStyleModel parentView:(UIView *)parentView fromBrandSeriesView:(BOOL )isFromSeries WithBlock:(void (^)(YYBrandSeriesToCartTempModel *brandSeriesToCardTempModel))block;
- (void)showMessageView:(NSArray*)info parentViewController:(UIViewController*)viewController;
- (void)showStyleDetailWithStyleId:(NSInteger)styleId parentViewController:(UIViewController*)viewController;

@end

