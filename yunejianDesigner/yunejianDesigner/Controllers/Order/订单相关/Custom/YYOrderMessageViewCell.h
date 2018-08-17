//
//  YYOrderMessageViewCell.h
//  Yunejian
//
//  Created by Apple on 15/10/27.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderMessageInfoModel;

@interface YYOrderMessageViewCell : UITableViewCell

@property (nonatomic, strong) YYOrderMessageInfoModel * msgInfoModel;
@property (nonatomic, strong) id<YYTableCellDelegate>delegate;

-(void)updateUI;

@end
