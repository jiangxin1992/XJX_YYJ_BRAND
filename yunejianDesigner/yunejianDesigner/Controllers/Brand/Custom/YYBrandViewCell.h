//
//  YYBrandViewCell.h
//  Yunejian
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYConnBrandInfoModel.h"
#import "SCGIFImageView.h"
@interface YYBrandViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
//@property (weak, nonatomic) IBOutlet UIButton *brandInfoBtn;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
//@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong)YYConnBrandInfoModel * brandInfoModel;
-(void)updateUI;
@end
