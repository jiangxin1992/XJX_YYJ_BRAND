//
//  YYRegisterViewController.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/18.
//  Copyright © 2017年 Apple. All rights reserved.
//

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYRegisterViewController.h"
#import "YYNavView.h"

// 自定义视图
#import "YYPickView.h"
#import "YYStepViewCell.h"
#import "YYRegisterTableTitleCell.h"
#import "YYRegisterTableInputCell.h"
#import "YYRegisterTableSubmitCell.h"
#import "YYProtocolViewController.h"
#import "YYRegisterTableEmailVerifyCell.h"

// 接口
#import "YYUserApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MBProgressHUD.h>
#import "MLInputDodger.h"
#import "YYTableViewCellData.h"
#import "YYTableViewCellInfoModel.h"
#import "Header.h"
#import "YYYellowPanelManage.h"

@interface YYRegisterViewController () <UITableViewDataSource, UITableViewDelegate, YYRegisterTableCellDelegate, YYPickViewDelegate>

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitButton;
@property(nonatomic,strong)YYProtocolViewController *protocolViewController;
@property(nonatomic,strong) YYPickView *countryCodePickerView;

@property (nonatomic, strong) NSMutableArray *cellDataArrays;
@property (nonatomic,assign) BOOL protocolViewIsShow;
@property(nonatomic,strong) NSIndexPath *countryCodeIndexPath;

@end

@implementation YYRegisterViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
    [self buildTableViewDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kYYPageRegisterDesignerTypeEmailRegisterType];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kYYPageRegisterDesignerTypeEmailRegisterType];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

- (void)PrepareData{
    self.countryCodeIndexPath = [NSIndexPath indexPathForRow:8 inSection:1];
}

- (void)PrepareUI{
    self.view.backgroundColor = _define_white_color;
    
    self.navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"设计师入驻",nil) WithSuperView: self.view haveStatusView:YES];
    
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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[YYRegisterTableTitleCell class] forCellReuseIdentifier:NSStringFromClass([YYRegisterTableTitleCell class])];
    [self.tableView registerClass:[YYRegisterTableInputCell class] forCellReuseIdentifier:NSStringFromClass([YYRegisterTableInputCell class])];
    [self.tableView registerClass:[YYRegisterTableSubmitCell class] forCellReuseIdentifier:NSStringFromClass([YYRegisterTableSubmitCell class])];
    [self.tableView registerClass:[YYRegisterTableEmailVerifyCell class] forCellReuseIdentifier:NSStringFromClass([YYRegisterTableEmailVerifyCell class])];
    self.tableView.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.tableView registerAsDodgeViewForMLInputDodger];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.backgroundColor = _define_black_color;
    [self.submitButton setTitle:NSLocalizedString(@"提交申请",nil) forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.submitButton addTarget:self action:@selector(submitApplication) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    [self reloadUI];
}

- (void)reloadUI {
    if (self.registerType == YYUserTypeDesigner) {
        self.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarAndNavigationBarHeight - kTabbarAndBottomSafeAreaHeight);
        self.submitButton.hidden = NO;
        self.submitButton.frame = CGRectMake(0, SCREEN_HEIGHT - kTabbarAndBottomSafeAreaHeight, SCREEN_WIDTH, 58);
    } else if (self.registerType == kEmailRegisterType) {
        self.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarAndNavigationBarHeight);
        self.submitButton.hidden = YES;
        self.submitButton.frame = CGRectZero;
    }
}

#pragma mark - --------------请求数据----------------------
-(void)RequestData{}

