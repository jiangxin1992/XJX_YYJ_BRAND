//
//  YYForgetPasswordViewController.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYForgetPasswordViewController.h"

// 自定义视图
#import "YYNavView.h"
#import "YYStepViewCell.h"
#import "YYRegisterTableInputCell.h"
#import "YYRegisterTableEmailVerifyCell.h"

// 接口
#import "YYUserApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MBProgressHUD.h>
#import "MLInputDodger.h"
#import "YYTableViewCellData.h"
#import "YYTableViewCellInfoModel.h"

@interface YYForgetPasswordViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic, strong) NSArray *cellDataArrays;

@end

@implementation YYForgetPasswordViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self buildTableViewDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kYYPageForgetPasswordTypeEmailPasswordType];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kYYPageForgetPasswordTypeEmailPasswordType];
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
    
    self.navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"找回密码",nil) WithSuperView: self.view haveStatusView:YES];
    
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom).with.offset(0);
    }];
    self.tableView.backgroundColor = _define_white_color;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[YYRegisterTableInputCell class] forCellReuseIdentifier:NSStringFromClass([YYRegisterTableInputCell class])];
    [self.tableView registerClass:[YYRegisterTableEmailVerifyCell class] forCellReuseIdentifier:NSStringFromClass([YYRegisterTableEmailVerifyCell class])];
    self.tableView.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.tableView registerAsDodgeViewForMLInputDodger];
    
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 120)];
    self.tableFooterView.backgroundColor = _define_white_color;
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.backgroundColor = _define_black_color;
    [sendButton setTitle:NSLocalizedString(@"发送",nil) forState:UIControlStateNormal];
    [sendButton setTitleColor:_define_white_color forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:18];
    sendButton.layer.cornerRadius = 2.5;
    sendButton.layer.masksToBounds = YES;
    [sendButton addTarget:self action:@selector(submitApplication) forControlEvents:UIControlEventTouchUpInside];
    [self.tableFooterView addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    [self reloadUI];
}

- (void)reloadUI {
    if (self.viewType == kForgetPasswordType) {
        self.tableView.tableFooterView = self.tableFooterView;
    } else if (self.viewType == kEmailPasswordType) {
        self.tableView.tableFooterView = nil;
    }
}

#pragma mark - --------------请求数据----------------------
-(void)forgetPasswordWithParams:(NSString *)paramsStr{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    YYTableViewCellInfoModel *infoModel = ((YYTableViewCellData *)self.cellDataArrays[0][1]).object;
    __block NSString *blockEmailstr = infoModel.value;
    [YYUserApi forgetPassword:paramsStr andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if( rspStatusAndMessage.status == YYReqStatusCode100){
            self.viewType = kEmailPasswordType;
            self.userEmail = blockEmailstr;
            [self buildTableViewDataSource];
            [self reloadUI];
            [self.tableView reloadData];
        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}

#pragma mark - --------------系统代理----------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cellDataArrays count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *data = [self.cellDataArrays objectAtIndex:section];
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *data = [self.cellDataArrays objectAtIndex:indexPath.section];
    YYTableViewCellData *cellData = [data objectAtIndex:indexPath.row];
    if (cellData.type == RegisterTableCellStep) {
        YYStepViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYStepViewCell class])];
        if (!cell) {
            cell = [[YYStepViewCell alloc] initWithStepStyle:StepStyleThreeStep reuseIdentifier:NSStringFromClass([YYStepViewCell class])];
            cell.firtTitle = NSLocalizedString(@"输入邮箱",nil);
            cell.secondTitle = NSLocalizedString(@"查收邮件,安全验证",nil);
            cell.thirdTitle = NSLocalizedString(@"重设密码",nil);
        }
        cell.currentStep = [cellData.object integerValue];
        [cell updateUI];
        return cell;
    }
    if (cellData.type == RegisterTableCellTypeInput) {
        YYRegisterTableInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYRegisterTableInputCell class])];
        cell.isMust = YES;
        [cell updateCellInfo:cellData.object];
        return cell;
    }
    if(cellData.type == RegisterTableCellTypeEmailVerify){
        YYRegisterTableEmailVerifyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYRegisterTableEmailVerifyCell class])];
        [cell updateCellInfo:cellData.object];
        [cell setSubmitBlock:^{
            [self submitApplication];
        }];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *data = [self.cellDataArrays objectAtIndex:indexPath.section];
    YYTableViewCellData *cellData = [data objectAtIndex:indexPath.row];
    return cellData.tableViewCellRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *data = [self.cellDataArrays objectAtIndex:indexPath.section];
    YYTableViewCellData *cellData = [data objectAtIndex:indexPath.row];
    if (cellData.selectedCellBlock) {
        cellData.selectedCellBlock(indexPath);
    }
}

