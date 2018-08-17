//
//  CommonHelper.m
//  CMNewspaper
//
//  Created by zhu on 13-12-30.
//  Copyright (c) 2013年 zhu. All rights reserved.
//

#ifdef __IPHONE_5_0
#include <sys/xattr.h>
#endif

#import <zlib.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <CommonCrypto/CommonDigest.h>

#import "regular.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "UIImage+GIF.h"
#import "UserDefaultsMacro.h"

#import "UIImage+YYImage.h"
#import "NSManagedObject+helper.h"

#import "YYNoDataView.h"

#import "YYOrderInfoModel.h"
#import "YYOrderStyleModel.h"
#import "YYStylesAndTotalPriceModel.h"
#import "YYOrderBuyerAddress.h"
#import "YYOrderOneColorModel.h"
#import "StyleDateRange.h"
#import "YYDateRangeModel.h"

EEnvironmentType currentEnvironment(){
    NSString *serverURL = [[NSUserDefaults standardUserDefaults] objectForKey:kLastYYServerURL];
    if([serverURL containsString:@"test.ycosystem.com"]){
        return EEnvironmentTEST;
    }else if([serverURL containsString:@"show.ycofoundation.com"]){
        return EEnvironmentSHOW;
    }else if([serverURL containsString:@"ycosystem.com"]){
        return EEnvironmentPROD;
    }
    return EEnvironmentTEST;
}
//点击网址（打开链接／复制网址）
void clickWebUrl_phone(NSString *webUrl){
    if(![NSString isNilOrEmpty:webUrl])
    {
        NSString *tempWebUrl = getWebUrl(webUrl);

        UIAlertController * alertController = [regular getAlertWithFirstActionTitle:NSLocalizedString(@"打开链接",nil) FirstActionBlock:^{

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempWebUrl]];

        } SecondActionTwoTitle:NSLocalizedString(@"复制网址",nil) SecondActionBlock:^{

            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = tempWebUrl;
            [YYToast showToastWithTitle:NSLocalizedString(@"复制成功",nil) andDuration:kAlertToastDuration];

        }];
        UIViewController *currentVC = getCurrentViewController();
        [currentVC presentViewController:alertController animated:YES completion:nil];
    }
}
void clickWebUrl_pad(NSString *webUrl ,UIView *clickView){
    if(![NSString isNilOrEmpty:webUrl])
    {
        NSString *tempWebUrl = getWebUrl(webUrl);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
        alertController.view.backgroundColor=[UIColor clearColor];


        UIAlertAction *copyAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"复制网址",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = tempWebUrl;

            [YYToast showToastWithTitle:NSLocalizedString(@"复制成功",nil) andDuration:kAlertToastDuration];
        }];

        UIAlertAction *openAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"打开",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempWebUrl]];
        }];

        [alertController addAction:openAction];
        [alertController addAction:copyAction];
        UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];

        popPresenter.sourceView = clickView;
        popPresenter.sourceRect = clickView.bounds;
        UIViewController *currentVC = getCurrentViewController();
        [currentVC presentViewController:alertController animated:YES completion:nil];
    }
}
//打电话
void callSomeone(NSString *realPhoneNum, NSString *showPhoneNum){
    if(![NSString isNilOrEmpty:realPhoneNum]){
        UIViewController *currentVC = getCurrentViewController();
        UIAlertController * alertController = [regular getAlertWithFirstActionTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"呼叫 %@",nil),showPhoneNum] FirstActionBlock:^{

            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",realPhoneNum];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [currentVC.view addSubview:callWebview];
        } SecondActionTwoTitle:NSLocalizedString(@"复制",nil) SecondActionBlock:^{

            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = showPhoneNum;
            [YYToast showToastWithTitle:NSLocalizedString(@"复制成功",nil) andDuration:kAlertToastDuration];

        }];
        [currentVC presentViewController:alertController animated:YES completion:nil];
    }
}
//发邮件
void sendEmail(NSString *email){
    if(![NSString isNilOrEmpty:email])
    {
        __block UIViewController *currentVC = getCurrentViewController();
        UIAlertController * alertController = [regular getAlertWithFirstActionTitle:NSLocalizedString(@"在邮箱中打开",nil) FirstActionBlock:^{

            //            [self SendByEmail:email];
            BOOL _b=[MFMailComposeViewController canSendMail];
            if(_b==YES)
            {
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];

                picker.mailComposeDelegate = currentVC;

                [picker setSubject:@"Enter Your Subject!"];

                // Set up recipients
                NSArray *toRecipients = [NSArray arrayWithObject:email];


                [picker setToRecipients:toRecipients];
                if ([picker.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
                    NSArray *list=currentVC.navigationController.navigationBar.subviews;
                    for (id obj in list) {
                        if ([obj isKindOfClass:[UIImageView class]]) {
                            UIImageView *imageView=(UIImageView *)obj;
                            NSArray *list2=imageView.subviews;
                            for (id obj2 in list2) {
                                if ([obj2 isKindOfClass:[UIImageView class]]) {
                                    UIImageView *imageView2=(UIImageView *)obj2;
                                    imageView2.hidden=YES;
                                }
                            }
                        }
                    }
                }

                picker.navigationBar.barTintColor = _define_white_color;
                [currentVC presentViewController:picker animated:NO completion:nil];

            }else
            {
                [YYToast showToastWithTitle:NSLocalizedString(@"请先设置邮箱帐号",nil) andDuration:kAlertToastDuration];
            }

        } SecondActionTwoTitle:NSLocalizedString(@"复制",nil) SecondActionBlock:^{

            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = email;
            [YYToast showToastWithTitle:NSLocalizedString(@"复制成功",nil) andDuration:kAlertToastDuration];

        }];
        [currentVC presentViewController:alertController animated:YES completion:nil];
    }
}
UIViewController *getPresentedViewController(){
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }

    return topVC;
}

//获取Window当前显示的ViewController
UIViewController *getCurrentViewController()
{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
//固定内容 字体下 获取高度
CGFloat getHeightWithWidth(CGFloat width,NSString *content, UIFont *font){
    CGSize titleSize = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize.height+1;
}

//固定内容 字体下 获取宽度
CGFloat getWidthWithHeight(CGFloat height,NSString *content, UIFont *font){
    CGSize titleSize = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return titleSize.width+1;
}

//UIView *setNavView(NSString *title,UIView *supview)
//{
//    UIView *_navView = [UIView getCustomViewWithColor:_define_white_color];
//    [supview addSubview:_navView];
//    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(20);
//        make.height.mas_equalTo(45);
//    }];
//
//    UIView *bottomview = [UIView getCustomViewWithColor:[UIColor colorWithHex:@"d3d3d3"]];
//    [_navView addSubview:bottomview];
//    [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.bottom.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//    }];
//
//    UILabel *titleLabel = [UILabel getLabelWithAlignment:1 WithTitle:title WithFont:18.0f WithTextColor:nil WithSpacing:0];
//    [_navView addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.bottom.mas_equalTo(-1);
//        make.centerX.mas_equalTo(_navView);
//        make.width.mas_equalTo(160);
//    }];
//
//    return _navView;
//}
NSDate *getDate(long time)
{
    return [NSDate dateWithTimeIntervalSince1970:time/1000];
}
NSString *getTimeStr(long time,NSString *formatter){
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];

    NSLog(@"date:%@",[detaildate description]);

    //实例化一个NSDateFormatter对象

    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];

    //设定时间格式,这里可以设置成自己需要的格式

    [dateFormatter setDateFormat:formatter];

    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];

    return currentDateStr;
}

