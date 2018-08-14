//
//  YYShowroomBrandListCell.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYShowroomBrandModel.h"

@interface YYShowroomBrandListCell : UITableViewCell

@property (nonatomic ,strong)YYShowroomBrandModel *brandModel;

-(void)bottomIsHide:(BOOL )ishide;
@end
