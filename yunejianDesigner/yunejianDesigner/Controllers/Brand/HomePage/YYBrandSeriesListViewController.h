//
//  YYBrandSeriesListViewController.h
//  Yunejian
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBrandSeriesListViewController : UIViewController

@property (nonatomic,assign) NSInteger isConnStatus;// -1没关系 1 合作 0 2邀请

@property (nonatomic,assign) NSInteger designerId;

@property (nonatomic,strong) YellowPabelCallBack selectedValue;

@end
