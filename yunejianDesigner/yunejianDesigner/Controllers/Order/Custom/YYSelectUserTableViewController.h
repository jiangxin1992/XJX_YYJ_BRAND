//
//  YYSelectUserTableViewController.h
//  Yunejian
//
//  Created by yyj on 15/8/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSalesManListModel.h"
typedef void (^SelectedTowValue)(NSInteger userId,NSString *username);


@interface YYSelectUserTableViewController : UITableViewController

@property(nonatomic,assign) NSInteger currentUserId;
@property(nonatomic,strong) NSString *currentUserName;
@property(nonatomic,strong) YYSalesManListModel *salesManListModel;
@property(nonatomic,strong) SelectedTowValue selectedTowValue;

@end
