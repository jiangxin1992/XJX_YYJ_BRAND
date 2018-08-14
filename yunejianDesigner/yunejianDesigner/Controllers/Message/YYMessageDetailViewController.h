//
//  YYMessageDetailViewController.h
//  yunejianDesigner
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYMessageDetailViewController : UIViewController
@property(nonatomic,strong) CancelButtonClicked cancelButtonClicked;
@property(nonatomic,strong) NSString *userlogo;
@property(nonatomic,strong) NSString *userEmail;
@property(nonatomic,strong) NSNumber *userId;
@property(nonatomic,strong) NSString *buyerName;
+(void)markAsRead;
@end
