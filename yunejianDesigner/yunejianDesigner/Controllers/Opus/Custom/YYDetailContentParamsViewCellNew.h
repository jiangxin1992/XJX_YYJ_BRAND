//
//  YYDetailContentParamsViewCellNew.h
//  YunejianBuyer
//
//  Created by Apple on 16/3/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYStyleInfoModel;

@interface YYDetailContentParamsViewCellNew : UITableViewCell

- (void)updateUI:(YYStyleInfoModel *)styleInfoModel atColorIndex:(NSInteger)colorIndex;

+ (CGFloat)getHeightWithColorModel:(YYStyleInfoModel *)styleInfoModel atColorIndex:(NSInteger)colorIndex;

@end
