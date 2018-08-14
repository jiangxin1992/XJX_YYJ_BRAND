//
//  YYPayLogViewController.h
//  yunejianDesigner
//
//  Created by Victor on 2017/12/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYPaymentNoteModel.h"

@interface YYPayLogViewController : UIViewController

@property (nonatomic, copy) void(^affirmRecordBlock)(void);
@property (nonatomic, copy) void(^cancelRecordBlock)(void);
@property (nonatomic, copy) void(^deleteRecordBlock)(void);

@property(nonatomic,strong) YYPaymentNoteModel *noteModel;

@end
