//
//  YYDeliverAddressInfoCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYDeliverModel;

@interface YYDeliverAddressInfoCell : UITableViewCell

-(void)updateUI;

@property (nonatomic ,strong) YYDeliverModel *deliverModel;

@end
