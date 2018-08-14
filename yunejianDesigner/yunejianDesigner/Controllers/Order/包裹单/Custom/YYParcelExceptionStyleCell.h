//
//  YYParcelExceptionStyleCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYParcelExceptionModel;

@interface YYParcelExceptionStyleCell : UITableViewCell

-(void)updateUI;

@property (nonatomic, strong) YYParcelExceptionModel *parcelExceptionModel;

@end
