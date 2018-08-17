//
//  YYOrderAddressListController.h
//  Yunejian
//
//  Created by Apple on 15/10/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYBuyerListModel,YYBuyerModel;

typedef void (^MakeSureButtonClicked)(NSString *name,YYBuyerModel *infoMode);

@interface YYOrderAddressListController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textNameInput;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(nonatomic,strong) CancelButtonClicked cancelButtonClicked;
@property(nonatomic,strong) MakeSureButtonClicked makeSureButtonClicked;

@property (nonatomic,strong) YYBuyerModel *buyerModel;
@property (nonatomic,strong) YYBuyerListModel *buyerList;
@property (nonatomic,assign) NSInteger needUnDefineBuyer;

@end