UIView *addNoDataView_phone(UIView *superView,NSString *title,NSString *titleColor,NSString *img){
    YYNoDataView *tempView = nil;
    if(title){
        NSArray *infoArr = [title componentsSeparatedByString:@"|"];
        if([infoArr count] == 1){
            //            tempView = [[YYNoDataView alloc] init];
            //            tempView.titleLabel.text = title;
            tempView = [[YYNoDataView alloc] init];
            //            tempView.titleLabel.text = title;
            //创建NSMutableAttributedString实例，并将text传入
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:title];
            //创建NSMutableParagraphStyle实例
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
            //设置行距
            [style setLineSpacing:18.0f];

            //根据给定长度与style设置attStr式样
            [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, title.length)];
            //Label获取attStr式样
            tempView.titleLabel.attributedText = attStr;

            if(titleColor){
                tempView.titleLabel.textColor = [UIColor colorWithHex:titleColor];
            }else
            {
                tempView.titleLabel.textColor = _define_black_color;
            }
        }else{
            NSString *txtTipInfo = [infoArr objectAtIndex:0];
            NSArray *txtTipArr = [txtTipInfo componentsSeparatedByString:@"/n"];

            NSString *iconInfo = [infoArr objectAtIndex:1];
            NSArray *iconArr = [iconInfo componentsSeparatedByString:@":"];
            NSString *type = [iconArr objectAtIndex:0];
            if([type isEqualToString:@"icon"]){
                //                NSString *imageName =  @"nodata_icon";
                //                if([iconArr count] == 2){
                //                    imageName = [iconArr objectAtIndex:1];
                //                }
                NSString *imageName = nil;
                if(img)
                {
                    imageName = img;
                }else
                {
                    imageName = @"nodata_icon";
                    if([iconArr count] == 2){
                        imageName = [iconArr objectAtIndex:1];
                    }
                }
                NSInteger tipTxtHeight = 0;
                if([txtTipArr count] == 2){
                    NSString *txtTipStr = [txtTipArr objectAtIndex:1];
                    tipTxtHeight = getTxtHeight(SCREEN_WIDTH-60, txtTipStr, @{NSFontAttributeName:[UIFont systemFontOfSize:13]});//[[txtTipStr componentsSeparatedByString:@"\n"] count];
                }
                NSInteger top = 0;
                if([infoArr count] == 3){
                    top = [[infoArr objectAtIndex:2] integerValue];
                }
                tempView = [[YYNoDataView alloc] initWithIcon:imageName tipRow:tipTxtHeight topValue:top];

            }else{
                tempView = [[YYNoDataView alloc] init];
            }

            tempView.titleLabel.text = [txtTipArr objectAtIndex:0];
            if(titleColor){
                tempView.titleLabel.textColor = [UIColor colorWithHex:titleColor];
            }else
            {
                tempView.titleLabel.textColor = _define_black_color;
            }
            if([txtTipArr count] == 2){
                tempView.tipLabel.text = [txtTipArr objectAtIndex:1];
            }else{
                tempView.tipLabel.text = @"";
            }
        }
    }else{
        tempView = [[YYNoDataView alloc] init];
    }


    tempView.backgroundColor = [UIColor clearColor];
    [superView addSubview:tempView];
    __weak UIView *_weakView = superView;
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakView.mas_top);
        make.left.equalTo(_weakView.mas_left);
        make.bottom.equalTo(_weakView.mas_bottom);
        make.right.equalTo(_weakView.mas_right);

    }];
    return tempView;
}
UIView *addNoDataView_pad(UIView *superView,NSString *title,NSString *titleColor,NSString *img){
    YYNoDataView *tempView = nil;
    if(title){
        NSArray *infoArr = [title componentsSeparatedByString:@"|"];
        if([infoArr count] == 1){
            tempView = [[YYNoDataView alloc] init];
            //            tempView.titleLabel.text = title;
            //创建NSMutableAttributedString实例，并将text传入
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:title];
            //创建NSMutableParagraphStyle实例
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
            //设置行距
            [style setLineSpacing:18.0f];

            //根据给定长度与style设置attStr式样
            [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, title.length)];
            //Label获取attStr式样
            tempView.titleLabel.attributedText = attStr;
            tempView.titleLabel.textAlignment = 1;

            if(titleColor){
                tempView.titleLabel.textColor = [UIColor colorWithHex:titleColor];
            }else
            {
                tempView.titleLabel.textColor = _define_black_color;
            }
        }else{
            NSString *iconInfo = [infoArr objectAtIndex:1];
            NSArray *iconArr = [iconInfo componentsSeparatedByString:@":"];
            NSString *type = [iconArr objectAtIndex:0];
            if([type isEqualToString:@"icon"]){
                NSString *imageName = nil;
                if(img)
                {
                    imageName = img;
                }else
                {
                    imageName = @"nodata_icon";
                    if([iconArr count] == 2){
                        imageName = [iconArr objectAtIndex:1];
                    }
                }

                if([infoArr count] ==3){
                    NSInteger offsetx = [[infoArr objectAtIndex:2] integerValue];
                    tempView = [[YYNoDataView alloc] initWithIcon:imageName offsetX:offsetx];
                }else{
                    tempView = [[YYNoDataView alloc] initWithIcon:imageName offsetX:0];
                }
            }else{
                tempView = [[YYNoDataView alloc] init];
            }
            NSString *txtTipInfo = [infoArr objectAtIndex:0];
            NSArray *txtTipArr = [txtTipInfo componentsSeparatedByString:@"/n"];


            //创建NSMutableAttributedString实例，并将text传入
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[txtTipArr objectAtIndex:0]];
            //创建NSMutableParagraphStyle实例
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
            //设置行距
            [style setLineSpacing:5.0f];

            //根据给定长度与style设置attStr式样
            [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, ((NSString *)[txtTipArr objectAtIndex:0]).length)];
            //Label获取attStr式样
            tempView.titleLabel.attributedText = attStr;
            tempView.titleLabel.textAlignment = 1;

            //            tempView.titleLabel.text = [txtTipArr objectAtIndex:0];
            if(titleColor){
                tempView.titleLabel.textColor = [UIColor colorWithHex:titleColor];
            }else
            {
                tempView.titleLabel.textColor = _define_black_color;
            }
            if([txtTipArr count] == 2){
                tempView.tipLabel.text = [txtTipArr objectAtIndex:1];
            }else{
                tempView.tipLabel.text = @"";
            }
        }
    }else{
        tempView = [[YYNoDataView alloc] init];
    }

    tempView.backgroundColor = [UIColor clearColor];
    [superView addSubview:tempView];
    __weak UIView *_weakView = superView;
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakView.mas_top);
        make.left.equalTo(_weakView.mas_left);
        make.bottom.equalTo(_weakView.mas_bottom);
        make.right.equalTo(_weakView.mas_right);
    }];
    return tempView;
}



void popWindowAddBgView(UIView *superView){
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor = [UIColor whiteColor];
    tempView.alpha = 0.6;

    superView.backgroundColor = [UIColor clearColor];
    [superView insertSubview:tempView atIndex:0];
    __weak UIView *_weakView = superView;
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakView.mas_top);
        make.left.equalTo(_weakView.mas_left);
        make.bottom.equalTo(_weakView.mas_bottom);
        make.right.equalTo(_weakView.mas_right);

    }];
}

void addAnimateWhenAddSubview(UIView *view){
    view.alpha = 0.0;
    [UIView animateWithDuration:kAddSubviewAnimateDuration animations:^{
        view.alpha = 1.0;
    }];
}

void removeFromSuperviewUseUseAnimateAndDeallocViewController(UIView *view,UIViewController *viewController){
    __block UIViewController *weakViewContorller = viewController;
    view.alpha = 1.0;
    [UIView animateWithDuration:kAddSubviewAnimateDuration animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        weakViewContorller = nil;
    }];
}

NSString *trimWhitespaceOfStr(NSString *string){
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//防止icloud备份
BOOL addSkipBackupAttributeToItemAtURL(NSURL *URL)
{

    NSError *error = nil;
    BOOL success = [URL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }

    return success;
}


NSString *getShowDateByFormatAndTimeInterval(NSString *format,NSString *timeInterval){
    float millisecond = [timeInterval doubleValue];

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:millisecond/1000];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];

    [dateFormatter setDateFormat:format];

    NSString *string = [dateFormatter stringFromDate:date];
    return string;
}

NSComparisonResult compareNowDate(NSString *timeInterval){
    float millisecond = [timeInterval doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:millisecond/1000];
    //NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:0];
    float nowtime = (((int64_t)[[NSDate date] timeIntervalSince1970]/86400)*86400);
    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:nowtime];
    float curtime = millisecond/1000;
    if(curtime < nowtime){
        return NSOrderedAscending;
    }else{
        return NSOrderedDescending;
    }//NSOrderedAscending = -1L, NSOrderedSame, NSOrderedDescending
    return [date compare:nowDate];
}

YYStylesAndTotalPriceModel *getLocalShoppingCartStyleCount(NSArray *cartbarndInfo){
    YYStylesAndTotalPriceModel *stylesAndTotalPriceModel = [[YYStylesAndTotalPriceModel alloc] init];
    NSInteger styleCount = 0;
    for (NSString *key in cartbarndInfo) {
        NSString *jsonString = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",KUserCartKey,key]];
        NSDictionary *dic = dictionaryWithJsonString(jsonString);
        if(dic){
            //jsonmodel 解析报错改成自己遍历
            styleCount += [YYOrderInfoModel getOrderStyleTotalNumWidthDictionary:dic];
        }
    }
    stylesAndTotalPriceModel.totalStyles = (int)styleCount;
    return stylesAndTotalPriceModel;
}
int calculateTotalsForOneStyle(YYOrderStyleModel *orderStyleModel){
    int totalCount = 0;
    if (orderStyleModel
        && orderStyleModel.colors
        && [orderStyleModel.colors count] > 0) {
        for (int i=0; i < [orderStyleModel.colors count]; i++) {
            YYOrderOneColorModel *orderOneColorModel = [orderStyleModel.colors objectAtIndex:i];
            if (orderOneColorModel
                && orderOneColorModel.sizes
                && [orderOneColorModel.sizes count] > 0) {
                for (int j=0; j<[orderOneColorModel.sizes count]; j++) {
                    YYOrderSizeModel *orderSizeModel = [orderOneColorModel.sizes objectAtIndex:j];
                    if (orderSizeModel
                        && orderSizeModel.amount > 0) {
                        totalCount += [orderSizeModel.amount intValue];
                    }
                }
            }
        }
    }
    return totalCount;
}

