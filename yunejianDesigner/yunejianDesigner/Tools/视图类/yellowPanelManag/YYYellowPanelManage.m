//
//  YYYellowPanelManage.m
//  Yunejian
//
//  Created by Apple on 15/11/27.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYYellowPanelManage.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYOrderAddMoneyLogController.h"
#import "YYAlertViewController.h"
#import "YYOrderAddressListController.h"
#import "YYUserCheckAlertViewController.h"
#import "YYOrderStatusRequestCloseViewController.h"
#import "YYOpusSettingViewController.h"
#import "YYHelpPanelViewController.h"
#import "YYOrderAppendViewController.h"
#import "YYOpusSettingDefinedViewController.h"

// 自定义视图
#import "YYBrandInfoView.h"

// 接口
#import "YYUserApi.h"
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderStyleModel.h"
#import "YYOrderInfoModel.h"
#import "YYHomePageModel.h"
#import "YYPaymentNoteListModel.h"

#import "AppDelegate.h"


@implementation YYYellowPanelManage
static YYYellowPanelManage *instance = nil;


+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (YYYellowPanelManage *)instance
{
    
    if (!instance) {
        instance = [[self alloc] init];
    }
    
    return instance;
}

-(void)showOrderAddMoneyLogPanel:(NSString *)storyboardName andIdentifier:(NSString *)identifier orderCode:(NSString*)orderCode totalMoney:(double)totalMoney moneyType:(NSInteger)moneyType parentView:(UIViewController *)specialParentView andCallBack:(void (^)(NSString *orderCode, NSNumber *totalPercent))callback{

    WeakSelf(ws);
    [YYOrderApi getPaymentNoteList:orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYPaymentNoteListModel *paymentNoteList, NSError *error) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        ws.moneyLogViewContorller = [storyboard instantiateViewControllerWithIdentifier:identifier];
        ws.moneyLogViewContorller.totalMoney = totalMoney;
        ws.moneyLogViewContorller.paymentNoteList = paymentNoteList;
        ws.moneyLogViewContorller.moneyType = moneyType;
        ws.moneyLogViewContorller.orderCode = orderCode;
        __block UIViewController *blockParentViewController = specialParentView;
        [ws.moneyLogViewContorller setCancelButtonClicked:^(){
            [blockParentViewController.navigationController popViewControllerAnimated:YES];
        }];
        [ws.moneyLogViewContorller setModifySuccess:^(NSString *orderCode, NSNumber *totalPercent){
            callback(orderCode,totalPercent);
            [blockParentViewController.navigationController popViewControllerAnimated:YES];
        }];
        [specialParentView.navigationController pushViewController:ws.moneyLogViewContorller animated:YES];

    }];
}

-(void)showYellowAlertPanel:(NSString *)storyboardName andIdentifier:(NSString *)identifier title:(NSString*)title msg:(NSString*)msg btn:(NSString*)btnStr align:(NSTextAlignment)textAlignment closeBtn:(BOOL)needCloseBtn andCallBack:(YellowPabelCallBack)callback{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    self.alertViewController= [storyboard instantiateViewControllerWithIdentifier:identifier];
    self.alertViewController.textAlignment = textAlignment;
    self.alertViewController.titelStr = title;
    self.alertViewController.msgStr = msg;
    self.alertViewController.btnStr = btnStr;
    self.alertViewController.needCloseBtn = needCloseBtn;
    self.alertViewController.widthConstraintsValue = 620;
    WeakSelf(ws);
    UIView *showView = self.alertViewController.view;
    __weak UIView *weakShowView = showView;
    [self.alertViewController setCancelButtonClicked:^(NSString *value){
        if([value isEqualToString:@"makesure"]){
            callback(nil);
        }
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.alertViewController);
    }];
    [self addToWindow:self.alertViewController parentView:nil];

}

