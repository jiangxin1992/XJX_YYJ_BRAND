//
//  YYSellerListViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/6/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYSellerListViewController.h"
#import "YYNavigationBarViewController.h"
#import "YYCreateOrModifySellerViewContorller.h"
#import "YYSubShowroomPowerViewContorller.h"

#import "YYUserApi.h"
#import "YYShowroomApi.h"
#import "YYSalesManListModel.h"
#import "YYSeller.h"
#import "YYSellerInfoCell.h"
#import "YYUser.h"

@interface YYSellerListViewController ()<UITableViewDataSource,UITableViewDelegate, MGSwipeTableCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,copy) NSArray *sellersArray;
@property(nonatomic,strong) YYCreateOrModifySellerViewContorller *createOrModifySellerViewContorller;
@property(nonatomic,strong)YYNavigationBarViewController *navigationBarViewController;
@property (nonatomic,assign) BOOL isShowroom;
@end

@implementation YYSellerListViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    if(!_isShowroom)
    {
        [self getSellList];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageSellerList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageSellerList];
}

#pragma mark - --------------SomePrepare--------------
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
-(void)PrepareData{
    YYUser *user = [YYUser currentUser];
    if(user.userType == 5)
    {
        _isShowroom = YES;
    }else
    {
        _isShowroom = NO;
    }
}

#pragma mark - --------------系统代理----------------------
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isShowroom)
    {
        if(_ShowroomModel)
        {
            return _ShowroomModel.subList.count;
        }
        return 0;
    }
    return [_sellersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"YYSellerInfoCell";
    YYSellerInfoCell *userInfoCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    userInfoCell.statusSwitch.hidden = YES;
    userInfoCell.tipLabel.hidden = YES;
    if ([YYCurrentNetworkSpace isNetwork]) {
        userInfoCell.statusSwitch.enabled = YES;
    }else{
        userInfoCell.statusSwitch.enabled = NO;
    }

    // 三方侧滑
    userInfoCell.accessoryType = UITableViewCellAccessoryNone;
    userInfoCell.delegate = self;
    userInfoCell.allowsMultipleSwipe = NO;
    userInfoCell.allowsButtonsWithDifferentWidth = YES;

    if(_isShowroom)
    {
        if (_ShowroomModel
            && [_ShowroomModel.subList count] > 0
            && row < [_ShowroomModel.subList count]) {

            YYShowRoomSubModel *subModel = [_ShowroomModel.subList objectAtIndex:row];
            userInfoCell.subModel = subModel;
            //            NORMAL正常/INIT未激活/STOP停用

            if([subModel.status isEqualToString:@"NORMAL"])
            {
                //正常
                userInfoCell.statusSwitch.hidden = NO;
                [userInfoCell.statusSwitch setOn: YES];
                [userInfoCell setLabelStatus:1.0];
            }else if([subModel.status isEqualToString:@"STOP"])
            {
                //停用
                userInfoCell.statusSwitch.hidden = NO;
                [userInfoCell.statusSwitch setOn: NO];
                [userInfoCell setLabelStatus:0.6];
            }else
            {
                userInfoCell.statusSwitch.hidden = YES;
                [userInfoCell setLabelStatus:0.6];
                userInfoCell.tipLabel.hidden = NO;
            }
            [userInfoCell updateUIWithShowType:0];

        }else{
            YYShowRoomSubModel *subModel = [[YYShowRoomSubModel alloc] init];
            subModel.name = NSLocalizedString(@"暂无Showroom子账号",nil);
            subModel.email = @"";
            userInfoCell.statusSwitch.hidden = YES;
            userInfoCell.subModel = subModel;
            [userInfoCell updateUIWithShowType:0];
            [userInfoCell setLabelStatus:0.6];
        }
    }else
    {
        if (_sellersArray
            && [_sellersArray count] > 0
            && row < [_sellersArray count]) {
            YYSeller *seller = [_sellersArray objectAtIndex:row];

            userInfoCell.statusSwitch.hidden = NO;
            userInfoCell.seller = seller;

            [userInfoCell updateUIWithShowType:0];

            BOOL isOn = (seller.status == 0);
            [userInfoCell.statusSwitch setOn: isOn];
            if(!isOn){
                [userInfoCell setLabelStatus:0.6];
            }else{
                [userInfoCell setLabelStatus:1.0];
            }
        }else{
            YYSeller *seller = [[YYSeller alloc] init];
            seller.name = NSLocalizedString(@"暂无销售代表",nil);
            seller.email = @"";
            userInfoCell.statusSwitch.hidden = YES;
            userInfoCell.seller = seller;
            [userInfoCell updateUIWithShowType:0];
            [userInfoCell setLabelStatus:0.6];
        }
    }

    WeakSelf(ws);

    [userInfoCell setSwitchClicked:^(NSNumber *salesmanId,BOOL isOn){
        if(salesmanId)
        {
            NSInteger status = -1;
            if (isOn) {
                status = 0;
            }else {
                status = 1;
            }
            if(_isShowroom)
            {
                [YYShowroomApi updateSubShowroomStatusWithId:[salesmanId integerValue] status:status andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                    if (rspStatusAndMessage.status == kCode100) {
                        [YYToast showToastWithTitle:NSLocalizedString(@"操作成功！",nil) andDuration:kAlertToastDuration];

                    }else{
                        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                    }
                    if(_modifySuccess){
                        _modifySuccess();
                    }
                }];
            }else
            {
                [YYUserApi updateSalesmanStatusWithId:[salesmanId integerValue] status:status andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                    if (rspStatusAndMessage.status == kCode100) {
                        [YYToast showToastWithTitle:NSLocalizedString(@"操作成功！",nil) andDuration:kAlertToastDuration];

                    }else{
                        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                    }
                    [ws getSellList];
                }];
            }
        }
    }];
    return userInfoCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - --------------自定义代理/block----------------------