- (void)registerDesignerWithParams:(NSArray *)paramsArr {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    YYTableViewCellInfoModel *infoModel = [self getCellData:1 row:11 index:0 content:nil];
    __block NSString *blockEmailstr = infoModel.value;
    [YYUserApi registerDesignerWithData:paramsArr andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if( rspStatusAndMessage.status == YYReqStatusCode100){
            [YYToast showToastWithView:self.view title: NSLocalizedString(@"注册成功！",nil) andDuration:kAlertToastDuration];
            self.registerType = kEmailRegisterType;
            self.userEmail = blockEmailstr;
            [self reloadUI];
            [self buildTableViewDataSource];
            [self.tableView reloadData];
            return;

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
    NSInteger type = cellData.type;
    
    if(type == RegisterTableCellStep){
        YYStepViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYStepViewCell class])];
        if (!cell) {
            cell = [[YYStepViewCell alloc] initWithStepStyle:StepStyleFourStep reuseIdentifier:NSStringFromClass([YYStepViewCell class])];
            cell.firtTitle = NSLocalizedString(@"提交入驻申请",nil);
            cell.secondTitle = NSLocalizedString(@"验证邮箱",nil);
            cell.thirdTitle = IsPhone6_gt?NSLocalizedString(@"30天内验证品牌",nil):NSLocalizedString(@"30天内验证",nil);
            cell.fourthTitle = NSLocalizedString(@"成功入驻",nil);
        }
        cell.currentStep = [cellData.object integerValue];
        [cell updateUI];
        return cell;
    }
    if(type == RegisterTableCellTypeTitle){
        YYTableViewCellInfoModel *infoModel = cellData.object;
        YYRegisterTableTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYRegisterTableTitleCell class])];
        cell.title = infoModel.title;
        [cell updateUI];
        return cell;
    }
    if(type == RegisterTableCellTypeInput){
        YYRegisterTableInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYRegisterTableInputCell class])];
        if(indexPath.section == 1 && (indexPath.row == 6 || indexPath.row == 9)){
            cell.isMust = NO;
        }else{
            cell.isMust = YES;
        }
        
        YYTableViewCellInfoModel *infoModel = cellData.object;
        cell.otherInfo = nil;
        //判断当前InputCell 是否是电话号码输入类型  再传入区号类型  根据这个进行验证
        if([infoModel.propertyKey isEqualToString:@"phone"]){
            if(indexPath.row){
                NSArray *tempData = [self.cellDataArrays objectAtIndex:indexPath.section];
                YYTableViewCellData *tempCellData = [tempData objectAtIndex:indexPath.row - 1];
                cell.otherInfo = tempCellData.object;
            }
        }
        
        [cell updateCellInfo:cellData.object];
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }
    if(type == RegisterTableCellTypeSubmit){
        YYRegisterTableSubmitCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYRegisterTableSubmitCell class])];
        [cell updateCellInfo:cellData.object];
        cell.delegate = self;
        cell.indexPath = indexPath;
        [cell setBlock:^(NSString *type) {
            if([type isEqualToString:@"secrecyAgreement"])
            {
                [self showProtocolView:NSLocalizedString(@"隐私权保护声明",nil) protocolType:@"secrecyAgreement"];
            }else if([type isEqualToString:@"serviceAgreement"])
            {
                [self showProtocolView:NSLocalizedString(@"服务协议",nil) protocolType:@"serviceAgreement"];
            }
        }];
        return cell;
    }
    if(type == RegisterTableCellTypeEmailVerify){
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0.1;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.registerType == YYUserTypeDesigner) {
        if (indexPath.section == 1 && indexPath.row == 8) {
            [self countryCodeButtonClicked];
        }
    }
}

#pragma mark - --------------自定义代理/block----------------------
#pragma mark YYpickVIewDelegate
-(void)toobarDonBtnHaveClick:(YYPickView *)pickView resultString:(NSString *)resultString{
    //    +44 英国|8
    //    +971 阿拉伯联合酋长国|17
    //直接存了  这边
    NSLog(@"1111");
    [self selectClick:self.countryCodeIndexPath.row AndSection:self.countryCodeIndexPath.section andParmas:@[resultString,@(0),@(1)]];
}

