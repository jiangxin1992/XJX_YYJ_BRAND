//
//  YYOrderAddressListController.h
//  Yunejian
//
//  Created by Apple on 15/10/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYBuyerListModel.h"
typedef void (^MakeSureButtonClicked)(NSString *name,YYBuyerModel *infoMode);

@interface YYOrderAddressListController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textNameInput;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;
@property(nonatomic,strong) CancelButtonClicked cancelButtonClicked;
@property(nonatomic,strong) MakeSureButtonClicked makeSureButtonClicked;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTopConstraints;
@property (nonatomic,strong) YYBuyerModel *buyerModel;
@property (nonatomic,strong) YYBuyerListModel *buyerList;
@property (nonatomic,assign) NSInteger needUnDefineBuyer;
//- (IBAction)closeHandler:(id)sender;
//- (IBAction)makeSureHandler:(id)sender;
@end
