//
//  YYConnMsgListController.h
//  Yunejian
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYConnMsgListController : UIViewController
@property(nonatomic,strong) CancelButtonClicked markAsReadHandler;
+(void)markAsRead;
@end