#pragma mark - YYRegisterTableCellDelegate
-(void)selectClick:(NSInteger)type AndSection:(NSInteger)section andParmas:(NSArray *)parmas {
    NSArray *data = nil;
    YYTableViewCellData *cellData =nil;
    YYTableViewCellInfoModel *info = nil;
    NSString *content = [parmas objectAtIndex:0];
    NSInteger index = [[parmas objectAtIndex:1] integerValue];
    BOOL refreshFlag = (([parmas count] == 3)?YES:NO);
    
    if(index == -2){//帮助
        NSInteger helpPanelType = [[parmas objectAtIndex:2] integerValue];
        [[YYYellowPanelManage instance] showhelpPanelWidthParentView:self.view helpPanelType:helpPanelType andCallBack:^(NSArray *value) {
            
        }];
        return;
    }
    if (index == -1) {
        [self submitApplication];
    }
    
    data = [self.cellDataArrays objectAtIndex:section];
    cellData = [data objectAtIndex:type];
    info = cellData.object;
    //更新数据
    if(info){
        YYTableViewCellInfoModel *infoModel = info;
        infoModel.value = content;
        if([infoModel.propertyKey isEqualToString:@"password"] && [data count]>(type+1)){
            cellData = [data objectAtIndex:type+1];
            info = cellData.object;
            infoModel = info;
            infoModel.passwordvalue = content;
        }else if([infoModel.propertyKey isEqualToString:@"brandRegisterType"]&& [data count]>(type+1)){
            
        }
    }
    if(refreshFlag) {
        [self.tableView reloadData];
    }
}

