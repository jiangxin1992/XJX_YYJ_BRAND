//
//  YYConnBuyerListCell.h
//  Yunejian
//
//  Created by Apple on 15/12/14.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYConnBuyerModel.h"
#import "SCGIFImageView.h"
@interface YYConnBuyerInfoListCell : UICollectionViewCell
{
    BOOL isFirstUpdate;
}

@property (weak, nonatomic) IBOutlet SCGIFImageView *buyerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *oprateBtn;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLayoutTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewLayoutTopConstraint;
@property (nonatomic , assign) BOOL isModity;
- (IBAction)oprateBtnHandler:(id)sender;
@property (nonatomic,strong)YYConnBuyerModel *buyermodel;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
-(void)updateUI;
@end
