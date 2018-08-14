//
//  YYPackingListViewController.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 订单关联状态
 */
typedef NS_ENUM(NSInteger, YYPackingListType) {
    YYPackingListTypeCreate,//新建装箱单
    YYPackingListTypeModify,//修改装箱单
    YYPackingListTypeDetail //装箱单详情
};

@interface YYPackingListViewController : UIViewController

@property (nonatomic, assign) YYPackingListType packingListType;//控制器类型

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) CancelButtonClicked cancelButtonClicked;

@property (nonatomic, strong) ModifySuccess modifySuccess;

@property (nonatomic, strong) NSString *orderCode;//用于获取订单商品详情信息

@property (nonatomic, strong) NSNumber *packageId;//用户获取单个装箱单详情

@end
