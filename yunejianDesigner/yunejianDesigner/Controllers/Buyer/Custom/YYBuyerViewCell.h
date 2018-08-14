//
//  YYBuyerViewCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYConnBuyerModel.h"
#import "SCGIFImageView.h"
@interface YYBuyerViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
//@property (weak, nonatomic) IBOutlet UIButton *brandInfoBtn;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
//@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong)YYConnBuyerModel * infoModel;
-(void)updateUI;
@end
