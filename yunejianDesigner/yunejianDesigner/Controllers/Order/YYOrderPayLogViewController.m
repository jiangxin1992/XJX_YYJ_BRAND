//
//  YYOrderPayLogViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/7/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderPayLogViewController.h"

// c文件 —> 系统文件（c文件在前）
#import "YYNavigationBarViewController.h"
#import "YYRegisterViewController.h"

// 控制器

// 自定义视图
#import "YYOrderPayLogViewCell.h"

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYUser.h"
#import "YYPaymentNoteListModel.h"
#import "YYPayLogViewController.h"

@interface YYOrderPayLogViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray* reversedArray;
@property (weak, nonatomic) IBOutlet UILabel *giveMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *giveMoneyRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastMoneyRateLabel;
@property (nonatomic,assign)double totalMoney;
@property (nonatomic,assign)double hasGiveMoney;
@property (nonatomic,assign)NSInteger hasGiveRate;

@end

@implementation YYOrderPayLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    if(_currentYYOrderInfoModel != nil){
        [self loadPaymentNoteList:_currentYYOrderInfoModel.orderCode];
    }
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

-(void)loadPaymentNoteList:(NSString *)orderCode{
    WeakSelf(ws);
    __block NSString *blockOrderCode = orderCode;
    [YYOrderApi getPaymentNoteList:orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYPaymentNoteListModel *paymentNoteList, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            ws.reversedArray = paymentNoteList.result;
        }else{
            ws.reversedArray = nil;
        }
        [ws updateUI];
        [ws.tableView reloadData];
    }];
}

-(void)updateUI{
    double totalAmount=0;
     _hasGiveRate=0;
    if(_reversedArray){
        for (YYPaymentNoteModel *noteModel in _reversedArray) {
            if([noteModel.payType integerValue] == 0 && ([noteModel.payStatus integerValue] == 0 || [noteModel.payStatus integerValue] == 2)){
                
            }else{
                totalAmount += [noteModel.amount doubleValue];
                _hasGiveRate += [noteModel.percent integerValue];
            }
        }
    }
    NSInteger _moneyType = [_currentYYOrderInfoModel.curType integerValue];
    _hasGiveMoney = totalAmount;
    _totalMoney = [_currentYYOrderInfoModel.finalTotalPrice doubleValue];
    NSInteger hasGiveRate = [self getHasGiveRate];
    
    _giveMoneyRateLabel.text = [NSString stringWithFormat:@"%ld%@",(long)hasGiveRate,@"%"];
    _lastMoneyRateLabel.text = [NSString stringWithFormat:@"%ld%@",(long)(MAX(0,100-hasGiveRate)),@"%"];
    
    _giveMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",_hasGiveMoney],_moneyType);
    _lastMoneyLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%.2f",MAX(0,_totalMoney-_hasGiveMoney)],_moneyType);

}

-(NSInteger) getHasGiveRate{
    return _hasGiveRate;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_reversedArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 81;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *CellIdentifier = @"YYOrderPayLogViewCell";
    YYOrderPayLogViewCell *cell = (YYOrderPayLogViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[YYOrderPayLogViewCell alloc] init];
        cell.backgroundColor = [UIColor redColor];
    }

    YYPaymentNoteModel *noteModel = [_reversedArray objectAtIndex:([_reversedArray count]-indexPath.row-1)];
    cell.noteModel = noteModel;
    [cell updateUI];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    YYPaymentNoteModel *noteModel = [_reversedArray objectAtIndex:([_reversedArray count]-indexPath.row-1)];
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

@end
