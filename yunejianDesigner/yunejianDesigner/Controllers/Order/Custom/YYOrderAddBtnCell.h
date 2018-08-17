//
//  YYOrderAddBtnCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/3/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYOrderAddBtnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *oprateBtn;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) NSString *btnStr;
-(void)updateUI;
@end
