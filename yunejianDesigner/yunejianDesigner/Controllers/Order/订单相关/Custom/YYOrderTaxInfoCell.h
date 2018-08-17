//
//  YYOrderTaxInfoCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/7/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYStylesAndTotalPriceModel.h"
#import "YYOrderInfoModel.h"
@interface YYOrderTaxInfoCell : UITableViewCell
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UILabel *finalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *discountView;
@property (weak, nonatomic) IBOutlet UIView *taxView;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalStyleLabel;
@property (weak, nonatomic) IBOutlet UIButton *helpBtn;
@property (weak, nonatomic) IBOutlet UIControl *taxTypeUI;
@property (weak, nonatomic) IBOutlet UILabel *taxTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *taxTypeUIDownImg;
@property (weak, nonatomic) IBOutlet UIControl *discountNumUI;
@property (weak, nonatomic) IBOutlet UILabel *discountNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountPriceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountViewLayoutTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *topSpaceView;
@property (weak, nonatomic) IBOutlet UIView *bottomSpaceView;
@property (weak, nonatomic) IBOutlet UILabel *priceTitle;

@property (nonatomic,assign) NSInteger spaceViewType;//o top 1 bottom
@property (nonatomic,assign) NSInteger moneyType;
@property (nonatomic,assign) NSInteger selectTaxType;
@property (nonatomic,assign) NSInteger viewType;//1创建订单  2修改订单 3订单详情 4追单
@property(nonatomic,strong) YYStylesAndTotalPriceModel *stylesAndTotalPriceModel;//总数
@property (strong, nonatomic) YYOrderInfoModel *currentYYOrderInfoModel;

@property (strong,nonatomic) NSMutableArray *menuData;

@property (nonatomic,assign) NSInteger selectIndex;

@property(nonatomic,copy) void (^taxChooseBlock)();

-(void)updateUI;
+(float)CellHeight:(BOOL)taxView :(BOOL)discountView;
@end
