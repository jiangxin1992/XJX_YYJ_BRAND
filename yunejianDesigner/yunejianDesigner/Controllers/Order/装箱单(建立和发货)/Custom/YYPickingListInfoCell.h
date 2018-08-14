//
//  YYPickingListInfoCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPackingListDetailModel;

@interface YYPickingListInfoCell : UITableViewCell

@property (nonatomic ,strong) YYPackingListDetailModel *packingListDetailModel;

-(void)updateUI;

+(CGFloat)cellHeight;

@end
