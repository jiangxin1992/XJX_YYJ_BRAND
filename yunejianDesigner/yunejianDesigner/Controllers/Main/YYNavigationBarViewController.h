//
//  YYNavigationBarViewController.h
//  Yunejian
//
//  Created by yyj on 15/7/13.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NavigationButtonType) {
    NavigationButtonTypeGoBack = 0
};

typedef void (^NavigationButtonClicked)(NavigationButtonType buttonType);

@interface YYNavigationBarViewController : UIViewController

@property(nonatomic,strong) NSString *previousTitle;
@property(nonatomic,strong) NSString *nowTitle;

@property(nonatomic,strong)NavigationButtonClicked navigationButtonClicked;


- (void)updateUI;

@end
