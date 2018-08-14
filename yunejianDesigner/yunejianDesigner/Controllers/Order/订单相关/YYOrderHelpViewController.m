//
//  YYOrderHelpViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/4/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderHelpViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"

// 自定义视图
#import "YYOrderHelpTitleCell.h"
#import "YYOrderHelpTextCell.h"
#import "YYOrderHelpNumTextCell.h"

// 接口

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

typedef NS_ENUM(NSInteger, HelpTableCellType) {
    HelpTableCellTypeTitle = 1,
    HelpTableCellTypeText = 2,
    HelpTableCellTypeNumText = 3
};

@interface YYOrderHelpViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YYOrderHelpViewController{
    NSMutableArray *helpInfoData;
}
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageOrderHelp];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOrderHelp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{
    helpInfoData = [[NSMutableArray alloc] init];

    helpInfoData[0] = @[@[@(HelpTableCellTypeTitle),NSLocalizedString(@"1、订单有多少状态？状态之间是如何切换的？",nil)],
                        @[@(HelpTableCellTypeText),NSLocalizedString(@"正常的订单共有5种状态：已下单、已确认、已生产、已发货、已收货。其中确认订单需要设计师和买手店同时确认；确认收货由买手店点击操作，其他订单状态的切换只能由设计师操作完成。",nil),@"10"],
                        @[@(HelpTableCellTypeNumText),NSLocalizedString(@"1|已下单",nil),NSLocalizedString(@"订单创建之后处于”已下单”状态，此时双方都可以对订单进行“取消”、“修改”操作；",nil),@"10"],
                        @[@(HelpTableCellTypeNumText),NSLocalizedString(@"2|已确认",nil),NSLocalizedString(@"一方操作确认订单后，另一方可以“确认”，也可以“拒绝确认”，只有当双方同时确认订单，该订单状态才会变更为“已确认”；已确认的订单不能修改，可以取消订单，取消订单需要对方同意；",nil),@"10"],
                        @[@(HelpTableCellTypeNumText),NSLocalizedString(@"3|已生产",nil),NSLocalizedString(@"当设计师生产完毕后，点击已生产，订单进入“已生产”状态；",nil),@"10"],
                        @[@(HelpTableCellTypeNumText),NSLocalizedString(@"4|发货中",nil),NSLocalizedString(@"当设计师安排发货时。点击发货中，创建装箱单并填写发货的商品，输入物流单号，点击发货。进入“发货中“的状态；",nil),@"10"],
                        @[@(HelpTableCellTypeNumText),NSLocalizedString(@"5|已发货",nil),NSLocalizedString(@"当设计师点击“已发货”后，订单进入“已发货”状态，等待买手店确认收货。若买手店未操作，订单将在15天后自动确认收货；",nil),@"10"],
                        @[@(HelpTableCellTypeNumText),NSLocalizedString(@"6|已收货",nil),NSLocalizedString(@"当买手店点击“已收货”按钮，或15天之后，订单进入“已收货”状态，订单完成；",nil),@"17"]
                        ];
    helpInfoData[1] = @[@[@(HelpTableCellTypeTitle),NSLocalizedString(@"2、订单确认以后，订单出现问题或纠纷需要取消怎么办？",nil)],
                        @[@(HelpTableCellTypeText),NSLocalizedString(@"订单确认后，订单出现问题或纠纷，一方可以取消订单，另一方可以在订单列表中看到等待处理的订单。经过协商，申请方此时可以撤销取消订单申请，则订单恢复到之前的状态；若被申请方同意了取消申请，则订单变为“交易取消”；若被申请方单方面选择交易继续，则申请方的订单取消，被申请方的订单依然继续；",nil),@"15"]
                        ];

    helpInfoData[2] = @[@[@(HelpTableCellTypeTitle),NSLocalizedString(@"3、如何修改订单？",nil)],
                        @[@(HelpTableCellTypeText),NSLocalizedString(@"只有当订单处于“已下单”状态下时，双方才可以对订单进行修改操作。在订单的详情页，点击页面右上角的“更多”按钮，点击“修改订单”就能对订单进行修改；",nil),@"15"]
                        ];

    helpInfoData[3] = @[@[@(HelpTableCellTypeTitle),NSLocalizedString(@"4、为什么“取消订单”后需要对方同意？",nil)],
                        @[@(HelpTableCellTypeText),NSLocalizedString(@"当订单处于“已下单”状态下时，双方可以直接操作“取消订单”，不需要对方同意，订单直接可以被取消；当订单处于“已确认”、“已生产”、“已发货”状态时，一方操作“取消订单”，此时（1）撤销申请，则订单回复；（2）若对方同意取消，则订单变更为“交易取消” (3)若对方拒绝，则申请方交易取消，对方继续；",nil),@"15"]
                        ];
}
- (void)PrepareUI{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(17, 0, 0, 0);
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self createNavigationBarView];
}
-(void)createNavigationBarView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";

    navigationBarViewController.nowTitle = NSLocalizedString(@"如何理解订单状态",nil);

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
}
#pragma mark - --------------系统代理----------------------
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [helpInfoData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *oneHelpData = [helpInfoData objectAtIndex:section];
    return [oneHelpData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *oneHelpData = [helpInfoData objectAtIndex:indexPath.section];
    NSArray *infoArr = [oneHelpData objectAtIndex:indexPath.row];
    NSInteger type = [[infoArr objectAtIndex:0] integerValue];
    if(type == HelpTableCellTypeTitle){
        return [YYOrderHelpTitleCell heightCell:infoArr];
    }else if(type == HelpTableCellTypeText){
        return [YYOrderHelpTextCell heightCell:infoArr];
    }else if(type == HelpTableCellTypeNumText){
        return [YYOrderHelpNumTextCell heightCell:infoArr];
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 17;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *oneHelpData = [helpInfoData objectAtIndex:indexPath.section];
    NSArray *infoArr = [oneHelpData objectAtIndex:indexPath.row];
    NSInteger type = [[infoArr objectAtIndex:0] integerValue];
    if(type == HelpTableCellTypeTitle){
        static NSString *CellIdentifier = @"YYOrderHelpTitleCell";
        YYOrderHelpTitleCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell1 updateCellInfo:infoArr];
        return cell1;
    }else if(type == HelpTableCellTypeText){
        static NSString *CellIdentifier = @"YYOrderHelpTextCell";
        YYOrderHelpTextCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell2 updateCellInfo:infoArr];
        return cell2;
    }else if(type == HelpTableCellTypeNumText){
        static NSString *CellIdentifier = @"YYOrderHelpNumTextCell";
        YYOrderHelpNumTextCell *cell3 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [cell3 updateCellInfo:infoArr];
        cell3.topLineView.hidden = NO;
        cell3.bottomLineView.hidden = NO;
        if(indexPath.row == 2){
            cell3.topLineView.hidden = YES;
        }else if(indexPath.row == ([oneHelpData count]-1)){
            cell3.bottomLineView.hidden = YES;
        }
        return cell3;
    }

    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
