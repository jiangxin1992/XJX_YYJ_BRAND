//
//  YYBuyerInviteViewCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBuyerModel.h"
#import "SCGIFImageView.h"
@interface YYBuyerInviteViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet SCGIFImageView *lookbookImage1;
//@property (weak, nonatomic) IBOutlet UIImageView *lookbookImage2;
//@property (weak, nonatomic) IBOutlet UIImageView *lookbookImage3;
//@property (weak, nonatomic) IBOutlet UILabel *connBuyersLabel;
//@property (weak, nonatomic) IBOutlet UILabel *brandDescLabel;
//@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *connStatusLabel;

@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,copy) YYBuyerModel *buyerModel;
//@property (nonatomic,assign) NSInteger curShowDetailRow;

@property (weak, nonatomic) IBOutlet UILabel *connInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
- (IBAction)addBtnHandler:(id)sender;

-(void)updateUI;
+(float)HeightForCell:(NSInteger )cellWidth connInfo:(NSString*)connInfo;
@end
