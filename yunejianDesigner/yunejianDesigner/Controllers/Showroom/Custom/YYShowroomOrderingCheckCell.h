//
//  YYShowroomOrderingCheckCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/3/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYShowroomOrderingCheckModel;

@interface YYShowroomOrderingCheckCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type,YYShowroomOrderingCheckModel *showroomOrderingCheckModel))block;

@property (nonatomic, copy) void (^block)(NSString *type,YYShowroomOrderingCheckModel *showroomOrderingCheckModel);

@property (nonatomic, strong) YYShowroomOrderingCheckModel *showroomOrderingCheckModel;

@end