NSString *GetDocumentPath()
{
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);

    return [[filePaths objectAtIndex: 0] stringByAppendingPathComponent:@"Private Documents"];
}

NSString *GetApplicationPath(NSString *applicationPathName)
{
    NSString *appPath = GetDocumentPath();

    return [appPath stringByAppendingPathComponent:applicationPathName];
}

NSString *GetCachePath(NSString *applicationPathName, NSString *cachePathName, BOOL willCreate)
{
    NSString *cachePath = GetApplicationPath(applicationPathName);

    cachePath = [cachePath stringByAppendingPathComponent:cachePathName];
    if(cachePath && willCreate)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:cachePath])
        {
            [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }

    return cachePath;
}

NSString *yyjDocumentsDirectory(){
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [filePaths objectAtIndex: 0];
    docPath = [docPath stringByAppendingPathComponent:@"yyj"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:docPath]) {
        [fileManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    //防止icloud备份
    addSkipBackupAttributeToItemAtURL([NSURL fileURLWithPath:docPath]);
    return docPath;
}
//历史账号存放路径
NSString *getUsersStorePath(){
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [filePaths objectAtIndex: 0];
    docPath = [docPath stringByAppendingPathComponent:@"users2.txt"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:docPath]) {
        //[fileManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        //[fileManager removeItemAtPath:docPath error:nil];
    }

    //防止icloud备份
    addSkipBackupAttributeToItemAtURL([NSURL fileURLWithPath:docPath]);
    return docPath;
}

//历史订单存放路径
NSString *getOrderSearchNoteStorePath(){
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [filePaths objectAtIndex: 0];
    docPath = [docPath stringByAppendingPathComponent:@"ordersearchnote.txt"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:docPath]) {
        //[fileManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        //[fileManager removeItemAtPath:docPath error:nil];
    }
    //防止icloud备份
    addSkipBackupAttributeToItemAtURL([NSURL fileURLWithPath:docPath]);
    return docPath;
}

//历史库存存放路径
NSString *getInventorySearchNoteStorePath(){
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [filePaths objectAtIndex: 0];
    docPath = [docPath stringByAppendingPathComponent:@"inventoryrsearchnote.txt"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:docPath]) {
        //[fileManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
        //[fileManager removeItemAtPath:docPath error:nil];
    }
    //防止icloud备份
    addSkipBackupAttributeToItemAtURL([NSURL fileURLWithPath:docPath]);
    return docPath;
}

//创建订单的分享码
NSString *createOrderSharecode(){
    long long recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    int random = (arc4random() % 101) + 888;

    NSString *length_16 = [NSString stringWithFormat:@"%lli%i",recordTime,random];
    long long multiplyValue = 1;
    NSString *no_0_string = [length_16 stringByReplacingOccurrencesOfString:@"0" withString:@""];
    if (no_0_string
        && [no_0_string length] > 0) {
        for (int i=0; i<[no_0_string length] ; i++) {
            NSRange range;
            range.location = i;
            range.length = 1;

            NSString *p = [no_0_string substringWithRange:range];
            if (p) {
                int intValue = [p intValue];
                multiplyValue = multiplyValue * intValue;
            }
        }
    }

    long addValue = 0;

    NSString *multiplyValue_string = [NSString stringWithFormat:@"%lli",multiplyValue];
    if (multiplyValue_string
        && [multiplyValue_string length] > 0) {
        for (int i=0; i<[multiplyValue_string length] ; i++) {
            NSRange range;
            range.location = i;
            range.length = 1;

            NSString *p = [multiplyValue_string substringWithRange:range];
            if (p) {
                int intValue = [p intValue];
                addValue = addValue + intValue;
            }
        }
    }

    NSString *returnValue = [NSString stringWithFormat:@"I%@%li",length_16,addValue];

    return returnValue;
}

//买家地址格式
NSString *getBuyerAddressStr_phone(YYOrderBuyerAddress *buyerAddress){
    //    [NSString isNilOrEmpty:buyerAddress.town]?@"":buyerAddress.town
    NSString *nationStr = [LanguageManager isEnglishLanguage]?buyerAddress.nationEn:buyerAddress.nation;
    NSString *provinceStr = [LanguageManager isEnglishLanguage]?buyerAddress.provinceEn:buyerAddress.province;
    NSString *cityStr = [LanguageManager isEnglishLanguage]?buyerAddress.cityEn:buyerAddress.city;
    if([buyerAddress.defaultShippingAddress integerValue] > 0 || [buyerAddress.defaultShipping integerValue] > 0){

        return [NSString stringWithFormat:NSLocalizedString(@"[默认]%@  %@\n%@ %@%@ %@%@%@",nil),buyerAddress.receiverName,buyerAddress.receiverPhone,nationStr,getProvince(provinceStr),[NSString isNilOrEmpty:cityStr]?@"":cityStr, [NSString isNilOrEmpty:buyerAddress.town]?@"":buyerAddress.town, [NSString isNilOrEmpty:buyerAddress.street]?@"":buyerAddress.street, buyerAddress.detailAddress];
    }else{

        return [NSString stringWithFormat:NSLocalizedString(@"%@  %@\n%@ %@%@ %@%@%@",nil),buyerAddress.receiverName,buyerAddress.receiverPhone,nationStr,getProvince(provinceStr), [NSString isNilOrEmpty:cityStr]?@"":cityStr, [NSString isNilOrEmpty:buyerAddress.town]?@"":buyerAddress.town, [NSString isNilOrEmpty:buyerAddress.street]?@"":buyerAddress.street, buyerAddress.detailAddress];
    }
}
NSString *getBuyerAddressStr_pad(YYOrderBuyerAddress *buyerAddress){
    //    [NSString isNilOrEmpty:buyerAddress.town]?@"":buyerAddress.town
    NSString *nationStr = [LanguageManager isEnglishLanguage]?buyerAddress.nationEn:buyerAddress.nation;
    NSString *provinceStr = [LanguageManager isEnglishLanguage]?buyerAddress.provinceEn:buyerAddress.province;
    NSString *cityStr = [LanguageManager isEnglishLanguage]?buyerAddress.cityEn:buyerAddress.city;
    if([buyerAddress.defaultShippingAddress integerValue] > 0 || [buyerAddress.defaultShipping integerValue] > 0){
        //        "[默认]%@ %@%@ %@%@%@    收件人：%@  电话：%@"
        return [NSString stringWithFormat:NSLocalizedString(@"[默认]%@ %@%@ %@%@%@    收件人：%@  电话：%@",nil),nationStr,getProvince(provinceStr),[NSString isNilOrEmpty:cityStr]?@"":cityStr, [NSString isNilOrEmpty:buyerAddress.town]?@"":buyerAddress.town, [NSString isNilOrEmpty:buyerAddress.street]?@"":buyerAddress.street, buyerAddress.detailAddress,buyerAddress.receiverName,buyerAddress.receiverPhone];
    }else{
        //        "%@ %@%@ %@%@%@    收件人：%@  电话：%@"
        return [NSString stringWithFormat:NSLocalizedString(@"%@ %@%@ %@%@%@    收件人：%@  电话：%@",nil),nationStr,getProvince(provinceStr), [NSString isNilOrEmpty:cityStr]?@"":cityStr, [NSString isNilOrEmpty:buyerAddress.town]?@"":buyerAddress.town, [NSString isNilOrEmpty:buyerAddress.street]?@"":buyerAddress.street, buyerAddress.detailAddress,buyerAddress.receiverName,buyerAddress.receiverPhone];
    }
}


