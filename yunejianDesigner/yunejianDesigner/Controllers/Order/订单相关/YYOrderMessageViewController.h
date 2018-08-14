//
//  YYOrderMessageViewController.h
//  Yunejian
//
//  Created by Apple on 15/10/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYOrderMessageViewController : UIViewController

@property(nonatomic,strong) CancelButtonClicked markAsReadHandler;

+(void)markAsRead;

@end
