//
//  YYPackageListCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/28.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPackageModel;

@interface YYPackageListCell : UITableViewCell

@property (nonatomic, strong) YYPackageModel *packageModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *packageName;

- (void)updateUI;

@end