NSString *getMD5String(NSString *str)
{
    if(str && [str length])
    {
        unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
        CC_MD5([[str dataUsingEncoding:NSUTF8StringEncoding] bytes], (CC_LONG)[str length], result);

        int j = 0;
        unsigned char resultHEX[CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH] = {0};
        char charHex[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        {
            resultHEX[j] = charHex[result[i] >> 4 & 0xf];
            resultHEX[j + 1] = charHex[result[i] & 0xf];
            j += 2;
        }

        //return [NSString stringWithCharacters:(const unichar *)resultHEX length:CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH];
        return [NSString stringWithCString:(const char *)resultHEX length:CC_MD5_DIGEST_LENGTH + CC_MD5_DIGEST_LENGTH];
    }

    return nil;
}

char charToBinary(char value)
{
    char temp;

    switch(value)
    {
        case '1':
            temp = 1;
            break;
        case '2':
            temp = 2;
            break;
        case '3':
            temp = 3;
            break;
        case '4':
            temp = 4;
            break;
        case '5':
            temp = 5;
            break;
        case '6':
            temp = 6;
            break;
        case '7':
            temp = 7;
            break;
        case '8':
            temp = 8;
            break;
        case '9':
            temp = 9;
            break;
        case '0':
            temp = 0;
            break;
        case 'A':
        case 'a':
            temp = 0xA;
            break;
        case 'B':
        case 'b':
            temp = 0xB;
            break;
        case 'C':
        case 'c':
            temp = 0xC;
            break;
        case 'D':
        case 'd':
            temp = 0xD;
            break;
        case 'E':
        case 'e':
            temp = 0xE;
            break;
        case 'F':
        case 'f':
            temp = 0xF;
            break;
    }

    return temp;
}

NSData *hexStringToByte(NSString *str)
{
    int nLen = 0;
    if(str && (nLen = [str length]))
    {
        char *srcString = malloc(nLen + 1);
        if(srcString)
        {
            memset(srcString, 0, nLen + 1);
            [str getCString:srcString maxLength:nLen];

            char *desString = malloc(nLen / 2 + 1);
            if(desString)
            {
                memset(desString, 0, nLen / 2 + 1);

                int j = 0;
                for(int i = 0; i < nLen; i +=2)
                {
                    desString[j] = (charToBinary(srcString[i]) << 4) | charToBinary(srcString[i + 1]);
                    j++;
                }

                NSData *resultData = [NSData dataWithBytes:desString length:nLen / 2];

                free(srcString);
                free(desString);

                return resultData;
            }
        }
    }

    return nil;
}

//menuUI
void setMenuUI_phone(id controller,UIView *view,NSArray *menuData){
    NSInteger menuUIWidth = CGRectGetWidth(view.frame);
    NSInteger menuUIHeight = CGRectGetHeight(view.frame);
    NSInteger space = 4;
    view.layer.borderWidth = space;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, menuUIWidth,menuUIHeight);
    NSInteger rowHeight = (menuUIHeight)/[menuData count];
    NSInteger i = 0;
    for (NSArray *uiInfo in menuData) {
        UIButton *btn = creatMenuBtn_phone([uiInfo objectAtIndex:0],[uiInfo objectAtIndex:1],CGRectMake(space, rowHeight*i, menuUIWidth-space*2, rowHeight),(i+1));
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20+space, 0, 0);

        [btn addTarget:controller action:@selector(menuBtnHandler:) forControlEvents:UIControlEventTouchUpInside];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(space, rowHeight*i, menuUIWidth, 1/[UIScreen mainScreen].scale)];
        line.backgroundColor = [UIColor blackColor];
        if([uiInfo count] == 3){
            line.frame = CGRectMake(space, rowHeight*i, menuUIWidth, 4/[UIScreen mainScreen].scale);
        }
        i++;
        [view addSubview:btn];
        [view addSubview:line];
    }
}
void setMenuUI_pad(id controller,UIView *view,NSArray *menuData){
    NSInteger menuUIWidth = CGRectGetWidth(view.frame);
    NSInteger menuUIHeight = CGRectGetHeight(view.frame);
    NSInteger space = 4;
    view.layer.borderWidth = space;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, menuUIWidth,menuUIHeight);
    NSInteger rowHeight = (menuUIHeight)/[menuData count];
    NSInteger i = 0;
    for (NSArray *uiInfo in menuData) {
        UIButton *btn = nil;
        if ([uiInfo count] == 2) {
            btn = creatMenuBtn_pad([uiInfo objectAtIndex:0],[uiInfo objectAtIndex:1],CGRectMake(space, rowHeight*i, menuUIWidth-space*2, rowHeight),(i+1));
        }else if ([uiInfo count] >= 3){
            btn = creatMenuBtn_pad([uiInfo objectAtIndex:0],[uiInfo objectAtIndex:1],CGRectMake(space, rowHeight*i, menuUIWidth-space*2, rowHeight),[[uiInfo objectAtIndex:2] integerValue]);
        }

        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 20+space, 0, 0);

        [btn addTarget:controller action:@selector(menuBtnHandler:) forControlEvents:UIControlEventTouchUpInside];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(space, rowHeight*i, menuUIWidth, 1/[UIScreen mainScreen].scale)];
        line.backgroundColor = [UIColor blackColor];
        if([uiInfo count] == 4){
            line.frame = CGRectMake(space, rowHeight*i, menuUIWidth, 4/[UIScreen mainScreen].scale);
        }
        i++;
        [view addSubview:btn];
        [view addSubview:line];
    }
}
UIButton *creatMenuBtn_phone(NSString *icon, NSString *titel,CGRect frame ,NSInteger tag){
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:titel forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",icon]] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] size:frame.size] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] size:frame.size] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return btn;
}
UIButton *creatMenuBtn_pad(NSString *icon, NSString *titel,CGRect frame ,NSInteger tag){
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setTitle:titel forState:UIControlStateNormal];
    NSArray *icons = [icon componentsSeparatedByString:@"|"];
    [btn setImage:[UIImage imageNamed:[icons objectAtIndex:0]] forState:UIControlStateNormal];
    if([icons count] > 1){
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[icons objectAtIndex:1]]] forState:UIControlStateHighlighted];
    }
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] size:frame.size] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] size:frame.size] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -6, 0, 0)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return btn;
}

//图片存储
void writeImageWithRelativePath(NSString *imageRelativePath, NSString *storePath, UIImage *image,NSString *size){
    storePath = [storePath stringByAppendingString:@"/"];
    storePath = [storePath stringByAppendingString:[imageRelativePath lastPathComponent]];
    storePath = [storePath stringByAppendingString:size];
    [UIImagePNGRepresentation(image) writeToFile:storePath atomically:YES];
}

//获取网址+http
NSString *getWebUrl(NSString *website)
{
    if(![NSString isNilOrEmpty:website])
    {
        if([website hasPrefix:@"http"])
        {
            return website;
        }
        return [[NSString alloc] initWithFormat:@"http://%@",website];
    }
    return @"";
}
//获取html、content 内容、font 字体大小、字体颜色
NSString *getHTMLStringWithContent_phone(NSString *content,NSString *font,NSString *color)
{
    if(!content)content=@"";
    if(!font)font=@"15px/20px";
    if(!color)color=@"#000000";
    NSString *temp = nil;
    NSMutableString *mut=[[NSMutableString alloc] init];
    for(int i =0; i < [content length]; i++)
    {
        temp = [content substringWithRange:NSMakeRange(i, 1)];
        if([temp isEqualToString:@"\n"])
        {
            [mut appendString:@"<br>"];

        }else
        {
            [mut appendString:temp];
        }
    }

    return [NSString stringWithFormat:@"<!DOCTYPE HTML><html><head><meta charset=utf-8><meta name=viewport content=width=device-width, initial-scale=1><style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Helvetica;align:justify;color:%@}</style><div align='justify'>%@<div>",font,color,mut];
}

NSString *getHTMLStringWithContent_pad(NSString *content,NSString *font,NSString *color)
{
    if(!content)content=@"";
    if(!font)font=@"15px/20px";
    if(!color)color=@"#000000";
    NSString *temp = nil;
    NSMutableString *mut=[[NSMutableString alloc] init];
    for(int i =0; i < [content length]; i++)
    {
        temp = [content substringWithRange:NSMakeRange(i, 1)];
        if([temp isEqualToString:@"\n"])
        {
            [mut appendString:@"<br>"];

        }else
        {
            [mut appendString:temp];
        }
    }
    return [NSString stringWithFormat:@"<!DOCTYPE HTML><html><head><meta charset=utf-8><meta name=viewport content=width=device-width, initial-scale=1><style>body{word-wrap:break-word;margin:0;background-color:transparent;font:%@ Custom-Font-Name;align:justify;color:%@}</style><div align='justify'>%@<div>",font,color,mut];
}


