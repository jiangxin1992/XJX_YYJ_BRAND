//
//  YYStockMessageListViewController.h
//  yunejianDesigner
//
//  Created by Victor on 2018/2/1.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYStockMessageListViewController : UIViewController

@property (nonatomic, copy) void(^willDisappearBlock)(void);

- (void)markSkuAsRead;

@end
