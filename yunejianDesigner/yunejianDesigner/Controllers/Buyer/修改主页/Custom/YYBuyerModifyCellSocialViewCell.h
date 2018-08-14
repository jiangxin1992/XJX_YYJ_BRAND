//
//  YYBuyerModifyCellSocialViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBuyerModifyCellSocialViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *valueInput;
@property (nonatomic ,strong) NSString *detailType;
@property (nonatomic ,strong) NSString *value;
@property(nonatomic,weak)id<YYTableCellDelegate> delegate;
-(void)updateUI;
@end
