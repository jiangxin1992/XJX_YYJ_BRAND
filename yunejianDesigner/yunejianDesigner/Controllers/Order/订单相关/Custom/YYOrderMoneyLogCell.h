//
//  YYOrderMoneyLogCell.h
//  Yunejian
//
//  Created by Apple on 15/11/25.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPaymentNoteListModel,YYOrderInfoModel,YYOrderTransStatusModel;

@interface YYOrderMoneyLogCell : UITableViewCell

@property (nonatomic, strong) YYOrderTransStatusModel *currentYYOrderTransStatusModel;
@property (nonatomic, strong) YYOrderInfoModel *currentYYOrderInfoModel;
@property (nonatomic, weak) id<YYTableCellDelegate> delegate;
@property (nonatomic, strong) YYPaymentNoteListModel *paymentNoteList;
@property (nonatomic, assign) NSInteger isPaylistShow;

-(void)updateUI;

+(float)cellHeight:(NSArray *)payNoteList tranStatus:(NSInteger)tranStatus isPaylistShow:(NSInteger)isPaylistShow;

@end