#pragma mark - 侧滑


/**
 delete.backgroundColor = [UIColor colorWithHex:@"EF4E31"];
 update.backgroundColor = [UIColor colorWithHex:@"D3D3D3"];
 */

- (NSArray<UIView *> *)swipeTableCell:(MGSwipeTableCell *)cell swipeButtonsForDirection:(MGSwipeDirection)direction swipeSettings:(MGSwipeSettings *)swipeSettings expansionSettings:(MGSwipeExpansionSettings *)expansionSettings{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSArray * result = @[];
    // 右边显示
    if (direction == MGSwipeDirectionRightToLeft) {
        swipeSettings.transition = MGSwipeTransitionStatic;
        expansionSettings.fillOnTrigger = NO;
        // 删除按钮
        MGSwipeButton *delete = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"删除", nil) backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell * sender){
            YYShowRoomSubModel *subModel = [_ShowroomModel.subList objectAtIndex:indexPath.row];

            [YYShowroomApi deleteNotActiveSubShowroomUserId:subModel.showroomUserId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                //
                if (rspStatusAndMessage.status == kCode100) {
                    [YYToast showToastWithTitle:NSLocalizedString(@"操作成功！",nil) andDuration:kAlertToastDuration];
                    // 先删除数据源，再删除cell
                    [_ShowroomModel.subList removeObject:subModel];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];

                }else{
                    [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                }
            }];
            return YES;
        }];
        // 基本样式
        delete.buttonWidth = 67;
        delete.titleLabel.font = [UIFont systemFontOfSize:17];
        delete.backgroundColor = [UIColor colorWithHex:@"EF4E31"];

        // 修改权限按钮
        MGSwipeButton *update = [MGSwipeButton buttonWithTitle:NSLocalizedString(@"修改权限", nil) backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell * sender){
            YYShowRoomSubModel *subModel = [_ShowroomModel.subList objectAtIndex:indexPath.row];
            [YYShowroomApi selectSubShowroomPowerUserId:subModel.showroomUserId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSArray *powerArray, NSError *error) {
                //
                if (rspStatusAndMessage.status == kCode100) {
                    // 先删除数据源，再删除cell
                    YYSubShowroomPowerViewContorller *subRoom = [[YYSubShowroomPowerViewContorller alloc] init];
                    subRoom.userId = subModel.showroomUserId;
                    subRoom.defaultPowerArray = powerArray;
                    subRoom.modifySuccess = ^{

                    };
                    [self.navigationController pushViewController:subRoom animated:YES];

                }else{
                    [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                }
            }];
            return YES;
        }];
        // 基本样式
        update.buttonWidth = 101;
        update.titleLabel.font = [UIFont systemFontOfSize:17];
        update.backgroundColor = [UIColor colorWithHex:@"D3D3D3"];

        if(_isShowroom){
            NSInteger row = indexPath.row;
            if (_ShowroomModel && [_ShowroomModel.subList count] > 0 && row < [_ShowroomModel.subList count]) {

                YYShowRoomSubModel *subModel = [_ShowroomModel.subList objectAtIndex:row];
                //            NORMAL正常/INIT未激活/STOP停用

                if([subModel.status isEqualToString:@"NORMAL"]){
                    //正常
                    result = @[update];
                }else if([subModel.status isEqualToString:@"STOP"]){
                    //停用
                    result = @[update];
                }else{
                    // 未激活
                    result = @[delete, update];
                }
            }
        }
    }
    return result;
}

