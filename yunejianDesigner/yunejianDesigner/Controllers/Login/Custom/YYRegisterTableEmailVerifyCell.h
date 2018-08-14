//
//  YYRegisterTableEmailVerifyCell.h
//  yunejianDesigner
//
//  Created by Victor on 2017/12/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTableViewCellInfoModel.h"

@interface YYRegisterTableEmailVerifyCell : UITableViewCell

@property (nonatomic, copy)void(^submitBlock)(void);

-(void)updateCellInfo:(YYTableViewCellInfoModel *)info;

@end