//订单关联状态名称
NSString *getOrderConnStatusName_brand(NSInteger status, BOOL needFlag){
    if(status == kOrderStatus){
        return (needFlag?[NSString stringWithFormat:@"【%@】",NSLocalizedString(@"未入驻",nil)]:NSLocalizedString(@"未入驻",nil));
    }else if(status == kOrderStatus1){
        return (needFlag?[NSString stringWithFormat:@"【%@】",NSLocalizedString(@"关联成功",nil)]:NSLocalizedString(@"关联成功",nil));
    }else if(status == kOrderStatus2){
        return (needFlag?[NSString stringWithFormat:@"【%@】",NSLocalizedString(@"关联失败",nil)]:NSLocalizedString(@"关联失败",nil));
    }else if(status == kOrderStatus3){
        return (needFlag?[NSString stringWithFormat:@"【%@】",NSLocalizedString(@"未入驻",nil)]:NSLocalizedString(@"未入驻",nil));
    }else if(status == kOrderStatus0){
        return (needFlag?[NSString stringWithFormat:@"【%@】",NSLocalizedString(@"关联中",nil)]:NSLocalizedString(@"关联中",nil));
    }
    return @"";
}
NSString *getOrderConnStatusName_buyer(NSInteger status){
    if(status == kOrderStatus){
        return [NSString stringWithFormat:@"【%@】",NSLocalizedString(@"未入驻",nil)];
    }else if(status == kOrderStatus1){
        return [NSString stringWithFormat:@"【%@】",NSLocalizedString(@"关联成功",nil)];
    }else if(status == kOrderStatus2){
        return [NSString stringWithFormat:@"【%@】",NSLocalizedString(@"关联失败",nil)];
    }else if(status == kOrderStatus3){
        return [NSString stringWithFormat:@"【%@】",NSLocalizedString(@"未入驻",nil)];
    }else if(status == kOrderStatus0){
        return [NSString stringWithFormat:@"【%@】",NSLocalizedString(@"关联中",nil)];
    }
    return @"";
}
NSString *getOrderConnStatusName_pad(NSInteger status){
    if(status == kOrderStatus){
        return NSLocalizedString(@"【未入驻】",nil);
    }else if(status == kOrderStatus1){
        return NSLocalizedString(@"【关联成功】",nil);
    }else if(status == kOrderStatus2){
        return NSLocalizedString(@"【关联失败】",nil);
    }else if(status == kOrderStatus3){
        return NSLocalizedString(@"【未入驻】",nil);
    }else if(status == kOrderStatus0){
        return NSLocalizedString(@"【关联中】",nil);
    }
    return @"";
}
NSInteger getOrderTransStatus(NSNumber *designerTransStatus,NSNumber *buyerTransStatus){

    //已确认？
    BOOL isConfirmed = NO;
    if([designerTransStatus integerValue] == kOrderCode_NEGOTIATION_DONE || [designerTransStatus integerValue] == kOrderCode_CONTRACT_DONE){
        if([buyerTransStatus integerValue] == kOrderCode_NEGOTIATION_DONE || [buyerTransStatus integerValue] == kOrderCode_CONTRACT_DONE){
            isConfirmed = YES;
        }
    }

    //已下单？
    BOOL isNegotiation = NO;
    if(!isConfirmed){
        if([designerTransStatus integerValue] == kOrderCode_NEGOTIATION || [buyerTransStatus integerValue] == kOrderCode_NEGOTIATION){
            isNegotiation = YES;
        }
    }

    NSInteger transStatus = 0;
    if(isConfirmed){
        transStatus = kOrderCode_NEGOTIATION_DONE;
    }else{
        if(isNegotiation){
            transStatus = kOrderCode_NEGOTIATION;
        }else{
            if(KUserIsBrand){
                transStatus = [designerTransStatus integerValue];
            }else{
                transStatus = [buyerTransStatus integerValue];
            }
        }
    }
    return transStatus;
}
//订单状态名称
NSString *getOrderStatusName_detail(NSInteger transStatus,BOOL needNum){

    if(transStatus == kOrderCode_NEGOTIATION){
        //已下单
        return  (needNum?[NSString stringWithFormat:@"① %@",NSLocalizedString(@"已下单",nil)]:NSLocalizedString(@"已下单",nil));
    }else if(transStatus == kOrderCode_NEGOTIATION_DONE || transStatus == kOrderCode_CONTRACT_DONE){
        //已确认
        return  (needNum?[NSString stringWithFormat:@"② %@",NSLocalizedString(@"已确认",nil)]:NSLocalizedString(@"已确认",nil));
    }else if(transStatus == kOrderCode_MANUFACTURE){
        //已生产
        return (needNum?[NSString stringWithFormat:@"③ %@",NSLocalizedString(@"已生产",nil)]:NSLocalizedString(@"已生产",nil));
    }else if(transStatus == kOrderCode_DELIVERY){
        //已发货
        return (needNum?[NSString stringWithFormat:@"④ %@",NSLocalizedString(@"已发货",nil)]:NSLocalizedString(@"已发货",nil));
    }else if(transStatus == kOrderCode_RECEIVED){
        //已收货
        return (needNum?[NSString stringWithFormat:@"⑤ %@",NSLocalizedString(@"已收货",nil)]:NSLocalizedString(@"已收货",nil));
    }else if(transStatus == kOrderCode_CANCELLED || transStatus == kOrderCode_CLOSED){
        //已取消
        return NSLocalizedString(@"已取消",nil);
    }else if(transStatus == kOrderCode_CLOSE_REQ){
        //关闭请求
        return NSLocalizedString(@"交易取消处理中",nil);
    }
    return  @"";
}
//订单状态名称
NSString *getOrderStatusName_short(NSInteger status){
    if(status == kOrderCode_NEGOTIATION){
        //已下单
        return NSLocalizedString(@"已下单",nil);
    }else if(status == kOrderCode_NEGOTIATION_DONE || status == kOrderCode_CONTRACT_DONE){
        //已确认
        return NSLocalizedString(@"已确认",nil);
    }else if(status == kOrderCode_MANUFACTURE){
        //已生产
        return NSLocalizedString(@"已生产",nil);
    }else if(status == kOrderCode_DELIVERY){
        //已发货
        return NSLocalizedString(@"已发货",nil);
    }else if(status == kOrderCode_RECEIVED){
        //已收货
        return NSLocalizedString(@"已收货",nil);
    }else if(status == kOrderCode_CANCELLED || status == kOrderCode_CLOSED){
        //已取消
        return NSLocalizedString(@"已取消",nil);
    }else if(status == kOrderCode_CLOSE_REQ){
        //关闭请求
        return NSLocalizedString(@"交易取消处理中",nil);
    }
    return  @"";
}
//订单状态按钮名称
NSString *getOrderStatusBtnName_brand(NSInteger status){
    if(status == kOrderCode_NEGOTIATION){
        //已下单
        return NSLocalizedString(@"已下单",nil);
    }else if(status == kOrderCode_NEGOTIATION_DONE || status == kOrderCode_CONTRACT_DONE){
        //已确认
        return NSLocalizedString(@"已确认",nil);
    }else if(status == kOrderCode_MANUFACTURE){
        //已生产
        return NSLocalizedString(@"已生产",nil);
    }else if(status == kOrderCode_DELIVERY){
        //已发货
        return NSLocalizedString(@"已发货",nil);
    }else if(status == kOrderCode_RECEIVED){
        //已收货
        return NSLocalizedString(@"等待对方收货",nil);
    }else if(status == kOrderCode_CANCELLED || status == kOrderCode_CLOSED){
        //已取消
        return NSLocalizedString(@"重新建立订单",nil);
    }else if(status == kOrderCode_CLOSE_REQ){
        //关闭请求
        return NSLocalizedString(@"处理请求",nil);
    }
    return  @"";
}
//订单状态按钮名称
NSString *getOrderStatusBtnName_buyer(NSInteger status){
    if(status == kOrderCode_NEGOTIATION){
        //已下单
        return NSLocalizedString(@"已下单",nil);
    }else if(status == kOrderCode_NEGOTIATION_DONE || status == kOrderCode_CONTRACT_DONE){
        //已确认
        return NSLocalizedString(@"已确认",nil);
    }else if(status == kOrderCode_MANUFACTURE){
        //已生产
        return NSLocalizedString(@"安排生产",nil);
    }else if(status == kOrderCode_DELIVERY){
        //已发货
        return NSLocalizedString(@"发货",nil);
    }else if(status == kOrderCode_RECEIVED){
        //已收货
        return NSLocalizedString(@"确认收货",nil);
    }else if(status == kOrderCode_CANCELLED || status == kOrderCode_CLOSED){
        //已取消
        return NSLocalizedString(@"重新建立订单",nil);
    }else if(status == kOrderCode_CLOSE_REQ){
        //关闭请求
        return NSLocalizedString(@"处理请求",nil);
    }
    return  @"";
}
NSString *getOrderStatusBtnName_pad(NSInteger status){
    if(status == kOrderCode_NEGOTIATION){
        //已下单
        return NSLocalizedString(@"已下单",nil);
    }else if(status == kOrderCode_NEGOTIATION_DONE || status == kOrderCode_CONTRACT_DONE){
        //已确认
        return NSLocalizedString(@"已确认",nil);
    }else if(status == kOrderCode_MANUFACTURE){
        //已生产
        return NSLocalizedString(@"安排生产",nil);
    }else if(status == kOrderCode_DELIVERY){
        //已发货
        return NSLocalizedString(@"发货",nil);
    }else if(status == kOrderCode_RECEIVED){
        //已收货
        return NSLocalizedString(@"确认收货",nil);
    }else if(status == kOrderCode_CANCELLED || status == kOrderCode_CLOSED){
        //已取消
        return NSLocalizedString(@"重新建立订单",nil);
    }else if(status == kOrderCode_CLOSE_REQ){
        //关闭请求
        return NSLocalizedString(@"处理请求",nil);
    }
    return  @"";
}
NSString *getOrderStatusAlertTip(NSInteger status){
    if(status == kOrderCode_NEGOTIATION){
        //已下单
        return  @"";
    }else if(status == kOrderCode_NEGOTIATION_DONE || status == kOrderCode_CONTRACT_DONE){
        //已确认
        return @"";
    }else if(status == kOrderCode_MANUFACTURE){
        //已生产
        return NSLocalizedString(@"确认订单已经安排生产了吗？",nil);
    }else if(status == kOrderCode_DELIVERY){
        //已发货
        return NSLocalizedString(@"确认订单已经发货了吗？",nil);
    }else if(status == kOrderCode_RECEIVED){
        //已收货
        return NSLocalizedString(@"等待对方收货",nil);
    }else if(status == kOrderCode_CANCELLED || status == kOrderCode_CLOSED){
        //已取消
        return NSLocalizedString(@"重新建立订单",nil);
    }else if(status == kOrderCode_CLOSE_REQ){
        //关闭请求
        return NSLocalizedString(@"处理请求",nil);
    }
    return  @"";
}

