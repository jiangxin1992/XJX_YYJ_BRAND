//
//  YYShoppingCell.h
//  Yunejian
//
//  Created by Apple on 15/8/3.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYStyleInfoModel,SCGIFImageView;

@interface YYShoppingCell : UITableViewCell

@property (nonatomic, assign) BOOL isOnlyColor;

@property (nonatomic, copy) NSArray *amountsizeArr;//数量 YYOrderSizeModel
@property (nonatomic, strong) YYStyleInfoModel *styleInfoModel;

@property(nonatomic,copy) NSIndexPath * indexPath;
@property (nonatomic,weak) id<YYTableCellDelegate> delegate;

-(void)updateUI;

@end
