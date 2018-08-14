//
//  YYOpusSettingDefinedTypeViewCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYOpusSettingDefinedTypeViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedInfoLabel;
@property (assign, nonatomic)NSInteger type;//0白名单    1黑名单
@property (assign, nonatomic)NSInteger selectedType;
@property (assign, nonatomic)NSInteger selectedCount;
@property(nonatomic,weak)id<YYTableCellDelegate> delegate;
@property(nonatomic,copy)NSIndexPath * indexPath;
-(void)updateUI;
@end
