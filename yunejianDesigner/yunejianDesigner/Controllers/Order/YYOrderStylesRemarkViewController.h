//
//  YYOrderStylesRemarkViewController.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderInfoModel.h"

@interface YYOrderStylesRemarkViewController : UIViewController
@property(nonatomic,strong) CancelButtonClicked cancelButtonClicked;
@property(nonatomic,strong) ModifySuccess saveButtonClicked;
@property(nonatomic,strong) YYOrderInfoModel *orderInfoModel;

@end
