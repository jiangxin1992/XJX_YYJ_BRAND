//
//  YYInventoryDetailViewController.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYInventoryAllottingModel.h"
@interface YYInventoryDetailViewController : UIViewController
@property(nonatomic,strong) CancelButtonClicked cancelButtonClicked;
@property(nonatomic,strong) YYInventoryAllottingModel *allottingModel;
@end