//订单状态按钮提示
NSString *getOrderStatusDesignerTip_phone(NSInteger status){
    if(status == kOrderCode_NEGOTIATION){
        //已下单
        return  NSLocalizedString(@"需要双方同时确认；订单确认后不能被修改",nil);
    }else if(status == kOrderCode_NEGOTIATION_DONE || status == kOrderCode_CONTRACT_DONE){
        //已确认
        return  NSLocalizedString(@"等待设计师生产",nil);
    }else if(status == kOrderCode_MANUFACTURE){
        //已生产
        return NSLocalizedString(@"等待设计师发货",nil);
    }else if(status == kOrderCode_DELIVERY){
        //已发货
        return NSLocalizedString(@"剩余%@将自动确认收货",nil);
    }else if(status == kOrderCode_RECEIVED){
        //已收货
        return NSLocalizedString(@"订单已完成",nil);
    }else if(status == kOrderCode_CANCELLED || status == kOrderCode_CLOSED){
        //已取消
        return NSLocalizedString(@"订单被取消，不能修改订单",nil);
    }else if(status == kOrderCode_CLOSE_REQ){
        //关闭请求
        return @"";
    }
    return  @"";
}
NSString *getOrderStatusDesignerTip_pad(NSInteger status){
    if(status == kOrderCode_NEGOTIATION){
        //已下单
        return  NSLocalizedString(@"需要双方同时确认；订单确认后不能被修改",nil);
    }else if(status == kOrderCode_NEGOTIATION_DONE || status == kOrderCode_CONTRACT_DONE){
        //已确认
        return  NSLocalizedString(@"确认后的订单可以安排生产，若生产完毕请点击已生产",nil);
    }else if(status == kOrderCode_MANUFACTURE){
        //已生产
        return NSLocalizedString(@"若该订单已发货完毕，请点击已发货",nil);
    }else if(status == kOrderCode_DELIVERY){
        //已发货
        return NSLocalizedString(@"剩余%@将自动确认收货",nil);
    }else if(status == kOrderCode_RECEIVED){
        //已收货
        return NSLocalizedString(@"等待对方确认收货",nil);
    }else if(status == kOrderCode_CANCELLED || status == kOrderCode_CLOSED){
        //已取消
        return @"";
    }else if(status == kOrderCode_CLOSE_REQ){
        //关闭请求
        return NSLocalizedString(@"交易取消处理中",nil);
    }
    return  @"";
}
//订单状态按钮提示
NSString *getOrderStatusBuyerTip(NSInteger status){
    if(status == kOrderCode_NEGOTIATION){
        //已下单
        return  NSLocalizedString(@"需要双方同时确认；订单确认后不能被修改",nil);
    }else if(status == kOrderCode_NEGOTIATION_DONE || status == kOrderCode_CONTRACT_DONE){
        //已确认
        return  NSLocalizedString(@"等待设计师生产",nil);
    }else if(status == kOrderCode_MANUFACTURE){
        //已生产
        return NSLocalizedString(@"等待设计师发货",nil);
    }else if(status == kOrderCode_DELIVERY){
        //已发货
        return NSLocalizedString(@"剩余%@将自动确认收货",nil);
    }else if(status == kOrderCode_RECEIVED){
        //已收货
        return NSLocalizedString(@"订单已完成",nil);
    }else if(status == kOrderCode_CANCELLED || status == kOrderCode_CLOSED){
        //已取消
        return NSLocalizedString(@"订单被取消，不能修改订单",nil);
    }else if(status == kOrderCode_CLOSE_REQ){
        //关闭请求
        return @"";
    }
    return  @"";
}


//订单状态按钮名称
NSInteger getOrderNextStatus(NSInteger status){
    NSInteger nextStatus = kOrderCode_NEGOTIATION;
    if(status == kOrderCode_NEGOTIATION){
        //已下单
        nextStatus = kOrderCode_NEGOTIATION_DONE;//已确认
    }else if(status == kOrderCode_NEGOTIATION_DONE || status == kOrderCode_CONTRACT_DONE){
        //已确认
        nextStatus = kOrderCode_MANUFACTURE;//已生产
    }else if(status == kOrderCode_MANUFACTURE){
        //已生产
        nextStatus = kOrderCode_DELIVERY;//已发货
    }else if(status == kOrderCode_DELIVERY){
        //已发货
        nextStatus = kOrderCode_RECEIVED;//已收货
    }else if(status == kOrderCode_RECEIVED){
        //已收货
        nextStatus = kOrderCode_RECEIVED;//已收货
    }else if(status == kOrderCode_CANCELLED || status == kOrderCode_CLOSED){
        //已取消
        nextStatus = kOrderCode_CANCELLED;//已取消
    }else if(status == kOrderCode_CLOSE_REQ){
        //关闭请求
        nextStatus = kOrderCode_CLOSE_REQ;//关闭请求
    }
    return nextStatus;
}
NSLayoutConstraint *getUIViewLayoutConstraint(UIView *ui ,NSLayoutAttribute layoutAttribute){
    for (NSLayoutConstraint * constrait in [ui constraints]) {
        if(constrait.firstAttribute == NSLayoutAttributeHeight){
            return constrait;
        }
    }
    return nil;
}


NSInteger getTxtHeight(float txtWidth,NSString *text,NSDictionary *txtDict){
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(txtWidth, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:txtDict context:nil];
    //    CGSize textSize =[text sizeWithAttributes:txtDict];
    //    NSInteger rowNum = ceilf(textSize.width/txtWidth);
    //    float textTotalHeight = rowNum * ceilf(textSize.height);
    return ceilf(textRect.size.height);
}

