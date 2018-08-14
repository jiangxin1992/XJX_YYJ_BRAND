//
//  YYShowroomNotificationListCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/3/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShowroomOrderingModel;

@interface YYShowroomNotificationListCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,NSNumber *orderingID))block;

@property (nonatomic, copy) void (^block)(NSString *type,NSNumber *orderingID);

@property (nonatomic, strong) YYShowroomOrderingModel *logisticsModel;

@end
