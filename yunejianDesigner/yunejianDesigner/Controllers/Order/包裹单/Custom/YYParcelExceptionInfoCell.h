//
//  YYParcelExceptionInfoCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYParcelExceptionModel;

@interface YYParcelExceptionInfoCell : UITableViewCell

-(void)updateUI;

@property (nonatomic, copy) void (^parcelExceptionInfoCellBlock)(NSString *type,NSIndexPath *indexPath,NSInteger selectIndex);
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) YYParcelExceptionModel *parcelExceptionModel;

@end
