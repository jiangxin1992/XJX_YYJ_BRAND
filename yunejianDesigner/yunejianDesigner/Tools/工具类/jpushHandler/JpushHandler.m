//
//  jpushHandler.m
//  YunejianBuyer
//
//  Created by Apple on 16/5/3.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JpushHandler.h"
#import "YYUser.h"
#import "AppDelegate.h"
#import "YYConnMsgListController.h"
#import "YYOrderMessageViewController.h"
#import "YYNewsDetailViewController.h"
#import "YYOrderApi.h"
@implementation JpushHandler
+ (void)setupJpush:(NSDictionary *)launchOptions {
//    // Required
//    UIUserNotificationTypeBadge |
//    UIUserNotificationTypeSound |
//    UIUserNotificationTypeAlert
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(7)
                                          categories:nil];
     // Required
    [JPUSHService setupWithOption:launchOptions appKey:kJPushAppKey
                          channel:kJPushChannel
                 apsForProduction:kJPushIsProduction
            advertisingIdentifier:nil];
    [JPUSHService crashLogON];

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
}
+ (void)networkDidSetup:(NSNotification *)notification
{
    [self sendTagsAndAlias];
    //    [self sendUserIdToAlias];
}

// 提交后的结果回调, 见 http://docs.jpush.cn/pages/viewpage.action?pageId=3309913
+ (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    NSString *callbackString = [NSString stringWithFormat:@"Result: %d, \ntags: %@, \nalias: %@\n", iResCode, [JpushHandler logSet:tags], alias];
    
    // 提交成功
    if (iResCode == 0) {
        NSString *build = [[NSUserDefaults standardUserDefaults] objectForKey:@"tmpLastBuildNumberIndentifier"];
        
        [[NSUserDefaults standardUserDefaults] setObject:build forKey:@"LastBuildNumberIndentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSLog(@"JPUSH TagsAlias 回调: %@", callbackString);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
+ (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) return nil;
    
    NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData   = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}

+ (void)sendTagsAndAlias {
    YYUser *user = [YYUser currentUser];
    if ([user.userId integerValue] > 0) {

        NSString * build = [NSString stringWithFormat:@"ios_build_%@", [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey]];
        NSMutableSet *tags = [NSMutableSet set];

        // Detail Version
        NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString *fullVersionNum = [NSString stringWithFormat:@"ios_v_%@", [version stringByReplacingOccurrencesOfString:@"." withString:@"_"]];

        // Big Version
        NSArray *verisonArray = [version componentsSeparatedByString:@"."];
        NSString *bigVersionNum = [NSString stringWithFormat:@"ios_v_%@", verisonArray[0]];

        //            0:设计师 1:买手店 2:销售代表 5:Showroom 6:Showroom子账号
        //            0:设计师 1:买手店 2:销售代表 5:Showroom 6:Showroom子账号
        //            设计师端的设备会接受到的标签是 DESIGNER和SALESMAN   买手接受到的是RETAILER    SHOWROOM,SHOWROOMSUB
        NSString *roleTag = user.userType==0?@"DESIGNER":user.userType==1?@"RETAILER":user.userType==2?@"SALESMAN":user.userType==5?@"SHOWROOM":user.userType==6?@"SHOWROOMSUB":nil;

        [tags addObject:fullVersionNum];
        [tags addObject:bigVersionNum];
        [tags addObject:build];

        if(roleTag)
        {
            [tags addObject:roleTag];
        }

        if(YYDEBUG == 0){
            //生产
            NSMutableString *distribution_alias = [NSMutableString stringWithFormat:@"distribution_userId_%@_%@",@"iPhoneDesigner", user.userId];
            if([roleTag isEqualToString:@"SHOWROOM"]){
                //showroom角色
                [distribution_alias appendString:@"_5"];
            }else if([roleTag isEqualToString:@"SHOWROOMSUB"]){
                //showroom子账号角色
                [distribution_alias appendString:@"_6"];
            }else{
                //一般我们认为是设计师角色
            }
            [JPUSHService setTags:tags alias:distribution_alias
                 callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        }else if(YYDEBUG == 1){
            //测试环境
            NSMutableString *develop_alias = [NSMutableString stringWithFormat:@"develop_userId_%@_%@",@"iPhoneDesigner", user.userId];
            if([roleTag isEqualToString:@"SHOWROOM"]){
                //showroom角色
                [develop_alias appendString:@"_5"];
            }else if([roleTag isEqualToString:@"SHOWROOMSUB"]){
                //showroom子账号角色
                [develop_alias appendString:@"_6"];
            }else{
                //一般我们认为是设计师角色
            }
            [JPUSHService setTags:tags alias:develop_alias
                 callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        }else if(YYDEBUG == 2){
            //展示环境
            NSMutableString *show_alias = [NSMutableString stringWithFormat:@"adhoc_userId_%@_%@",@"iPhoneDesigner", user.userId];
            if([roleTag isEqualToString:@"SHOWROOM"]){
                //showroom角色
                [show_alias appendString:@"_5"];
            }else if([roleTag isEqualToString:@"SHOWROOMSUB"]){
                //showroom子账号角色
                [show_alias appendString:@"_6"];
            }else{
                //一般我们认为是设计师角色
            }
            [JPUSHService setTags:tags alias:show_alias
                 callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        }
    }
}

+ (void)sendEmptyAlias {
    [JPUSHService setAlias:@"" callbackSelector:nil object:self];
}

+ (void)handleUserInfo:(NSDictionary *)userInfo {
//    if (userInfo[@"reply_id"] && userInfo[@"replies_url"]) {
//        NSString *repliesUrl = userInfo[@"replies_url"];
//        //TopicEntity *topic = [TopicEntity new];
//        //topic.topicRepliesUrl = repliesUrl;
//        //[JumpToOtherVCHandler jumpToCommentListVCWithTopic:topic];
//    } else if (userInfo[@"topic_id"]) {
//        //[JumpToOtherVCHandler jumpToTopicDetailWithTopicId:userInfo[@"topic_id"]];
//    }
    NSInteger msgType = [[userInfo objectForKey:@"msgType"] integerValue];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(msgType == 0){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
        YYConnMsgListController *messageViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYConnMsgListController"];
        [messageViewController setMarkAsReadHandler:^(void){
            [YYConnMsgListController  markAsRead];
        }];
        [appDelegate.mainViewController pushViewController:messageViewController animated:YES];
    }else if(msgType == 1){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
        YYOrderMessageViewController *orderMessageViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderMessageViewController"];
        [orderMessageViewController setMarkAsReadHandler:^(void){
           [YYOrderMessageViewController markAsRead];
        }];
        [appDelegate.mainViewController pushViewController:orderMessageViewController animated:YES];
    }else if(msgType == 3)
    {
        if(![NSString isNilOrEmpty:[userInfo objectForKey:@"url"]])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"News" bundle:[NSBundle mainBundle]];
            YYNewsDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNewsDetailViewController"];
            detailViewController.newsUrlString = [userInfo objectForKey:@"url"];
            [appDelegate.mainViewController pushViewController:detailViewController animated:YES];
            
            [detailViewController setCancelButtonClicked:^(){
                [appDelegate.mainViewController popViewControllerAnimated:YES];
            }];
        }
    }else if(msgType == 4)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate showMessageView:nil parentViewController:getCurrentViewController()];
    }else if (msgType == 10) {
        [appDelegate showStyleDetailWithStyleId:[[userInfo objectForKey:@"styleId"] integerValue] parentViewController:getCurrentViewController()];
    }
}

+ (void)setLocalNotification{
    NSDate *notificationDatePickerDate = [[NSDate alloc] initWithTimeIntervalSinceNow:10];
    NSString *notificationBodyText = @"alert body";
    int notificationBadgeText = 1;
    NSString * notificationButtonText = NSLocalizedString(@"查看",nil);
    NSString *notificationIdentifierText = @"mlh";
    [JPUSHService
     setLocalNotification: notificationDatePickerDate
     alertBody:notificationBodyText
     badge:notificationBadgeText
     alertAction:notificationButtonText
     identifierKey:notificationIdentifierText
     userInfo:nil
     soundName:nil];
}
@end