#pragma mark - --------------自定义响应----------------------

- (IBAction)createSeller:(id)sender {

    WeakSelf(ws);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYCreateOrModifySellerViewContorller *createOrModifySellerViewContorller = [storyboard instantiateViewControllerWithIdentifier:@"YYCreateOrModifySellerViewContorller"];
    self.createOrModifySellerViewContorller = createOrModifySellerViewContorller;

    [self.navigationController pushViewController:createOrModifySellerViewContorller animated:YES];
    [createOrModifySellerViewContorller setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
    }];

    [createOrModifySellerViewContorller setModifySuccess:^(NSNumber *userId){
        // [ws.navigationController popViewControllerAnimated:YES];
        if(_isShowroom)
        {
            YYSubShowroomPowerViewContorller *subRoom = [[YYSubShowroomPowerViewContorller alloc] init];
            subRoom.userId = userId;
            subRoom.modifySuccess = ^{

            };

            [self.navigationController pushViewController:subRoom animated:YES];

            if(_modifySuccess){
                _modifySuccess();
            }
        }else
        {
            [ws getSellList];
        }
    }];
}

#pragma mark - --------------自定义方法----------------------
#pragma mark - getSellList
- (void)getSellList{
    WeakSelf(ws);
    [YYUserApi getSalesManListWithBlockNew:^(YYRspStatusAndMessage *rspStatusAndMessage, YYSalesManListModel *salesManListModel, NSError *error) {
        if (salesManListModel) {
            [salesManListModel getTrueSalesMainList];
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            for (YYSalesManModel *salesManModel in salesManListModel.result) {
                YYSeller *seller = [[YYSeller alloc] init];
                seller.salesmanId = [salesManModel.userId intValue];
                seller.name = salesManModel.username;
                seller.email = salesManModel.email;
                seller.status = [salesManModel.status intValue];
                [array addObject:seller];
            }

            ws.sellersArray = [NSArray arrayWithArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws.tableView reloadData];
            });
        }
    }];
}

#pragma mark - SomeAction
-(void)setShowroomModel:(YYShowroomInfoModel *)ShowroomModel
{
    _ShowroomModel = ShowroomModel;
    [_tableView reloadData];
}

#pragma mark - --------------UI----------------------
-(void)PrepareUI{
    YYUser *user = [YYUser currentUser];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    self.navigationBarViewController = navigationBarViewController;
    if(user.userType ==5)
    {
        navigationBarViewController.nowTitle = NSLocalizedString(@"Showroom子账号",nil);
    }else
    {
        navigationBarViewController.nowTitle = NSLocalizedString(@"销售代表",nil);
    }
    
    [_containerView insertSubview:navigationBarViewController.view atIndex:0];
    //[_containerView addSubview:navigationBarViewController.view];
    __weak UIView *_weakContainerView = _containerView;
    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakContainerView.mas_top);
        make.left.equalTo(_weakContainerView.mas_left);
        make.bottom.equalTo(_weakContainerView.mas_bottom);
        make.right.equalTo(_weakContainerView.mas_right);
    }];
    
    WeakSelf(ws);
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            if(ws.cancelButtonClicked){
                ws.cancelButtonClicked();
            }
        }
    }];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }

}

#pragma mark - --------------other----------------------

@end
