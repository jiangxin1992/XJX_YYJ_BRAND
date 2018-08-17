//
//  YYPickingListStyleEditCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPackingListStyleModel;

@interface YYPickingListStyleEditCell : UITableViewCell

@property (nonatomic, strong) YYPackingListStyleModel *packingListStyleModel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type))block;

-(void)updateUI;

@end