-(void)showSamllYellowAlertPanel:(NSString *)storyboardName andIdentifier:(NSString *)identifier title:(NSString*)title msg:(NSString*)msg btn:(NSString*)btnStr align:(NSTextAlignment)textAlignment closeBtn:(BOOL)needCloseBtn parentView:(UIView *)specialParentView  andCallBack:(YellowPabelCallBack)callback{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    self.alertViewController= [storyboard instantiateViewControllerWithIdentifier:identifier];
    self.alertViewController.textAlignment = textAlignment;
    self.alertViewController.titelStr = title;
    self.alertViewController.msgStr = msg;
    self.alertViewController.btnStr = btnStr;
    self.alertViewController.needCloseBtn = needCloseBtn;
    self.alertViewController.widthConstraintsValue = MIN(325, SCREEN_WIDTH-30);
    WeakSelf(ws);
    UIView *showView = self.alertViewController.view;
    __weak UIView *weakShowView = showView;
    [self.alertViewController setCancelButtonClicked:^(NSString *value){
        if([value isEqualToString:@"makesure"]){
            callback(nil);
        }
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.alertViewController);
    }];
    [self addToWindow:self.alertViewController parentView:nil];

}

-(void)showOrderBuyerAddressListPanel:(NSString *)storyboardName andIdentifier:(NSString *)identifier needUnDefineBuyer:(NSInteger)needUnDefineBuyer parentView:(UIViewController *)specialParentView andCallBack:(YellowPabelCallBack)callback{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    self.buyerAddressListController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    self.buyerAddressListController.needUnDefineBuyer = needUnDefineBuyer;
    
    __block UIViewController *blockParentViewController = specialParentView;
    [self.buyerAddressListController setCancelButtonClicked:^(){
        //removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,weakSelf.moneyLogViewContorller);
        [blockParentViewController.navigationController popViewControllerAnimated:YES];
    }];
    [self.buyerAddressListController setMakeSureButtonClicked:^(NSString* name,YYBuyerModel *infoModel){
        if(infoModel){
            callback(@[name,infoModel]);
        }else{
            callback(@[name]);
        }
        [blockParentViewController.navigationController popViewControllerAnimated:YES];
    }];
    [specialParentView.navigationController pushViewController:self.buyerAddressListController animated:YES];

}

-(void)showStyleDiscountPanel:(NSString *)storyboardName andIdentifier:(NSString *)identifier
                        type:(DiscountType)type
                        orderStyleModel:(YYOrderStyleModel *)orderStyleModel orderInfoModel:(YYOrderInfoModel *)orderInfoModel
                        AndSeriesId:(long)seriesId
                        originalPrice:(float)originalPrice
                        finalPrice:(float)finalPrice parentView:(UIViewController *)specialParentView andCallBack:(YellowPabelCallBack)callback{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    self.discountViewController = [storyboard instantiateViewControllerWithIdentifier:identifier];
    self.discountViewController.currentDiscountType = type;
    self.discountViewController.orderStyleModel = orderStyleModel;
    self.discountViewController.currentYYOrderInfoModel =orderInfoModel;
    self.discountViewController.seriesId = seriesId;    
    self.discountViewController.originalTotalPrice = originalPrice;
    self.discountViewController.finalTotalPrice = finalPrice;

    __block UIViewController *blockParentViewController = specialParentView;

    [self.discountViewController setCancelButtonClicked:^(){
        [blockParentViewController.navigationController popViewControllerAnimated:YES];
    }];
    [self.discountViewController setModifySuccess:^(NSArray *value){
        callback(value);
        [blockParentViewController.navigationController popViewControllerAnimated:YES];

    }];
    [specialParentView.navigationController pushViewController:self.discountViewController animated:YES];
}

-(void)addToWindow:(UIViewController *)controller parentView:(UIView *)specialParentView {
    if(specialParentView !=nil){
        self.parentView = specialParentView;
    }else{//
        //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.parentView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    }
    __weak UIView *weakSuperView = self.parentView;
    UIView *showView = controller.view;
    
    [self.parentView addSubview:showView];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSuperView.mas_top);
        make.left.equalTo(weakSuperView.mas_left);
        make.bottom.equalTo(weakSuperView.mas_bottom);
        make.right.equalTo(weakSuperView.mas_right);
        
    }];
    addAnimateWhenAddSubview(showView);
}

