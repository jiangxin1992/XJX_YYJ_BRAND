//
//  YYSeriesDetailInfoViewCell.h
//  Yunejian
//
//  Created by Apple on 15/12/22.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSeriesInfoModel.h"
#import "YYLookBookModel.h"
#import "SCGIFImageView.h"
@interface YYSeriesDetailInfoViewCell : UICollectionViewCell{
    
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *supplyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDueTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (nonatomic,copy)YYSeriesInfoModel *seriesModel;
@property (nonatomic,copy)NSNumber *lookBookId;
@property (nonatomic,strong)YYLookBookModel *lookBookModel;
@property (strong,nonatomic) NSString <Optional>*brandDescription;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabelLayoutHeightLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *lookbookContainer;
@property (weak, nonatomic) IBOutlet UILabel *picsNullTipLabel;
@property (weak, nonatomic) IBOutlet SCGIFImageView *lookBookCoverImageView;
@property (nonatomic,strong) NSString *sortType;
- (IBAction)showLookBookPics:(id)sender;
-(void)updateUI;
- (IBAction)sortBtnHandler:(id)sender;
//+(NSInteger)getCellHeight:(NSString *)descStr;
@property (nonatomic, strong) SelectButtonClicked  selectButtonClicked;
@end
