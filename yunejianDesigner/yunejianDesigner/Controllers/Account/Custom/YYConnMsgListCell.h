//
//  YYConnMsgListCell.h
//  Yunejian
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderMessageInfoModel;

@interface YYConnMsgListCell : UITableViewCell

@property (nonatomic, strong) YYOrderMessageInfoModel *msgInfoModel;
@property (nonatomic, weak) id<YYTableCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

-(void)updateUI;

@end
