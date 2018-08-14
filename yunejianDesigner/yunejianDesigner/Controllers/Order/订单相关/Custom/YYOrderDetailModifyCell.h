//
//  YYOrderDetailModifyCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/6/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderInfoModel;

@interface YYOrderDetailModifyCell : UITableViewCell

@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (strong, nonatomic) YYOrderInfoModel *currentYYOrderInfoModel;

@property(nonatomic,assign) NSInteger currentOrderConnStatus;

-(void)updateUI;

@end
