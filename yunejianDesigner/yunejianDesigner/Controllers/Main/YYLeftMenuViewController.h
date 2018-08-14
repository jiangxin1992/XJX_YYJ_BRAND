//
//  YYLeftMenuViewController.h
//  Yunejian
//
//  Created by yyj on 15/7/8.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LeftMenuButtonType) {
    LeftMenuButtonTypeIndex   = 50000,//首页
    LeftMenuButtonTypeOpus    = 50001,//作品
    LeftMenuButtonTypeOrder   = 50002,//订单
    LeftMenuButtonTypeAccount = 50003,//我的
    LeftMenuButtonTypeBrand   = 50004,//品牌
    LeftMenuButtonTypeSetting = 50005,//设置
    LeftMenuButtonTypeBuyer   = 50006 //买手店
};

typedef void (^LeftMenuButtonClicked)(LeftMenuButtonType buttonIndex);

@interface YYLeftMenuViewController : UIViewController

@property (nonatomic, strong) LeftMenuButtonClicked leftMenuButtonClicked;

- (void)setButtonSelectedByButtonIndex:(LeftMenuButtonType)leftMenuButtonIndex;

@end
