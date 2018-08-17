//
//  YYOrderAddMoneyLogController.h
//  Yunejian
//
//  Created by Apple on 15/11/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPaymentNoteListModel;

@interface YYOrderAddMoneyLogController : UIViewController

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;
@property (nonatomic, copy) void (^modifySuccess)(NSString *orderCode, NSNumber *totalPercent);

@property (nonatomic, assign) double totalMoney;
@property (nonatomic, strong) NSString *orderCode;
@property (nonatomic, assign) NSInteger moneyType;
@property (nonatomic, assign) CGFloat isNeedRefund;

@end
