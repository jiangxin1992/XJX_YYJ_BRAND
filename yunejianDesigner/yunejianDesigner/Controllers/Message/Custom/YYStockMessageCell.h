//
//  YYStockMessageCell.h
//  yunejianDesigner
//
//  Created by Victor on 2018/2/2.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSkuMessageModel.h"

@interface YYStockMessageCell : UITableViewCell

- (void)updateUIWithModel:(YYSkuMessageModel *)model;

@end
