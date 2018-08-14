//
//  YYNewsTableViewController.h
//  YunejianBuyer
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYNewsTableViewController : UIViewController
@property(nonatomic,assign)NSInteger index;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;

-(void)relaodTableData:(BOOL)newData;
@end
