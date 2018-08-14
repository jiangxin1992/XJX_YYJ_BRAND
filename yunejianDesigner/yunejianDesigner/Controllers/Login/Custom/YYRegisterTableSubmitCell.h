//
//  YYRegisterTableSubmitCell.h
//  yunejianDesigner
//
//  Created by Victor on 2017/12/20.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTableViewCellInfoModel.h"

@interface YYRegisterTableSubmitCell : UITableViewCell<UIScrollViewDelegate,UITextViewDelegate,UIWebViewDelegate> {
    CMAlertView *alert;
}

@property(nonatomic,weak)id<YYRegisterTableCellDelegate> delegate;
@property(nonatomic,copy)NSIndexPath * indexPath;
@property(nonatomic,copy) void (^block)(NSString *type);

-(void)updateCellInfo:(YYTableViewCellInfoModel *)info;

@end
