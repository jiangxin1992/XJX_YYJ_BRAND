//
//  YYOpusSettingDefinedBuyerViewCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYOpusSettingDefinedBuyerViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (assign, nonatomic)NSInteger type;//0白名单    1黑名单
@property(nonatomic,copy)NSIndexPath * indexPath;

-(void)updateUI;
@end
