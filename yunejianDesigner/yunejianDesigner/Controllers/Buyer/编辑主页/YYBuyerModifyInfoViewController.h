//
//  YYBuyerModifyInfoViewController.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBuyerHomeInfoModel.h"
@interface YYBuyerModifyInfoViewController : UIViewController

@property (nonatomic, copy) void (^block)(NSString *type);

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;
@property (nonatomic, strong) YYBuyerHomeInfoModel *homeInfoModel;

@end
