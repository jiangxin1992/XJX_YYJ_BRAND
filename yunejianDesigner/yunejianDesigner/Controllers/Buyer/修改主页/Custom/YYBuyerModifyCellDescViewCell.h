//
//  YYBuyerModifyCellDescViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBuyerModifyCellDescViewCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *descInputText;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (nonatomic, assign)NSInteger maxLength; //允许最大的输入个数,默认是一个很大的数
@property (nonatomic ,strong) NSString *detailType;
@property (nonatomic ,strong) NSString *value;
@property(nonatomic,weak)id<YYTableCellDelegate> delegate;
-(void)updateUI;
@end
