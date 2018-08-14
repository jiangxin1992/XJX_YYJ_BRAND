//
//  YYBuyerTableViewController.h
//  yunejianDesigner
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBuyerTableViewController : UIViewController
@property (nonatomic,assign) NSInteger currentListType;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
-(void)reloadBrandData;
@end
