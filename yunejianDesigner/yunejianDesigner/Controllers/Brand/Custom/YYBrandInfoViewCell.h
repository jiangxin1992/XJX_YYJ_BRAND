//
//  YYBrandInfoViewCell.h
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYConnDesignerModel.h"
#import "SCGIFImageView.h"
@interface YYBrandInfoViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet SCGIFImageView *lookbookImage1;
//@property (weak, nonatomic) IBOutlet UIImageView *lookbookImage2;
//@property (weak, nonatomic) IBOutlet UIImageView *lookbookImage3;
//@property (weak, nonatomic) IBOutlet UILabel *connBuyersLabel;
//@property (weak, nonatomic) IBOutlet UILabel *brandDescLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UILabel *connStatusLabel;

@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,copy) YYConnDesignerModel *designerModel;
//@property (nonatomic,assign) NSInteger curShowDetailRow;
- (IBAction)addBtnHandler:(id)sender;

-(void)updateUI;
+(float)HeightForCell:(NSInteger )cellWidth;
@end
