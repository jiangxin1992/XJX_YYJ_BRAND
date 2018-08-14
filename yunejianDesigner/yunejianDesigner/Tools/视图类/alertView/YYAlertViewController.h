//
//  YYAlertViewController.h
//  Yunejian
//
//  Created by Apple on 15/11/9.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYAlertViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeightConstraints;//231
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutWidthConstraints;//620
@property (nonatomic,strong) SelectedValue cancelButtonClicked;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTopConstraints;//270
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)btnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
- (IBAction)closeHandler:(id)sender;
@property(nonatomic)        NSTextAlignment    textAlignment; 
@property(nonatomic,strong) NSString *titelStr;
@property(nonatomic,strong) NSString *msgStr;
@property(nonatomic,strong) NSString *btnStr;
@property(nonatomic,assign) BOOL needCloseBtn;
@property(nonatomic,assign) NSInteger widthConstraintsValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ttitleSpaceLayoutConstraint;
@end