#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitApplication {
    NSArray *data = nil;
    YYTableViewCellData *cellData =nil;
    id values = nil;
    
    cellData = [data objectAtIndex:0];
    values = cellData.object;
    NSInteger total=[self.cellDataArrays count];
    NSInteger verifySection=0;
    NSInteger verifyRow=0;
    NSMutableArray *retailerNameArr = [[NSMutableArray alloc] init];
    NSMutableArray *paramsArr = [[NSMutableArray alloc] initWithCapacity:10];
    NSString *paramsStr = nil;
    for(;verifySection<total;verifySection++){
        data = [self.cellDataArrays objectAtIndex:verifySection];
        verifyRow = 0;
        for(YYTableViewCellData *cellData in data){
            if(cellData.object){
                if(cellData.type != RegisterTableCellTypeTitle && cellData.type !=  RegisterTableCellTypeSubmit){
                    if ([cellData.object isKindOfClass:[YYTableViewCellInfoModel class]]) {
                        YYTableViewCellInfoModel *model = cellData.object;
                        if(model.ismust > 0 && (model.value == nil || [model.value isEqualToString:@""] || ![model checkWarn]) ){
                            //[YYToast showToastWithTitle:[NSString stringWithFormat:@"完善%@信息",model.title] andDuration:kAlertToastDuration];
                            [YYToast showToastWithView:self.view title:[NSString stringWithFormat: NSLocalizedString(@"完善%@信息",nil),model.title] andDuration:kAlertToastDuration];
                            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:verifyRow inSection:verifySection];
                            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                            return;
                        }
                        if(model.ismust !=2 && ![model.value isEqualToString:@""]){
                            if(model.ismust == 3){
                                paramsStr = [model getParamStr];
                            }else{
                                
                                NSString *getstr = [model getParamStr];
                                if(![NSString isNilOrEmpty:getstr])
                                {
                                    if ([getstr containsString:@"retailerName"]) {
                                        NSArray *compArr = [getstr componentsSeparatedByString:@"="];
                                        if(compArr.count > 1)
                                        {
                                            [retailerNameArr addObject:compArr[1]];
                                        }
                                    }else
                                    {
                                        [paramsArr addObject:getstr];
                                    }
                                }
                            }
                        }
                    }
                }else if(cellData.type ==  RegisterTableCellTypeSubmit){
                    YYTableViewCellInfoModel *model = cellData.object;
                    if(model.ismust > 0&& ![model.value isEqualToString:@"checked"]){
                        [YYToast showToastWithView:self.view title: NSLocalizedString(@"请选择同意服务条款",nil) andDuration:kAlertToastDuration];
                        return;
                    }
                }
            }
            verifyRow ++;
        }
    }
    if(self.viewType == kForgetPasswordType){
        [self forgetPasswordWithParams:paramsStr];
    } else if (self.viewType == kEmailPasswordType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - --------------自定义方法----------------------
- (void)buildTableViewDataSource {
    NSMutableArray *arrays = [NSMutableArray array];
    if (self.viewType == kForgetPasswordType) {
        if (YES) {
            NSMutableArray *array = [NSMutableArray array];
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellStep;
                data.tableViewCellRowHeight = 82;
                data.object = @(0);
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"email";
                info.ismust = 3;
                info.title = NSLocalizedString(@"输入在YCO System登录时使用的Email",nil);
                info.tipStr = @"infoemail_icon";
                info.warnStr = NSLocalizedString(@"输入在YCO System登录时使用的Email",nil);
                info.keyboardType = UIKeyboardTypeEmailAddress;
                data.object = info;
                [array addObject:data];
            }
            [arrays addObject:array];
        }
    }
    if (self.viewType == kEmailPasswordType) {
        NSMutableArray *array = [NSMutableArray array];
        if (YES) {
            YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
            data.type = RegisterTableCellStep;
            data.tableViewCellRowHeight = 82;
            data.object = @(1);
            [array addObject:data];
        }
        if (YES) {
            YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
            data.type = RegisterTableCellTypeEmailVerify;
            data.tableViewCellRowHeight = 510;
            YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
            info.title = NSLocalizedString(@"已完成重置密码，去登录",nil);
            info.value = [NSString stringWithFormat:@"%d|%@",self.viewType,self.userEmail];
            data.object = info;
            [array addObject:data];
        }
        [arrays addObject:array];
    }
    self.cellDataArrays = arrays;
}

#pragma mark - --------------other----------------------
@end
