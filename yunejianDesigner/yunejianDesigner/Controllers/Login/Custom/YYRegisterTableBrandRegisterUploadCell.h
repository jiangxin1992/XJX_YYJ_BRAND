//
//  YYRegisterTableBrandRegisterUploadCell.h
//  yunejianDesigner
//
//  Created by Victor on 2017/12/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTableViewCellInfoModel.h"

@interface YYRegisterTableBrandRegisterUploadCell : UITableViewCell

@property(nonatomic,weak)id<YYRegisterTableCellDelegate> delegate;
@property (nonatomic, strong) UIImage *firstUploadImage;
@property (nonatomic, strong) UIImage *secondUploadImage;

-(void)updateCellInfo:(YYTableViewCellInfoModel *)info;

+(float)cellheight;

@end
