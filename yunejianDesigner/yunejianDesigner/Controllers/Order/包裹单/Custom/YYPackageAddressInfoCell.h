//
//  YYPackageAddressInfoCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/29.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPackingListDetailModel;

@interface YYPackageAddressInfoCell : UITableViewCell

-(void)updateUI;

@property (nonatomic, strong) YYPackingListDetailModel *packingListDetailModel;

@end
