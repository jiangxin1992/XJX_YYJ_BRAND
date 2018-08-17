//
//  YYPayLogViewController.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/23.
//  Copyright © 2017年 Apple. All rights reserved.
//
// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYPayLogViewController.h"

// 自定义视图
#import "YYNavView.h"
#import "YYStepViewCell.h"
#import "YYPayLogTableViewCell.h"

// 接口
#import "YYOrderApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MBProgressHUD.h>
#import "MLInputDodger.h"
#import "YYTableViewCellData.h"
#import "YYTableViewCellInfoModel.h"
#import "YYStepInfoModel.h"

@interface YYPayLogViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *cellDataArray;

@end

@implementation YYPayLogViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self buildTableViewDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kYYPagePayLogRegisterType];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kYYPagePayLogRegisterType];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

- (void)PrepareData{}

- (void)PrepareUI{
    self.view.backgroundColor = _define_white_color;
    
    self.navView = [[YYNavView alloc] initWithTitle:[self.noteModel.payType integerValue] == 0 ? NSLocalizedString(@"线下收款记录",nil) : NSLocalizedString(@"线上收款记录",nil) WithSuperView: self.view haveStatusView:YES];
    
    UIButton *backBtn = [UIButton getCustomImgBtnWithImageStr:@"goBack_normal" WithSelectedImageStr:nil];
    [self.navView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.bottom.mas_equalTo(-1);
    }];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[YYPayLogTableViewCell class] forCellReuseIdentifier:NSStringFromClass([YYPayLogTableViewCell class])];
    self.tableView.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.tableView registerAsDodgeViewForMLInputDodger];
}