NSString * objArrayToJSON(NSArray *array){
    NSString *jsonStr = @"[";
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\"",array[i]]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];

    return jsonStr;
}
NSString * DataTOjsonString(id object)
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
id toArrayOrNSDictionary(NSString *jsonString){
    NSData *jsonData= [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    } else {
        // 解析错误
        return nil;
    }
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
NSDictionary *dictionaryWithJsonString(NSString *jsonString) {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//压缩图片
UIImage *compressImage(UIImage *image, NSInteger maxFileSize){
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }

    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

//是否某个颜色款式有数量
BOOL checkOrderOneColorHasAmount(YYOrderOneColorModel *orderOneColorModel){
    for (YYOrderSizeModel *sizeModel  in orderOneColorModel.sizes) {
        if([sizeModel.amount integerValue] > 0 || [sizeModel.amount integerValue] == -1){
            return YES;
        }
    }
    return NO;
}
//替换某个货币字符
NSString *replaceMoneyFlag(NSString *txt,NSInteger moneyType){
    NSArray *moneySymbolArr = @[@"￥",@"€",@"£",@"$"];
    if(moneyType == -1){
        txt=[txt stringByReplacingOccurrencesOfString:@"￥"withString:@""];
    }else{
        txt=[txt stringByReplacingOccurrencesOfString:@"￥"withString:[moneySymbolArr objectAtIndex:moneyType]];
    }
    return txt;
}
//获取某个品牌moneyType
NSInteger getMoneyType(NSInteger designerId){
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%ld",KUserCartMoneyTypeKey,designerId]];
    if(string && string.length  > 0){
        return [string integerValue];
    }
    return -1;
}
//md5
NSString * md5(NSString *inPutText)
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);

    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
//精确的货币计算
NSString *decimalNumberMutiplyWithString(NSString *multiplierValue,NSString *multiplicandValue)
{
    //    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:multiplierValue];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:multiplicandValue ];

    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber ];
    return [NSString stringWithFormat:@"%0.2f",[product doubleValue]];
}
StyleDateRange *transferToStyleDateRange(YYDateRangeModel* dateRangeModel){
    NSString *predicate = [NSString stringWithFormat:@"series_id=%i and daterang_id=%i",[dateRangeModel.seriesId intValue],[dateRangeModel.id intValue]];
    NSLog(@"predicate: %@",predicate);
    StyleDateRange *dateRange = [StyleDateRange one:predicate];
    if(!dateRange){
        dateRange = [StyleDateRange createNew];
        dateRange.series_id = dateRangeModel.seriesId;
        dateRange.daterang_id = dateRangeModel.id;
    }
    //dateRange.daterang_id = dateRangeModel.id;
    dateRange.name = dateRangeModel.name;
    dateRange.start = dateRangeModel.start;
    dateRange.end = dateRangeModel.end;
    //dateRange.series_id = dateRangeModel.seriesId;
    dateRange.status = dateRangeModel.status;
    return dateRange;
}
YYDateRangeModel*transferToYYDateRangeModel(StyleDateRange *dateRange){
    YYDateRangeModel *dateRangMode = [[YYDateRangeModel alloc] init];
    dateRangMode.id = dateRange.daterang_id;
    dateRangMode.seriesId = dateRange.series_id;
    dateRangMode.end = dateRange.end;
    dateRangMode.status = dateRange.status;
    dateRangMode.start = dateRange.start;
    dateRangMode.name = dateRange.name;
    return dateRangMode;
}

//获取中文字体
UIFont *getFont(CGFloat font)
{
    return (kIOSVersions_v9? [UIFont fontWithName:@"PingFangSC-Regular" size:font]:[UIFont fontWithName:@"HelveticaNeue" size:font]);
}

//获取中文粗体
UIFont *getSemiboldFont(CGFloat font)
{

    return (kIOSVersions_v9? [UIFont fontWithName:@"PingFangSC-Semibold" size:font]:[UIFont fontWithName:@"HelveticaNeue-Bold" size:font]);
}

//获取英文字体
UIFont *get_en_Font(CGFloat font)
{
    return [UIFont fontWithName:@"HelveticaNeue" size:font];
}

void setBorder(UIView *view)
{
    view.layer.masksToBounds=YES;
    view.layer.borderColor=[[UIColor blackColor] CGColor];
    view.layer.borderWidth=1;
}
void setCornerRadiusBorder(UIView *view)
{
    view.layer.masksToBounds=YES;
    view.layer.borderColor=[[UIColor colorWithHex:kDefaultBorderColor] CGColor];
    view.layer.borderWidth=1;
    view.layer.cornerRadius=2.0f;
}
void setBorderCustom(UIView *view,CGFloat borderWidth,UIColor *borderColor)
{
    view.layer.masksToBounds = YES;

    if(borderWidth){
        view.layer.borderWidth = borderWidth;
    }else{
        view.layer.borderWidth = 1;
    }

    if(borderColor){
        view.layer.borderColor=[borderColor CGColor];
    }else{
        view.layer.borderColor=[[UIColor blackColor] CGColor];
    }
}
UIAlertController *alertTitleCancel_Simple(NSString *title,void (^block)())
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];

    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    return alertController;
}
/****************解析数据****************/
/**
 * +82 15868191992 ----> 82
 * +82 中国 ----> 82
 *  ++ 15868191992 ----> ++ (好去判断这个状态)
 *  ++ 美国 ----> ++ (好去判断这个状态)
 *     15868191992 ----> 空
 */
NSString *getCountryCode(NSString *completePhoneDes){
    NSString *_countryCode = @"";
    if(![completePhoneDes containsString:@"++"]){
        NSArray *tempArr = [completePhoneDes componentsSeparatedByString:@"+"];
        if(tempArr.count > 1){
            NSArray *temp2 = [tempArr[1] componentsSeparatedByString:@" "];
            if(temp2.count){
                NSString *countryCode = temp2[0];//取出来的区号
                _countryCode = countryCode;
            }
        }
    }else{
        //            包含“++” 表示未找到本地区号匹配项 该异常情况传给后台参数格式为"++ 15868191992"
        _countryCode = @"++";
    }
    return _countryCode;
}

/**
 * +82 15868191992 ----> +82 韩国
 *  ++ 15868191992 ----> +86 中国
 *     15868191992 ----> +86 中国
 */
NSString *getCountryCodeDetailDes(NSString *completePhoneDes){
    NSString *titleStr = @"";
    NSString *_countryCode = getCountryCode(completePhoneDes);
    if([_countryCode isEqualToString:@"++"]){
        //++ 默认为中国
        titleStr = NSLocalizedString(@"+86 中国",nil);
    }else if([NSString isNilOrEmpty:_countryCode]){
        //为空
        titleStr = NSLocalizedString(@"+86 中国",nil);
    }else{
        //正常返回国家code 拿着code去找名字
        titleStr = getContactLocalType([_countryCode integerValue]);
    }
    return titleStr;
}

/**
 * +82 ----> +82 韩国
 *  ++ ----> +86 中国
 *  空 ----> +86 中国
 */
NSString *getCountryCodeDetailDesByCode(NSString *_countryCode){
    NSString *titleStr = @"";
    if([_countryCode isEqualToString:@"++"]){
        //++ 默认为中国
        titleStr = NSLocalizedString(@"+86 中国",nil);
    }else if([NSString isNilOrEmpty:_countryCode]){
        //为空
        titleStr = NSLocalizedString(@"+86 中国",nil);
    }else{
        //正常返回国家code 拿着code去找名字
        titleStr = getContactLocalType([_countryCode integerValue]);
    }
    return titleStr;
}
/**
 * +82 15868191992 ----> 15868191992
 *  ++ 15868191992 ----> 15868191992
 *     15868191992 ----> 15868191992
 *             +86 ----> 空
 *              空 ----> 空
 */
NSString *getPhoneNum(NSString *completePhoneDes){
    NSString *phoneNum = @"";
    if(![NSString isNilOrEmpty:completePhoneDes]){
        //        不为空
        NSArray *phoneArr = [completePhoneDes componentsSeparatedByString:@" "];
        if(phoneArr.count){
            if(phoneArr.count > 1){
                phoneNum = phoneArr[1];
            }else{
                if(![completePhoneDes containsString:@"+"]){
                    phoneNum = completePhoneDes;
                }
            }
        }
    }
    return phoneNum;
}

/**
 * 浙江 ----> 浙江
 *   - ----> 空
 *  空 ----> 空
 */
NSString *getProvince(NSString *provinceStr){
    if([NSString isNilOrEmpty:provinceStr]){
        return @"";
    }else{
        if([provinceStr isEqualToString:@"-"]){
            return @"";
        }else{
            return provinceStr;
        }
    }
}
/**
 * +82 15868191992 | 91 ---->+91 15868191992
 *  ++ 15868191992 | 91 ---->+91 15868191992
 *     15868191992 | 91 ---->+91 15868191992
 *             +86 | 91 ---->+91
 *              空 | 91 ---->+91
 */
NSString *changeCountryCodeDetailDesByNewCode(NSString *completePhoneDes,NSInteger NewCountryCode){
    if(![NSString isNilOrEmpty:completePhoneDes]){
        NSArray *tempArr = [completePhoneDes componentsSeparatedByString:@" "];
        if(tempArr.count){
            if(tempArr.count > 1){
                return [[NSString alloc] initWithFormat:@"+%ld %@",NewCountryCode,tempArr[1]];
            }else{
                NSArray *tempArr1 = [tempArr[0] componentsSeparatedByString:@"+"];
                if(tempArr1.count){
                    if(tempArr1.count > 1){
                        return [[NSString alloc] initWithFormat:@"+%ld",NewCountryCode];
                    }else{
                        return [[NSString alloc] initWithFormat:@"+%ld %@",NewCountryCode,tempArr[0]];
                    }
                }
            }
        }
    }
    return [[NSString alloc] initWithFormat:@"+%ld",NewCountryCode];
}
/**
 * +82 15868191992 | 15555555555 ---->+82 15555555555
 *  ++ 15868191992 | 15555555555 ---->++ 15555555555
 *     15868191992 | 15555555555 ---->15555555555
 *             +82 | 15555555555 ---->+82 15555555555
 *              空 | 15555555555 ---->15555555555
 */
