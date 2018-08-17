//
//  YYChooseWarehouseViewController.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYWarehouseModel;

@interface YYChooseWarehouseViewController : UIViewController

@property (strong, nonatomic) NSNumber *buyerId;//买手店id

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;

@property(nonatomic,copy) void (^chooseWarehouseSelectBlock)(YYWarehouseModel *warehouseModel);

@end
