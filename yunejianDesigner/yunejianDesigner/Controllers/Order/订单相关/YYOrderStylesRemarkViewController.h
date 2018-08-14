//
//  YYOrderStylesRemarkViewController.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderInfoModel;

@interface YYOrderStylesRemarkViewController : UIViewController

@property(nonatomic,strong) CancelButtonClicked cancelButtonClicked;

@property(nonatomic,strong) ModifySuccess saveButtonClicked;

@property(nonatomic,strong) YYOrderInfoModel *orderInfoModel;

@end
