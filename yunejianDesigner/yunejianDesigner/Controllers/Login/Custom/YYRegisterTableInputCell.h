//
//  YYRegisterTableInputCell.h
//  yunejianDesigner
//
//  Created by Victor on 2017/12/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTableViewCellInfoModel.h"

@interface YYRegisterTableInputCell : UITableViewCell {
    YYTableViewCellInfoModel *infoModel;
}

@property (nonatomic,assign) BOOL isMust;

@property(nonatomic,weak)id<YYRegisterTableCellDelegate> delegate;
@property(nonatomic,copy)NSIndexPath * indexPath;

@property(nonatomic,strong) UITapGestureRecognizer *tap;

@property(nonatomic,strong) YYTableViewCellInfoModel *otherInfo;

-(void)updateCellInfo:(YYTableViewCellInfoModel *)info;

@end