-(void)showYellowUserCheckAlertPanel:(NSString *)storyboardName andIdentifier:(NSString *)identifier title:(NSString*)title msg:(NSString*)msg iconStr:(NSString*)iconStr btnStr:(NSString*)btnStr align:(NSTextAlignment)textAlignment closeBtn:(BOOL)needCloseBtn  funArray:(NSArray *)funArray andCallBack:(YellowPabelCallBack)callback{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    self.userCheckAlertViewController= [storyboard instantiateViewControllerWithIdentifier:identifier];
    self.userCheckAlertViewController.textAlignment = textAlignment;
    self.userCheckAlertViewController.titelStr = title;
    self.userCheckAlertViewController.msgStr = msg;
    self.userCheckAlertViewController.btnStr = btnStr;
    self.userCheckAlertViewController.iconStr = iconStr;
    self.userCheckAlertViewController.needCloseBtn = needCloseBtn;
    self.userCheckAlertViewController.funArray = funArray;
    //self.userCheckAlertViewController.noLongerRemindKey = noLongerRemindKey;
    WeakSelf(ws);
    UIView *showView = self.userCheckAlertViewController.view;
    showView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.80];
    __weak UIView *weakShowView = showView;
    [self.userCheckAlertViewController setCancelButtonClicked:^(){
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.userCheckAlertViewController);
    }];
    [self.userCheckAlertViewController setModifySuccess:^(){
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.userCheckAlertViewController);
        callback(nil);
    }];
    [self addToWindow:self.userCheckAlertViewController parentView:nil];
}
-(void)showOrderStatusRequestClosePanelWidthParentView:(UIView *)specialParentView currentYYOrderInfoModel:(YYOrderInfoModel *)currentYYOrderInfoModel andCallBack:(YellowPabelCallBack)callback{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
    self.orderStatusRequestCloseViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderStatusRequestCloseViewController"];
    self.orderStatusRequestCloseViewController.currentYYOrderInfoModel =  currentYYOrderInfoModel;
    WeakSelf(ws);
    UIView *showView = self.orderStatusRequestCloseViewController.view;
    __weak UIView *weakShowView = showView;
    [self.orderStatusRequestCloseViewController setCancelButtonClicked:^(){
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.discountViewController);
    }];
    [self.orderStatusRequestCloseViewController setModifySuccess:^(){
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.discountViewController);
        callback(nil);
    }];
    [self addToWindow:self.orderStatusRequestCloseViewController parentView:specialParentView];
}

-(void)showBrandInfoView:(YYHomePageModel *)homePageModel orderCode:(NSString *)orderCode designerId:(NSInteger)designerId{
    YYBrandInfoView *brandInfoView = nil;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"YYBrandInfoView" owner:nil options:nil];
    Class  targetClass = NSClassFromString(@"YYBrandInfoView");
    for (UIView *view in views) {
        if ([view isMemberOfClass:targetClass]) {
            brandInfoView =  (YYBrandInfoView *)view;

            break;
        }
    }
    if(brandInfoView == nil){
        return;
    }
    if(homePageModel != nil && homePageModel.brandIntroduction != nil){
        NSString *phone = (homePageModel.brandIntroduction.phone?homePageModel.brandIntroduction.phone:@"");
        NSString *email = (homePageModel.brandIntroduction.email?homePageModel.brandIntroduction.email:@"");
        NSString *qq = (homePageModel.brandIntroduction.qq?homePageModel.brandIntroduction.qq:@"");
        NSString *weixin = (homePageModel.brandIntroduction.weixin?homePageModel.brandIntroduction.weixin:@"");
        [brandInfoView updateUI:@[phone,email,qq,weixin]];
    }else{
        __block YYBrandInfoView *blockBrandInfoView = brandInfoView;
        [YYUserApi getOrderDesignerInfoBrandInfo:orderCode designerId:designerId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYHomePageModel *homePageModel, NSError *error) {
            if(rspStatusAndMessage.status == kCode100 && blockBrandInfoView != nil){
                NSString *phone = (homePageModel.brandIntroduction.phone?homePageModel.brandIntroduction.phone:@"");
                NSString *email = (homePageModel.brandIntroduction.email?homePageModel.brandIntroduction.email:@"");
                NSString *qq = (homePageModel.brandIntroduction.qq?homePageModel.brandIntroduction.qq:@"");
                NSString *weixin = (homePageModel.brandIntroduction.weixin?homePageModel.brandIntroduction.weixin:@"");
                [blockBrandInfoView updateUI:@[phone,email,qq,weixin]];
            }
        }];
    }
    
    NSInteger infoUIWidth = CGRectGetWidth(brandInfoView.frame);
    NSInteger infoUIHeight = CGRectGetHeight(brandInfoView.frame);
    CMAlertView *alertView = [[CMAlertView alloc] initWithViews:@[brandInfoView] imageFrame:CGRectMake(0, 0, infoUIWidth, infoUIHeight) bgClose:NO];
    //brandInfoView.layer.cornerRadius = 5;
    //brandInfoView.layer.masksToBounds = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    alertView.specialParentView = appDelegate.mainViewController.topViewController.view;
    alertView.backgroundColor = [UIColor clearColor];
    [alertView show];
}

