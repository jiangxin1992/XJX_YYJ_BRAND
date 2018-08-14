//
//  YYBuyerModifyCellConnBrandViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYBrandModifyCellConnBuyerViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *connBrandInputText1;
@property (weak, nonatomic) IBOutlet UITextField *connBrandInputText2;
@property (weak, nonatomic) IBOutlet UITextField *connBrandInputText3;
//@property (weak, nonatomic) IBOutlet UITextField *connBrandInputText4;
//@property (weak, nonatomic) IBOutlet UITextField *connBrandInputText5;
//@property (weak, nonatomic) IBOutlet UITextField *connBrandInputText6;
//@property (weak, nonatomic) IBOutlet UITextField *connBrandInputText7;

@property (nonatomic ,strong) NSString *detailType;
@property (nonatomic ,strong) NSString *value;
@property(nonatomic,weak)id<YYTableCellDelegate> delegate;
-(void)updateUI;

@end
