//
//  YYBuyerAddressViewController.h
//  YunejianBuyer
//
//  Created by Apple on 16/2/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAddress.h"
typedef void (^SelectAddressClicked)(YYAddress *address);

@interface YYBuyerAddressViewController : UIViewController
@property(nonatomic,strong)CancelButtonClicked cancelButtonClicked;
@property(nonatomic,strong)SelectAddressClicked selectAddressClicked;
@property(nonatomic,assign)NSInteger isSelect;//1选择 0 修改
@end
