//
//  YYBuyerInfoViewController.h
//  yunejianDesigner
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYBuyerInfoViewController : UIViewController
@property (nonatomic,assign) NSInteger buyerId;
@property (nonatomic,strong) NSString *previousTitle;

@property (nonatomic,assign) BOOL isConned;
@property (nonatomic,strong) ModifySuccess modifySuccess;
@property (nonatomic,strong) CancelButtonClicked cancelButtonClicked;
@end
