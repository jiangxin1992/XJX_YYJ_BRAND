//
//  YYBrandTableViewController.h
//  YunejianBuyer
//
//  Created by Apple on 16/5/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYBrandTableViewController : UIViewController
@property (nonatomic,assign) NSInteger currentListType;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
-(void)reloadBrandData;
@end
