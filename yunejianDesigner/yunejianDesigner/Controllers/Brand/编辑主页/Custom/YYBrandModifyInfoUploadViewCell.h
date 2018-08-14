//
//  YYBuyerModifyInfoUploadViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCGIFButtonView.h"
@interface YYBrandModifyInfoUploadViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SCGIFButtonView *photoIamgeBtn1;
@property (weak, nonatomic) IBOutlet SCGIFButtonView *photoIamgeBtn2;
@property (weak, nonatomic) IBOutlet SCGIFButtonView *photoIamgeBtn3;
@property (weak, nonatomic) IBOutlet SCGIFButtonView *photoIamgeBtn4;
@property (weak, nonatomic) IBOutlet SCGIFButtonView *photoIamgeBtn5;
@property (weak, nonatomic) IBOutlet SCGIFButtonView *photoIamgeBtn6;
@property (weak, nonatomic) IBOutlet SCGIFButtonView *photoIamgeBtn7;
@property (weak, nonatomic) IBOutlet SCGIFButtonView *photoIamgeBtn8;
@property (weak, nonatomic) IBOutlet UIView *photoImageTipView1;
@property (weak, nonatomic) IBOutlet UILabel *updateTipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewLayoutLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewLayoutTopConstraint;
@property(nonatomic,weak)id<YYTableCellDelegate> delegate;
@property(nonatomic,copy)NSIndexPath * indexPath;
-(void)updateCellInfo:(NSArray*)info;
-(void)updateParamInfo:(NSArray*)info;
- (IBAction)photoBtnClicked1:(id)sender;
- (IBAction)photoBtnClicked2:(id)sender;
- (IBAction)photoBtnClicked3:(id)sender;
- (IBAction)photoBtnClicked4:(id)sender;
- (IBAction)photoBtnClicked5:(id)sender;
- (IBAction)photoBtnClicked6:(id)sender;
- (IBAction)photoBtnClicked7:(id)sender;
- (IBAction)photoBtnClicked8:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteBtn1;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteBtn2;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteBtn3;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteBtn4;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteBtn5;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteBtn6;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteBtn7;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteBtn8;
- (IBAction)photoDeleteBtnClicked1:(id)sender;
- (IBAction)photoDeleteBtnClicked2:(id)sender;
- (IBAction)photoDeleteBtnClicked3:(id)sender;
- (IBAction)photoDeleteBtnClicked4:(id)sender;
- (IBAction)photoDeleteBtnClicked5:(id)sender;
- (IBAction)photoDeleteBtnClicked6:(id)sender;
- (IBAction)photoDeleteBtnClicked7:(id)sender;
- (IBAction)photoDeleteBtnClicked8:(id)sender;

+(float)cellHeight:(NSInteger)count;

@end
