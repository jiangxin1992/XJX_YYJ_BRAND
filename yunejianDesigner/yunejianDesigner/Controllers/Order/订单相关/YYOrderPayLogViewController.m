//
//  YYOrderPayLogViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/7/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderPayLogViewController.h"

// c文件 —> 系统文件（c文件在前）
#import "YYPayLogViewController.h"
#import "YYNavigationBarViewController.h"

// 控制器

// 自定义视图
#import "YYOrderPayLogViewCell.h"

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYOrderInfoModel.h"
#import "YYPaymentNoteListModel.h"

@interface YYOrderPayLogViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightLayout;

@property (weak, nonatomic) IBOutlet UILabel *giveMoneyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *giveMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *lastMoneyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMoneyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMoneyLabel;

@property (nonatomic, strong) YYPaymentNoteListModel *paymentNoteList;

@property (nonatomic, assign) double totalMoney;

@end

@implementation YYOrderPayLogViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
//    [self UIConfig];
    [self RequestData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageOrderPayLog];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOrderPayLog];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare {
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData {}
- (void)PrepareUI {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = NSLocalizedString(@"收款记录",nil);
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

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

//#pragma mark - --------------UIConfig----------------------
//- (void)UIConfig {
//
//}

#pragma mark - --------------请求数据----------------------
- (void)RequestData {
    if(_currentYYOrderInfoModel != nil){
        [self loadPaymentNoteList:_currentYYOrderInfoModel.orderCode];
    }
}
-(void)loadPaymentNoteList:(NSString *)orderCode{
    WeakSelf(ws);
    [YYOrderApi getPaymentNoteList:orderCode finalTotalPrice:[_currentYYOrderInfoModel.finalTotalPrice doubleValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYPaymentNoteListModel *paymentNoteList, NSError *error) {
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            ws.paymentNoteList = paymentNoteList;
        }
        [ws updateUI];
        [ws.tableView reloadData];
    }];
}
#pragma mark - --------------系统代理----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!_paymentNoteList || [NSArray isNilOrEmpty:_paymentNoteList.result]){
        return 0;
    }
    return [_paymentNoteList.result count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_paymentNoteList || [NSArray isNilOrEmpty:_paymentNoteList.result]){
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }


    NSString *CellIdentifier = @"YYOrderPayLogViewCell";
    YYOrderPayLogViewCell *cell = (YYOrderPayLogViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[YYOrderPayLogViewCell alloc] init];
        cell.backgroundColor = [UIColor redColor];
    }

    YYPaymentNoteModel *noteModel = [_paymentNoteList.result objectAtIndex:([_paymentNoteList.result count]-indexPath.row-1)];
    cell.noteModel = noteModel;
    [cell updateUI];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(!_paymentNoteList || [NSArray isNilOrEmpty:_paymentNoteList.result]){
        return;
    }

    YYPaymentNoteModel *noteModel = [_paymentNoteList.result objectAtIndex:([_paymentNoteList.result count]-indexPath.row-1)];
    if([noteModel.payType integerValue]== 0){//线下付款 编辑
        YYPayLogViewController *viewController = [[YYPayLogViewController alloc] init];
        viewController.noteModel = noteModel;
        [viewController setAffirmRecordBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
            if(self.currentYYOrderInfoModel != nil){
                [self loadPaymentNoteList:self.currentYYOrderInfoModel.orderCode];
            }
        }];
        [viewController setCancelRecordBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
            if(self.currentYYOrderInfoModel != nil){
                [self loadPaymentNoteList:self.currentYYOrderInfoModel.orderCode];
            }
        }];
        [viewController setDeleteRecordBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
            if(self.currentYYOrderInfoModel != nil){
                [self loadPaymentNoteList:self.currentYYOrderInfoModel.orderCode];
            }
        }];
        [self.navigationController pushViewController:viewController animated:YES];
    }else{//线上付款 详情
        YYPayLogViewController *viewController = [[YYPayLogViewController alloc] init];
        viewController.noteModel = noteModel;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------
-(void)updateUI{
    NSInteger _moneyType = [_currentYYOrderInfoModel.curType integerValue];
    _totalMoney = [_currentYYOrderInfoModel.finalTotalPrice doubleValue];

    if([_paymentNoteList.hasGiveRate floatValue] > 100){
        _lastMoneyTitleLabel.hidden = YES;
        _lastMoneyRateLabel.hidden = YES;
        _lastMoneyLabel.hidden = YES;
        _headViewHeightLayout.constant = 67;
    }else{
        _lastMoneyTitleLabel.hidden = NO;
        _lastMoneyRateLabel.hidden = NO;
        _lastMoneyLabel.hidden = NO;
        _headViewHeightLayout.constant = 100;
        _lastMoneyRateLabel.text = [NSString stringWithFormat:@"%.2lf%@",(MAX(0,100-[_paymentNoteList.hasGiveRate floatValue])),@"%"];
        _lastMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",MAX(0,_totalMoney-[_paymentNoteList.hasGiveMoney doubleValue])],_moneyType);
    }
    _giveMoneyRateLabel.text = [NSString stringWithFormat:@"%.2lf%@",[_paymentNoteList.hasGiveRate floatValue],@"%"];

    _giveMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",[_paymentNoteList.hasGiveMoney doubleValue]],_moneyType);

}

#pragma mark - --------------other----------------------


@end
