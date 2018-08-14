//
//  YYOrderStyleRemarkCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/8/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOrderStyleModel.h"
#import "SCGIFImageView.h"
@interface YYOrderStyleRemarkCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet SCGIFImageView *styleImageView;
@property (weak, nonatomic) IBOutlet UILabel *styleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkFlagView;
@property (weak, nonatomic) IBOutlet UILabel *remarkContentLabel;
@property (weak, nonatomic) IBOutlet UITextField *addRemarkInput;
@property (nonatomic,weak)id<YYTableCellDelegate> delegate;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (strong, nonatomic) YYOrderStyleModel *orderStyleModel;
@property (strong, nonatomic) NSString *remarkTip;

-(void)updateUI;
+(float)cellHeight:(NSString*)remark;
@end
