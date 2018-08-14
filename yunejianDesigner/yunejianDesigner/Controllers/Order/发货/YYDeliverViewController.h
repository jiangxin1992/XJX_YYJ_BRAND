//
//  YYDeliverViewController.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPackingListDetailModel;

@interface YYDeliverViewController : UIViewController

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;

@property (nonatomic, strong) ModifySuccess modifySuccess;

@property (nonatomic ,strong) YYPackingListDetailModel *packingListDetailModel;

@end
