//
//  YYUrlLinksHandler.m
//  yunejianDesigner
//
//  Created by Apple on 16/11/16.
//  Copyright © 2016年 Apple. All rights reserved.
//
/*{
    "applinks": {
        "apps": [],
        "details": [
                    {
                        "appID": "86BC6SR69M.com.yunejian.yunejianDesigner",
                        "paths": ["/ycobrand/index/","/ycobrand/detail/*"]
                    },
                    {
                        "appID": "86BC6SR69M.com.yunejian.yunejianBuyer",
                        "paths": ["/ycobuyer/index/","/ycobuyer/detail/*"]
                    }
                    ]
    }
}

默认
demo http://linkt.ycosystem.com/ycobrand/index
demo ycobrand://linkt.ycosystem.com/ycobrand/index

具体事件
demo http://linkt.ycosystem.com/ycobrand/detail/action?key1=value1&key2=value2…..
demo ycobrand://linkt.ycosystem.com/ycobrand/detail/action?key1=value1&key2=value2….
*/
#import "YYUrlLinksHandler.h"
#import "AppDelegate.h"
#import "YYUser.h"
#import "YYOrderApi.h"
#import "YYOrderDetailViewController.h"
@implementation YYUrlLinksHandler
+ (void)handleUserInfo:(NSString*)actionType query:(NSString *)query{
    NSLog(@"action %@ query%@",actionType,query);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    YYUser *user = [YYUser currentUser];
    if(appDelegate.mainViewController != nil && [user.userId integerValue] > 0){//未登录
        if([actionType isEqualToString:@"messageView"]){
            [YYUrlLinksHandler showMessageView];
        }else if ([actionType isEqualToString:@"orderDetailView"]){
            [YYUrlLinksHandler showOrderDetailView:query];
        }
    } else{
        appDelegate.openURLInfo = [NSString stringWithFormat:@"%@?%@",actionType,query];
    }
}


+ (void)showMessageView{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *uiviewController = appDelegate.mainViewController.topViewController;
    [appDelegate showMessageView:nil parentViewController:uiviewController];
}

+(void)showOrderDetailView:(NSString *)query{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *uiviewController = appDelegate.mainViewController.topViewController;
    //NSArray *queryInfo = [query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?&="]];
    //__block NSString *orderCode = [queryInfo objectAtIndex:1];
    //__block NSString *brandLogo= [queryInfo objectAtIndex:3];
    NSDictionary *queryInfo = [YYUrlLinksHandler tranDataToNSDictionary:query];
    if(queryInfo == nil){
        return;
    }
    __block NSString *orderCode = [queryInfo objectForKey:@"orderCode"];
    [YYOrderApi getOrderTransStatus:orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOrderTransStatusModel *transStatusModel, NSError *error) {
        NSInteger transStatus = getOrderTransStatus(transStatusModel.designerTransStatus, transStatusModel.buyerTransStatus);
        if (transStatusModel == nil || transStatus == kOrderCode_DELETED) {
            [YYToast showToastWithView:uiviewController.view title:NSLocalizedString(@"此订单已被删除",nil) andDuration:kAlertToastDuration];//“
            return ;
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
            YYOrderDetailViewController *orderDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderDetailViewController"];
            orderDetailViewController.currentOrderCode = orderCode;
            //orderDetailViewController.currentOrderLogo =  brandLogo;
            orderDetailViewController.currentOrderConnStatus = kOrderStatusNUll;
            [uiviewController.navigationController pushViewController:orderDetailViewController animated:YES];
        }
    }];
}

//+(void)showInventoryView{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kShowInventoryNotification object:nil];
//}


+(NSDictionary *)tranDataToNSDictionary:(NSString *)query{
    NSArray *queryInfo = [query componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?&="]];
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    NSInteger len = [queryInfo count];
    if(len%2 != 0){
        NSLog(@"参数出错！");
        return nil;
    }
    len = len/2;
    for (NSInteger i=0;i<len; i++) {
        NSString *key = [queryInfo objectAtIndex:i*2];
        NSString *value = [queryInfo objectAtIndex:(i*2+1)];
        [mutableDic setObject:value forKey:key];
    }
    return [mutableDic copy];
}
@end
