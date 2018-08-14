//
//  YYSellerListViewController.h
//  yunejianDesigner
//
//  Created by Apple on 16/6/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYShowroomInfoModel.h"

@interface YYSellerListViewController : UIViewController

@property(nonatomic,strong)CancelButtonClicked cancelButtonClicked;
@property (strong, nonatomic) YYShowroomInfoModel *ShowroomModel;
@property(nonatomic,strong) ModifySuccess modifySuccess;
@end
