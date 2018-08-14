//
//  YYShowMessageUrlViewController.h
//  YunejianBuyer
//
//  Created by chuanjun sun on 2017/11/27.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^okButtonClick)(NSString *jumpUrl);

@interface YYShowMessageUrlViewController : UIViewController
/** message */
@property (nonatomic, copy) NSString *message;

/**  */
@property (nonatomic, copy) okButtonClick okClick;
@end