-(void)showOpusSettingpanelWidthParentView:(UIView *)specialParentView seriesId:(NSInteger)seriesId andCallBack:(YellowPabelCallBack)callback{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Opus" bundle:[NSBundle mainBundle]];
    self.opusSettingViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOpusSettingViewController"];
    self.opusSettingViewController.seriesId = seriesId;
    WeakSelf(ws);
    UIView *showView = self.opusSettingViewController.view;
    __weak UIView *weakShowView = showView;
    [self.opusSettingViewController setCancelButtonClicked:^(){
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.opusSettingViewController);
    }];
    [self.opusSettingViewController setSelectedValue:^(NSString *value){
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.opusSettingViewController);
        callback(@[value]);
    }];
    [self addToWindow:self.opusSettingViewController parentView:specialParentView];
    
}

-(void)showhelpPanelWidthParentView:(UIView *)specialParentView  helpPanelType:(HelpPanelType)helpPanelType andCallBack:(YellowPabelCallBack)callback{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.helpPanelViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYHelpPanelViewController"];
    self.helpPanelViewController.helpPanelType = helpPanelType;
    WeakSelf(ws);
    UIView *showView = self.helpPanelViewController.view;
    __weak UIView *weakShowView = showView;
    [self.helpPanelViewController setCancelButtonClicked:^(){
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.helpPanelViewController);
    }];
    [self addToWindow:self.helpPanelViewController parentView:specialParentView];

}

-(void)showOrderAppendViewWidthParentView:(UIViewController *)specialParentView info:(NSArray*)info andCallBack:(YellowPabelCallBack)callback{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
    self.orderAppendViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderAppendViewController"];
    self.orderAppendViewController.ordreCode = [info objectAtIndex:0];
    __block UIViewController *blockParentViewController = specialParentView;
    [self.orderAppendViewController setCancelButtonClicked:^(){
        [blockParentViewController.navigationController popViewControllerAnimated:YES];
    }];
    [self.orderAppendViewController setModifySuccess:^(NSArray *value){
        [blockParentViewController.navigationController popViewControllerAnimated:NO];
        callback(value);
    }];
    [specialParentView.navigationController pushViewController:self.orderAppendViewController animated:YES];

}

-(void)showOpusSettingDefinedViewWidthParentView:(UIViewController *)specialParentView info:(NSArray*)info andCallBack:(YellowPabelCallBack)callback{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Opus" bundle:[NSBundle mainBundle]];
    self.opusSettingDefinedViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOpusSettingDefinedViewController"];
    self.opusSettingDefinedViewController.seriesId = [[info objectAtIndex:0] integerValue];
    self.opusSettingDefinedViewController.authType = [[info objectAtIndex:1] integerValue];
    __block UIViewController *blockParentViewController = specialParentView;
    [self.opusSettingDefinedViewController setCancelButtonClicked:^(){
        [blockParentViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.opusSettingDefinedViewController setSelectedValue:^(NSString *value){
        [blockParentViewController dismissViewControllerAnimated:YES completion:nil];
        callback(@[value]);
    }];
    [specialParentView presentViewController:self.opusSettingDefinedViewController animated:YES completion:nil];
}
@end