#pragma mark - --------------自定义响应----------------------
- (void)goBack {
    if (self.registerType == kBrandRegisterStep2Type) {
        self.registerType = kBrandRegisterStep1Type;
        [self buildTableViewDataSource];
        [self.tableView reloadData];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)countryCodeButtonClicked{
    if(self.countryCodePickerView == nil){
        NSArray *pickData = getContactLocalData();
        self.countryCodePickerView=[[YYPickView alloc] initPickviewWithArray:pickData isHaveNavControler:NO];
        self.countryCodePickerView.uidataType = UIDataTypeModifyLimit;//不要出现index 这边不需要
        [self.countryCodePickerView show:self.view];
        self.countryCodePickerView.delegate = self;
    }else
    {
        [self.countryCodePickerView show:self.view];
    }
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
                if(cellData.type !=  RegisterTableCellTypeTitle && cellData.type !=  RegisterTableCellTypeSubmit){
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
    if(self.registerType == YYUserTypeDesigner){
        if(retailerNameArr.count)
        {
            NSString *getp = [retailerNameArr componentsJoinedByString:@","];
            NSString *jsonStr = objArrayToJSON([getp componentsSeparatedByString:@","]);
            [paramsArr addObject:[[NSString alloc] initWithFormat:@"retailerName=%@",jsonStr]];
        }
        [self registerDesignerWithParams:paramsArr];
    }else if (self.registerType == kEmailRegisterType) {
        WeakSelf(ws);
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [ws.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - --------------自定义方法----------------------
- (void)buildTableViewDataSource {
    NSMutableArray *arrays = [NSMutableArray array];
    if (self.registerType == YYUserTypeDesigner) {
        if (YES) {
            NSMutableArray *array = [NSMutableArray array];
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellStep;
                data.tableViewCellRowHeight = 82;
                data.object = @(0);
                [array addObject:data];
            }
            [arrays addObject:array];
        }
        if (YES) {
            NSMutableArray *array = [NSMutableArray array];
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeTitle;
                data.tableViewCellRowHeight = 55;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.ismust = 1;
                info.title = NSLocalizedString(@"设计师品牌信息", nil);
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"brandName";
                info.ismust = 1;
                info.title = NSLocalizedString(@"品牌名称",nil);
                info.tipStr = @"infobrand_icon";
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"nickName";
                info.ismust = 1;
                info.title = NSLocalizedString(@"设计师",nil);
                info.tipStr = @"infopeople_icon";
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"retailerName1";
                info.ismust = 1;
                info.title = [[NSString alloc] initWithFormat:@"%@ 1",NSLocalizedString(@"买手店",nil)];
                info.tipStr = @"infobuyer_icon";
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"retailerName2";
                info.ismust = 1;
                info.title = [[NSString alloc] initWithFormat:@"%@ 2",NSLocalizedString(@"买手店",nil)];
                info.tipStr = @"infobuyer_icon";
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"retailerName3";
                info.ismust = 1;
                info.title = [[NSString alloc] initWithFormat:@"%@ 3",NSLocalizedString(@"买手店",nil)];
                info.tipStr = @"infobuyer_icon";
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"webUrl";
                info.ismust = 0;
                info.title = NSLocalizedString(@"网站",nil);
                info.warnStr = NSLocalizedString(@"网址必须以http、https、ftp等开头", nil);
                info.tipStr = @"infoweb_icon";
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"userName";
                info.ismust = 1;
                info.title = NSLocalizedString(@"品牌主要联系人",nil);
                info.tipStr = @"infopeople_icon";
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"countryCode";
                info.ismust = 1;
                info.title = NSLocalizedString(@"区号",nil);
                info.tipStr = @"infophone_icon";
                info.value = NSLocalizedString(@"+86 中国",nil);
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"phone";
                info.ismust = 1;
                info.title = NSLocalizedString(@"主要联系人电话",nil);
                info.warnStr = NSLocalizedString(@"手机号码格式不对",nil);
                info.keyboardType = UIKeyboardTypePhonePad;
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeTitle;
                data.tableViewCellRowHeight = 55;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.ismust = 1;
                info.title = NSLocalizedString(@"账户登录信息",nil);
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"email";
                info.ismust = 1;
                info.title = NSLocalizedString(@"登录Email",nil);
                info.tipStr = @"infoemail_icon";
                info.warnStr = NSLocalizedString(@"Emial格式不对",nil);
                info.keyboardType = UIKeyboardTypeEmailAddress;
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"password";
                info.ismust = 1;
                info.title = NSLocalizedString(@"登录密码",nil);
                info.tipStr = @"infopwd_icon";
                info.secureTextEntry = YES;
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeInput;
                data.tableViewCellRowHeight = 53;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"password";
                info.ismust = 2;
                info.title = NSLocalizedString(@"再输入一次登录密码",nil);
                info.tipStr = @"infopwd_icon";
                info.warnStr = NSLocalizedString(@"两次密码输入不一致",nil);
                info.secureTextEntry = YES;
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeSubmit;
                data.tableViewCellRowHeight = 62;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"agreerule";
                info.ismust = 1;
                info.value = @"checked";
                data.object = info;
                [array addObject:data];
            }
            [arrays addObject:array];
        }
        self.cellDataArrays = arrays;
    } else if (self.registerType == kEmailRegisterType) {
        if (YES) {
            NSMutableArray *array = [NSMutableArray array];
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellStep;
                data.tableViewCellRowHeight = 82;
                data.object = @(1);
                [array addObject:data];
            }
            [arrays addObject:array];
        }
        if (YES) {
            NSMutableArray *array = [NSMutableArray array];
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeEmailVerify;
                data.tableViewCellRowHeight = 510;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.title = NSLocalizedString(@"已成功验证邮箱，去登录",nil);
                info.value = [NSString stringWithFormat:@"%d|%@",self.registerType,self.userEmail];
                data.object = info;
                [array addObject:data];
            }
            [arrays addObject:array];
        }
        self.cellDataArrays = arrays;
    }
}

-(void)showProtocolView:(NSString *)nowTitle protocolType:(NSString*)protocolType{
    if(!self.protocolViewIsShow){
        self.protocolViewIsShow = YES;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
        YYProtocolViewController *protocolViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYProtocolViewController"];
        protocolViewController.nowTitle = nowTitle;
        protocolViewController.protocolType = protocolType;
        self.protocolViewController = protocolViewController;
        
        UIView *superView = self.view;
        
        WeakSelf(ws);
        UIView *showView = protocolViewController.view;
        __weak UIView *weakShowView = showView;
        [protocolViewController setCancelButtonClicked:^(){
            removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.protocolViewController);
            ws.protocolViewIsShow = NO;
        }];
        [superView addSubview:showView];
        [showView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SCREEN_HEIGHT);
            make.left.equalTo(superView.mas_left);
            make.bottom.mas_equalTo(SCREEN_HEIGHT);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        [showView.superview layoutIfNeeded];
        [UIView animateWithDuration:kAddSubviewAnimateDuration animations:^{
            [showView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(20);
            }];
            //必须调用此方法，才能出动画效果
            [showView.superview layoutIfNeeded];
        }completion:^(BOOL finished) {
            
        }];
    }
}

-(YYTableViewCellInfoModel *)getCellData:(NSInteger)section row:(NSInteger)type index:(NSInteger)index content:(NSString *)content{
    NSArray *data = nil;
    YYTableViewCellData *cellData =nil;
    data = [self.cellDataArrays objectAtIndex:section];
    cellData = [data objectAtIndex:type];
    YYTableViewCellInfoModel *info = cellData.object;
    return info;
}

#pragma mark - --------------other----------------------

@end
