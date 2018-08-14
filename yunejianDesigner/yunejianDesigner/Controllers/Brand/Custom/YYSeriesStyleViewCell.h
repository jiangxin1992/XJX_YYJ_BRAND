//
//  YYSeriesStyleViewCell.h
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOpusStyleModel;

@interface YYSeriesStyleViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL opusStyleIsSelect;

@property (nonatomic, strong) YYOpusStyleModel *opusStyleModel;
@property (nonatomic, assign) BOOL isModifyOrder;
@property (assign, nonatomic) NSInteger selectTaxType;
@property (weak, nonatomic) id<YYTableCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

-(void)updateUI;

+(float)CellHeight:(NSInteger)cellWidth showtax:(BOOL)showtax;

@end