#pragma mark - --------------请求数据----------------------
- (void)confirmPayment {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [YYOrderApi confirmPayment:[self.noteModel.id integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if(rspStatusAndMessage.status == kCode100){
            if(self.affirmRecordBlock){
                self.affirmRecordBlock();
            }
        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}

- (void)discardPayment {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [YYOrderApi discardPayment:[self.noteModel.id integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if(rspStatusAndMessage.status == kCode100){
            if(self.cancelRecordBlock){
                self.cancelRecordBlock();
            }
        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}

- (void)deletePayment {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [YYOrderApi deletePayment:[self.noteModel.id integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if(rspStatusAndMessage.status == kCode100){
            if(self.deleteRecordBlock){
                self.deleteRecordBlock();
            }
        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}

#pragma mark - --------------系统代理----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYTableViewCellData *cellData = [self.cellDataArray objectAtIndex:indexPath.row];
    if (cellData.type == RegisterTableCellStep) {
        YYStepInfoModel *info = cellData.object;
        YYStepViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYStepViewCell class])];
        if (!cell) {
            cell = [[YYStepViewCell alloc] initWithStepStyle:StepStyleThreeStep reuseIdentifier:NSStringFromClass([YYStepViewCell class])];
        }
        cell.firtTitle = info.firtTitle;
        cell.secondTitle = info.secondTitle;
        cell.thirdTitle = info.thirdTitle;
        cell.currentStep = info.currentStep;
        [cell updateUI];
        return cell;
    }
    if (cellData.type == RegisterTableCellTypePayType) {
        YYPayLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYPayLogTableViewCell class])];
        [cell setAffirmRecordBlock:^{
            CMAlertView *alertView =nil;
            alertView = [[CMAlertView alloc] initWithTitle: NSLocalizedString(@"确认货款已到账？",nil) message: NSLocalizedString(@"确认后，到账状态不可修改",nil) needwarn:NO delegate:nil cancelButtonTitle: NSLocalizedString(@"还未收到",nil) otherButtonTitles:@[[NSString stringWithFormat:@"%@|000000",NSLocalizedString(@"确认到账",nil)]]];
            alertView.specialParentView = self.view;
            [alertView setAlertViewBlock:^(NSInteger selectedIndex) {
                if (selectedIndex == 1) {
                    [self confirmPayment];
                }
            }];
            [alertView show];
        }];
        [cell setCancelRecordBlock:^{
            [self discardPayment];
        }];
        [cell setDeleteRecordBlock:^{
            [self deletePayment];
        }];
        [cell updateCellInfo:self.noteModel];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYTableViewCellData *cellData = [self.cellDataArray objectAtIndex:indexPath.row];
    return cellData.tableViewCellRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YYTableViewCellData *cellData = [self.cellDataArray objectAtIndex:indexPath.row];
    if (cellData.selectedCellBlock) {
        cellData.selectedCellBlock(indexPath);
    }
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - --------------自定义方法----------------------
- (void)buildTableViewDataSource {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (self.noteModel) {
        if ([self.noteModel.payType integerValue] == 0) {
            if ([self.noteModel.payStatus integerValue] == 0) {
                if (YES) {
                    YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                    data.type = RegisterTableCellStep;
                    data.tableViewCellRowHeight = 82;
                    YYStepInfoModel *info = [[YYStepInfoModel alloc] init];
                    info.stepStyle = StepStyleThreeStep;
                    info.firtTitle = NSLocalizedString(@"添加收款记录_register",nil);
                    info.secondTitle = NSLocalizedString(@"货款待确认_register",nil);
                    info.thirdTitle = NSLocalizedString(@"成功到账_register",nil);
                    info.currentStep = 1;
                    data.object = info;
                    [array addObject:data];
                }
                if (YES) {
                    YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                    data.type = RegisterTableCellTypePayType;
                    data.tableViewCellRowHeight = 280;
                    [array addObject:data];
                }
            } else if ([_noteModel.payStatus integerValue] == 2) {
                if (YES) {
                    YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                    data.type = RegisterTableCellStep;
                    data.tableViewCellRowHeight = 82;
                    YYStepInfoModel *info = [[YYStepInfoModel alloc] init];
                    info.stepStyle = StepStyleThreeStep;
                    info.firtTitle = NSLocalizedString(@"添加收款记录_register",nil);
                    info.secondTitle = NSLocalizedString(@"货款待确认_register",nil);
                    info.thirdTitle = NSLocalizedString(@"已作废_register",nil);
                    info.currentStep = 2;
                    data.object = info;
                    [array addObject:data];
                }
                if (YES) {
                    YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                    data.type = RegisterTableCellTypePayType;
                    data.tableViewCellRowHeight = 280;
                    [array addObject:data];
                }
            } else {
                if (YES) {
                    YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                    data.type = RegisterTableCellStep;
                    data.tableViewCellRowHeight = 82;
                    YYStepInfoModel *info = [[YYStepInfoModel alloc] init];
                    info.stepStyle = StepStyleThreeStep;
                    info.firtTitle = NSLocalizedString(@"添加收款记录_register",nil);
                    info.secondTitle = NSLocalizedString(@"货款待确认_register",nil);
                    info.thirdTitle = NSLocalizedString(@"成功到账_register",nil);
                    info.currentStep = 2;
                    data.object = info;
                    [array addObject:data];
                }
                if (YES) {
                    YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                    data.type = RegisterTableCellTypePayType;
                    data.tableViewCellRowHeight = 280;
                    [array addObject:data];
                }
            }
        } else if ([self.noteModel.payType integerValue] == 1) {
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellStep;
                data.tableViewCellRowHeight = 82;
                YYStepInfoModel *info = [[YYStepInfoModel alloc] init];
                info.stepStyle = StepStyleThreeStep;
                info.firtTitle = NSLocalizedString(@"收款_register",nil);
                info.secondTitle = NSLocalizedString(@"货款审核中_register",nil);
                info.thirdTitle = NSLocalizedString(@"成功到账_register",nil);
                info.currentStep = self.noteModel.onlinePayDetail.accountTime ? 2 : 1;
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypePayType;
                data.tableViewCellRowHeight = 280;
                [array addObject:data];
            }
        }
    }
    self.cellDataArray = array;
}

#pragma mark - --------------other----------------------

@end
