//
//  YYBuyerModifyCellContactMobileTableViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBrandModifyCellContactMobileViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectRootBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectLocalBtn;

@property (weak, nonatomic) IBOutlet UITextField *valueInput;

@property (weak, nonatomic) IBOutlet UILabel *localLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;

@property (nonatomic ,strong) NSString *detailType;
@property (nonatomic ,strong) NSString *value;
@property (nonatomic ,assign) NSInteger selectlimitValue;
@property (nonatomic ,assign) NSInteger selectlocalValue;

@property(nonatomic,weak)id<YYTableCellDelegate> delegate;
-(void)updateUI;
@end
