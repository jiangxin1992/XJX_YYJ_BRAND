//
//  YYNewsViewController.h
//  YunejianBuyer
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewPagerController.h"

@interface YYNewsViewController : ViewPagerController

@property(nonatomic, strong) CancelButtonClicked cancelButtonClicked;

+(void)markAsRead;

@end
