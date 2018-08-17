//
//  YYOrderStatusCell.h
//  Yunejian
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderInfoModel,YYOrderTransStatusModel;

@interface YYOrderStatusCell : UITableViewCell{
    NSInteger uiStatus;//0意向单  1
    NSInteger progress;
}

@property (nonatomic, strong) YYOrderInfoModel *currentYYOrderInfoModel;
@property (strong, nonatomic) YYOrderTransStatusModel *currentYYOrderTransStatusModel;
@property (nonatomic, assign) NSInteger currentOrderConnStatus;
@property (weak, nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

-(void)updateUI;

+(float)cellHeight:(NSInteger)tranStatus;

@end
