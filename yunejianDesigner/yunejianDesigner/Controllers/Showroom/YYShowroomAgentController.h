//
//  YYShowroomAgentController.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/14.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShowroomInfoByDesignerModel;

@interface YYShowroomAgentController : UIViewController

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;
@property (nonatomic, strong) YYShowroomInfoByDesignerModel *showroomInfoByDesignerModel;

@end
