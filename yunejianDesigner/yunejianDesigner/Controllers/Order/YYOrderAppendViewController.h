//
//  YYOrderAppendViewController.h
//  Yunejian
//
//  Created by Apple on 16/8/8.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYOrderAppendViewController : UIViewController
@property (nonatomic,strong)YellowPabelCallBack modifySuccess;
@property (nonatomic,strong)CancelButtonClicked cancelButtonClicked;
@property (nonatomic,strong)NSString *ordreCode;
@end
