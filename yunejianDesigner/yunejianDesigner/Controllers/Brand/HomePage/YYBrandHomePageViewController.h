//
//  YYDesignerHomePageViewController.h
//  yunejianDesigner
//
//  Created by yyj on 2017/2/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBrandHomePageViewController : UIViewController

-(instancetype)initWithBlock:(void (^)(NSString *type,NSNumber *connectStatus))block;

/** 回调block*/
@property (nonatomic, copy) void (^block)(NSString *type,NSNumber *connectStatus);

@property (nonatomic, assign) NSInteger designerId;
@property (nonatomic, strong) NSString *previousTitle;
@property (nonatomic, assign) BOOL isHomePage;

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;
@property (nonatomic, strong) YellowPabelCallBack selectedValue;

@end
