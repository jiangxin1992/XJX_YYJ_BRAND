//
//  YYCreateOrModifyAddressViewController.h
//  Yunejian
//
//  Created by yyj on 15/7/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAddress.h"
#import "YYOrderInfoModel.h"

typedef NS_ENUM(NSInteger, OperationType) {
    OperationTypeCreate = 80000,
    OperationTypeModify = 80001,
    OperationTypeHelpCreate = 80002
};

typedef void (^AddressForBuyerButtonClicked)(YYAddress *address);

@interface YYCreateOrModifyAddressViewController : UIViewController

@property(nonatomic,strong) AddressForBuyerButtonClicked addressForBuyerButtonClicked;

@property(nonatomic,strong) ModifySuccess modifySuccess;
@property(nonatomic,strong) CancelButtonClicked cancelButtonClicked;

@property(nonatomic,assign) OperationType currentOperationType;
//给订单添加地址时用，如果是离线创建，根据临时订单号先保存地址
@property (strong, nonatomic) YYOrderInfoModel *currentYYOrderInfoModel;

@property(nonatomic,strong) YYAddress *address;

@end
