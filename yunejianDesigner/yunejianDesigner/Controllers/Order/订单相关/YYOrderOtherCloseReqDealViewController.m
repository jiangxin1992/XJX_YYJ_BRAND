//
//  YYOrderOtherCloseReqDealViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/4/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderOtherCloseReqDealViewController.h"

#import "YYNavigationBarViewController.h"

#import "YYOrderOtherCloseReqCell.h"

@interface YYOrderOtherCloseReqDealViewController ()<YYTableCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YYOrderOtherCloseReqDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = NSLocalizedString(@"处理订单",nil);
    [_containerView insertSubview:navigationBarViewController.view atIndex:0];
    __weak UIView *_weakContainerView = _containerView;
    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakContainerView.mas_top);
        make.left.equalTo(_weakContainerView.mas_left);
        make.bottom.equalTo(_weakContainerView.mas_bottom);
        make.right.equalTo(_weakContainerView.mas_right);
    }];
    WeakSelf(ws);
    __block YYNavigationBarViewController *blockVc = navigationBarViewController;
    
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            if(ws.cancelButtonClicked){
                ws.cancelButtonClicked();
            }
            blockVc = nil;
        }
    }];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"YYOrderOtherCloseReqCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YYOrderOtherCloseReqCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - myTableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 365;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYOrderOtherCloseReqCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"YYOrderOtherCloseReqCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell updateUI];
    return cell;
}

-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    if(self.reqDealButtonClicked){
        self.reqDealButtonClicked(parmas);
    }
}
@end
