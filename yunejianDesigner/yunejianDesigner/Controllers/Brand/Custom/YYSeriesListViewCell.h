//
//  YYSeriesListViewCell.h
//  Yunejian
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOpusSeriesModel.h"
#import "SCGIFImageView.h"
@interface YYSeriesListViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *seasonLabel;
//@property (weak, nonatomic) IBOutlet UILabel *supplyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *styleAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDueTimeLabel;
@property (nonatomic,copy)YYOpusSeriesModel *seriesModel;

@property (weak, nonatomic) IBOutlet SCGIFImageView *coverImageView;
-(void)updateUI;
@end