NSString *changeCountryCodeDetailDesByNewPhoneNum(NSString *completePhoneDes,NSString *NewPhoneNum){
    if(![NSString isNilOrEmpty:completePhoneDes]){
        NSArray *tempArr = [completePhoneDes componentsSeparatedByString:@" "];
        if(tempArr.count){
            if(tempArr.count > 1){
                return [[NSString alloc] initWithFormat:@"%@ %@",tempArr[0],NewPhoneNum];
            }else{
                NSArray *tempArr1 = [tempArr[0] componentsSeparatedByString:@"+"];
                if(tempArr1.count){
                    if(tempArr1.count > 1){
                        return [[NSString alloc] initWithFormat:@"%@ %@",tempArr[0],NewPhoneNum];
                    }
                }
            }
        }
    }
    return NewPhoneNum;
}
/****************查询本地数据****************/
//根据格式获取区号数组
NSArray *getContactLocalData(){

    NSString *plistName = [LanguageManager isEnglishLanguage]?@"englishCountryJson":@"chineseCountryJson";

    NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"json"];

    NSData *theData = [NSData dataWithContentsOfFile:path];

    NSArray *localData = [[NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];

    NSMutableArray *tempArr = [[NSMutableArray alloc] init];

    [localData enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *phoneCode = [obj objectForKey:@"phoneCode"];
        NSString *countryName = [obj objectForKey:@"countryName"];
        if(![NSString isNilOrEmpty:countryName]&&![NSString isNilOrEmpty:phoneCode])
        {
            [tempArr addObject:[[NSString alloc] initWithFormat:@"+%@ %@",phoneCode,countryName]];
        }
    }];
    return tempArr;
}

//根据区号code 获取区号信息
NSString *getContactLocalType(NSInteger type){
    if(type)
    {
        NSString *plistName = [LanguageManager isEnglishLanguage]?@"englishCountryJson":@"chineseCountryJson";

        NSString* path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"json"];

        NSData *theData = [NSData dataWithContentsOfFile:path];

        NSArray *arr = [[NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers error:nil] objectForKey:@"data"];
        __block NSString *localStr = nil;
        [arr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([[obj objectForKey:@"phoneCode"] integerValue] == type)
            {
                localStr = [[NSString alloc] initWithFormat:@"+%@ %@",[obj objectForKey:@"phoneCode"],[obj objectForKey:@"countryName"]];
                *stop = YES;
            }
        }];
        if(localStr)
        {
            return localStr;
        }
        return NSLocalizedString(@"+86 中国",nil);
    }else
    {
        return NSLocalizedString(@"+86 中国",nil);
    }
}

//联系权限数据
NSArray *getContactLimitData(){
    return @[NSLocalizedString(@"公开",nil),NSLocalizedString(@"仅合作买手店可见",nil)];
}
NSString *getContactLimitType(NSInteger type){
    if(type == 0)
    {
        return NSLocalizedString(@"仅合作买手店可见",nil);
    }else if(type == 2)
    {
        return NSLocalizedString(@"公开",nil);
    }
    return @"";
}

/****************税率相关****************/
//判断是否显示加税
BOOL needPayTaxView(NSInteger moneyType){
    if(moneyType == 0){
        return YES;
    }
    return NO;
}

//加税显示数据 已废弃
NSArray *getPayTaxData(BOOL isTxt){
    if(isTxt){
        return @[NSLocalizedString(@"不加税",nil),NSLocalizedString(@"17%税",nil)];//,@"6%税"
    }
    return @[@(0),@(0.17)];//,@(0.06)
}

NSString *getPayTaxType(NSInteger type,BOOL isTxt){
    NSArray *arr = getPayTaxData(isTxt);
    if(isTxt){
        return [arr objectAtIndex:type];
    }
    return [[arr objectAtIndex:type] stringValue];
}
//临时
//NSInteger getPayTaxTypeToService(NSInteger type){
//    NSArray *arr = getPayTaxData(NO);
//    double taxRate= [[arr objectAtIndex:type] doubleValue];
//    return  taxRate*100;
//}
//
//NSInteger getPayTaxTypeFormService(NSInteger value){
//    NSArray *arr = getPayTaxData(NO);
//    NSInteger count = [arr count];
//    for (NSInteger i=0; i<count; i++) {
//        NSInteger taxvalue = [[arr objectAtIndex:i] doubleValue]*100;
//        if(taxvalue == value){
//            return i;
//        }
//    }
//    return  0;
//}



/**
 * 获取税率初始化数据 不加税/17%税/自定义税率
 */
NSMutableArray *getPayTaxInitData(){

    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
        NSNumber *tax_type = i == 0 ? @(1) : i == 1 ? @(2) : @(3);
        NSString *tax_title = i == 0 ? NSLocalizedString(@"不加税",nil) : i == 1 ? NSLocalizedString(@"17%税",nil) : NSLocalizedString(@"自定义税率",nil);

        NSNumber *tax_value = i == 0 ? @(0) : i == 1 ? @(0.17) : @(0);
        [tempDict setObject:tax_type forKey:@"tax_type"];
        [tempDict setObject:tax_title forKey:@"tax_title"];
        [tempDict setObject:tax_value forKey:@"tax_value"];
        [tempArr addObject:tempDict];
    }
    return tempArr;
}

/**
 * 注：只提供修改自定义税率接口 更安全😊
 *    其他类型税率是不变的
 * DES 修改自定义税率
 */
void updateCustomTaxValue(NSMutableArray *taxData,NSNumber *value,BOOL shouldClear){
    if(taxData){
        if(taxData.count > 2){
            NSInteger valueNum = [value floatValue]*100;
            if(value){
                if(shouldClear){
                    if(valueNum == 17 || valueNum == 0){
                        [taxData removeAllObjects];
                        [taxData addObjectsFromArray:getPayTaxInitData()];
                    }else{
                        NSMutableDictionary *customTaxDict = taxData[2];
                        if([[customTaxDict objectForKey:@"tax_type"] integerValue] == 3){
                            [customTaxDict setObject:value forKey:@"tax_value"];
                        }
                    }
                }else{
                    NSMutableDictionary *customTaxDict = taxData[2];
                    if([[customTaxDict objectForKey:@"tax_type"] integerValue] == 3){
                        [customTaxDict setObject:value forKey:@"tax_value"];
                    }
                }

            }
        }
    }
    NSLog(@"111");
}
/**
 * 获取对应的描述
 *   %17 VAT | 1 ------> 17%税
 *  Tax Free | 0 ------> Tax
 *   taxData | 2 ------> 0.22
 */
NSString *getPayTaxValue(NSMutableArray *taxData,NSInteger type,BOOL isTxt){
    if(taxData){
        if(taxData.count > type){
            NSMutableDictionary *customTaxDict = taxData[type];
            if(isTxt){
                if(type == 2){
                    CGFloat tax_value = [[customTaxDict objectForKey:@"tax_value"] floatValue]*100.0f;
                    return [[NSString alloc] initWithFormat:@"%.0lf%%%@",tax_value,[LanguageManager isEnglishLanguage]?@" Tax":@"税"];
                }else{
                    return [customTaxDict objectForKey:@"tax_title"];
                }
            }else{
                return [[customTaxDict objectForKey:@"tax_value"] stringValue];
            }
        }
    }
    return @"";
}
/**
 * 获取对应税率整数形式
 *   taxData | 0 ------> 0
 *   taxData | 1 ------> 17
 *   taxData | 2 ------> 22
 */
NSInteger getPayTaxTypeToServiceNew(NSMutableArray *taxData,NSInteger value){
    NSString *serviceValue = getPayTaxValue(taxData, value, NO);
    return [serviceValue floatValue]*100;
}
/**
 * 获取整数形式税率对应的index
 *   taxData | 0 ------> 0
 *   taxData | 17 ------> 1
 *   taxData | 30 ------> 2
 */
NSInteger getPayTaxTypeFormServiceNew(NSMutableArray *taxData,NSInteger value){
    for (NSInteger i=0; i<taxData.count; i++) {
        NSMutableDictionary *tempDict = taxData[i];
        NSInteger taxvalue = [[tempDict objectForKey:@"tax_value"] floatValue]*100;
        if(taxvalue == value){
            return i;
        }
    }
    return  0;
}

