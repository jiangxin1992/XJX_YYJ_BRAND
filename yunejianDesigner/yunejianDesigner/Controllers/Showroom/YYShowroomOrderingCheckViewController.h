//
//  YYShowroomOrderingCheckViewController.h
//  yunejianDesigner
//
//  Created by yyj on 2018/3/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYShowroomOrderingCheckViewController : UIViewController

@property (nonatomic ,strong) CancelButtonClicked cancelButtonClicked;

@property (nonatomic, copy) void (^block)(NSString *type,NSNumber *appointmentId);

@property (nonatomic ,strong) NSNumber *appointmentId;

@end
