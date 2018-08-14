//
//  YYUserLogoInfoCell.h
//  Yunejian
//
//  Created by Apple on 15/9/22.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGIFButtonView.h"
@protocol YYUserLogoInfoCellDelegate
-(void)handlerBtnClick:(id)target;
-(void)settingBtnClick:(id)target;
@end

@interface YYUserLogoInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SCGIFButtonView *logoButton;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property(nonatomic,weak)id<YYUserLogoInfoCellDelegate> delegate;

- (IBAction)changeLogoHandler:(id)sender;
@end
