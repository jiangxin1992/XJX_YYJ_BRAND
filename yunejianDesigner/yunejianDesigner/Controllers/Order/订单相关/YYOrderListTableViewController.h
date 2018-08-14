//
//  YYOrderListTableViewController.h
//  YunejianBuyer
//
//  Created by Apple on 16/5/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYOrderListTableViewController : UIViewController

@property(nonatomic,assign) int currentOrderType;//订单类型，0，正常（默认值）；1，已取消(已取消10 + 已关闭11)

@property(nonatomic,assign) int currentPayType;//0 1

@property(nonatomic,assign) NSString *curentOrderStatus;// 0 4-9

@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;

-(void)relaodTableData:(BOOL)newData;

-(void)reloadListItem:(NSInteger)row;

@end
