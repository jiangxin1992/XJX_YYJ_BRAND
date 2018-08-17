//
//  YYVerifyBrandViewController.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/21.
//  Copyright © 2017年 Apple. All rights reserved.
//

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYVerifyBrandViewController.h"
#import "YYNavView.h"

// 自定义视图
#import "YYStepViewCell.h"
#import "YYVerifyBrandTableViewDefaultCell.h"
#import "YYRegisterTableBrandRegisterUploadCell.h"

// 接口
#include "YYOrderApi.h"
#import "YYUserApi.h"

// 分类
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MBProgressHUD.h>
#import "MLInputDodger.h"
#import "YYTableViewCellData.h"
#import "YYTableViewCellInfoModel.h"
#import "regular.h"

@interface YYVerifyBrandViewController ()<UITableViewDataSource, UITableViewDelegate, YYRegisterTableCellDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) YYNavView *navView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *submitButton;

@property(nonatomic,assign) NSInteger tmpBrandRegisterType;
@property (nonatomic, strong) NSArray *cellDataArrays;

@end

@implementation YYVerifyBrandViewController

#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self buildTableViewDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:kYYPageBrandRegisterStep1TypeBrandRegisterStep2Type];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:kYYPageBrandRegisterStep1TypeBrandRegisterStep2Type];
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
    
    self.navView = [[YYNavView alloc] initWithTitle:NSLocalizedString(@"品牌验证",nil) WithSuperView: self.view haveStatusView:YES];
    
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerClass:[YYVerifyBrandTableViewDefaultCell class] forCellReuseIdentifier:NSStringFromClass([YYVerifyBrandTableViewDefaultCell class])];
    [self.tableView registerClass:[YYRegisterTableBrandRegisterUploadCell class] forCellReuseIdentifier:NSStringFromClass([YYRegisterTableBrandRegisterUploadCell class])];
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
    if (self.registerType == kBrandRegisterStep2Type) {
        self.uploadImg1 = nil;
        self.uploadImg2 = nil;
        self.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarAndNavigationBarHeight - kTabbarAndBottomSafeAreaHeight);
        self.submitButton.hidden = NO;
        self.submitButton.frame = CGRectMake(0, SCREEN_HEIGHT - kTabbarAndBottomSafeAreaHeight, SCREEN_WIDTH, 58);
    } else if (self.registerType == kBrandRegisterStep1Type) {
        self.tableView.frame = CGRectMake(0, kStatusBarAndNavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarAndNavigationBarHeight - kBottomSafeAreaHeight);
        self.submitButton.hidden = YES;
        self.submitButton.frame = CGRectZero;
    }
}

#pragma mark - --------------请求数据----------------------
- (void)uploadBrandFilesWithParams:(NSArray *)paramsArr {
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSString *brandFiles = [paramsArr objectAtIndex:0];
    [YYUserApi uploadBrandFiles:brandFiles andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSInteger errorCode, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if( rspStatusAndMessage.status == YYReqStatusCode100 && errorCode == YYReqStatusCode100){
            [YYToast showToastWithTitle: NSLocalizedString(@"提交成功！",nil) andDuration:kAlertToastDuration];
            [self.navigationController popToRootViewControllerAnimated:YES];
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
    if (type == TableViewCellTypeDefault) {
        YYTableViewCellInfoModel *info = cellData.object;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.text = info.title;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
    if (type == RegisterTableCellTypeBrandRegisterType) {
        YYTableViewCellInfoModel *info = cellData.object;
        
        YYVerifyBrandTableViewDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYVerifyBrandTableViewDefaultCell class])];
        [cell updateCellInfo:info];
        return cell;
    }
    if (type == RegisterTableCellTypeBrandRegisterUpload) {
        YYRegisterTableBrandRegisterUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YYRegisterTableBrandRegisterUploadCell class])];
        cell.delegate = self;
        cell.firstUploadImage = self.uploadImg1;
        cell.secondUploadImage = self.uploadImg2;
        [cell updateCellInfo:cellData.object];
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
    NSLog(@"didSelectRowAtIndexPath");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *data = [self.cellDataArrays objectAtIndex:indexPath.section];
    YYTableViewCellData *cellData = [data objectAtIndex:indexPath.row];
    if (cellData.selectedCellBlock) {
        cellData.selectedCellBlock(indexPath);
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    获取选择图片
    UIImage *image = [UIImage fixOrientation:info[UIImagePickerControllerOriginalImage]];
    WeakSelf(ws);
    if (image) {
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithView:self.view title:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [YYOrderApi uploadImage:image size:2.0f andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSString *imageUrl, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (imageUrl && [imageUrl length] > 0) {
                    NSLog(@"imageUrl: %@",imageUrl);
                    NSArray *data = nil;
                    YYTableViewCellData *cellData =nil;
                    YYTableViewCellInfoModel *info = nil;
                    if(ws.registerType == kBrandRegisterStep2Type){
                        data = [self.cellDataArrays objectAtIndex:1];
                        cellData = [data objectAtIndex:0];
                        info = cellData.object;
                        YYTableViewCellInfoModel *infoModel = info;
                        NSArray *valueArr = [infoModel.value componentsSeparatedByString:@","];
                        if(ws.uploadImgType == 1){
                            ws.uploadImg1 = image;
                            infoModel.value = [NSString stringWithFormat:@"%@,%@",imageUrl,[valueArr objectAtIndex:1]];
                        }else if(ws.uploadImgType == 2){
                            ws.uploadImg2 = image;
                            infoModel.value = [NSString stringWithFormat:@"%@,%@",[valueArr objectAtIndex:0],imageUrl];
                        }
                    }
                    
                    [ws.tableView reloadData];
                }
                
            }];
        }
        if(ws.registerType == kBrandRegisterStep2Type){
            if(ws.uploadImgType == 1){
                ws.uploadImg1 = image;
            }else if(ws.uploadImgType == 2){
                ws.uploadImg2 = image;
            }
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //    WeakSelf(weakSelf);
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
}

#pragma mark - --------------自定义代理/block----------------------
-(void)upLoadPhotoImage:(NSInteger )type pointX:(NSInteger)px pointY:(NSInteger)py {
    WeakSelf(ws);
    self.uploadImgType = type;
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.view.backgroundColor = _define_white_color;
    picker.delegate = self;
    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UIAlertController * alertController = [regular getAlertWithFirstActionTitle:NSLocalizedString(@"相册",nil) FirstActionBlock:^{
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [ws presentViewController:picker animated:YES completion:nil];
        }else
        {
            NSLog(@"无法打开相册");
        }
        
    } SecondActionTwoTitle:NSLocalizedString(@"拍照",nil) SecondActionBlock:^{
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //打开相机
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [ws presentViewController:picker animated:YES completion:nil];
        }else
        {
            NSLog(@"不能打开相机");
        }
        
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - --------------自定义响应----------------------
- (void)goBack {
    if (self.registerType == kBrandRegisterStep2Type) {
        self.registerType = kBrandRegisterStep1Type;
        [self buildTableViewDataSource];
        [self reloadUI];
        [self.tableView reloadData];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
                        if(model.ismust > 0 && (!self.uploadImg1 || !self.uploadImg2) ){
                            [YYToast showToastWithView:self.view title:NSLocalizedString(@"完善信息",nil) andDuration:kAlertToastDuration];
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
                }
            }
            verifyRow ++;
        }
    }
    [self uploadBrandFilesWithParams:paramsArr];
}

#pragma mark - --------------自定义方法----------------------
- (void)buildTableViewDataSource {
    NSMutableArray *arrays = [NSMutableArray array];
    if (self.registerType == kBrandRegisterStep1Type) {
        if (YES) {
            NSMutableArray *array = [NSMutableArray array];
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellStep;
                data.tableViewCellRowHeight = 82;
                data.object = @(2);
                [array addObject:data];
            }
            [arrays addObject:array];
        }
        if (YES) {
            NSMutableArray *array = [NSMutableArray array];
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = TableViewCellTypeDefault;
                data.tableViewCellRowHeight = 50;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.title = NSLocalizedString(@"Step 1.选择品牌商标的注册形式", nil);
                data.object = info;
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeBrandRegisterType;
                data.tableViewCellRowHeight = 80;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.title = NSLocalizedString(@"个人注册商标", nil);
                info.tipStr = @"Individual_registered_trademark";
                data.object = info;
                WeakSelf(ws);
                [data setSelectedCellBlock:^(NSIndexPath *indexPath) {
                    ws.registerType = kBrandRegisterStep2Type;
                    ws.tmpBrandRegisterType = 1;
                    [ws buildTableViewDataSource];
                    [ws reloadUI];
                    [ws.tableView reloadData];
                }];
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeBrandRegisterType;
                data.tableViewCellRowHeight = 80;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.title = NSLocalizedString(@"公司注册商标", nil);
                info.tipStr = @"Company_registered_trademark";
                data.object = info;
                WeakSelf(ws);
                [data setSelectedCellBlock:^(NSIndexPath *indexPath) {
                    ws.registerType = kBrandRegisterStep2Type;
                    ws.tmpBrandRegisterType = 2;
                    [ws buildTableViewDataSource];
                    [ws reloadUI];
                    [ws.tableView reloadData];
                }];
                [array addObject:data];
            }
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeBrandRegisterType;
                data.tableViewCellRowHeight = 80;
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.title = NSLocalizedString(@"授权商标", nil);
                info.tipStr = @"Authorized_trademarks";
                data.object = info;
                WeakSelf(ws);
                [data setSelectedCellBlock:^(NSIndexPath *indexPath) {
                    ws.registerType = kBrandRegisterStep2Type;
                    ws.tmpBrandRegisterType = 3;
                    [ws buildTableViewDataSource];
                    [ws reloadUI];
                    [ws.tableView reloadData];
                }];
                [array addObject:data];
            }
            [arrays addObject:array];
        }
    } else if (self.registerType == kBrandRegisterStep2Type) {
        if (YES) {
            NSMutableArray *array = [NSMutableArray array];
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellStep;
                data.tableViewCellRowHeight = 82;
                data.object = @(2);
                [array addObject:data];
            }
            [arrays addObject:array];
        }
        if (YES) {
            NSMutableArray *array = [NSMutableArray array];
            if (YES) {
                YYTableViewCellData *data = [[YYTableViewCellData alloc] init];
                data.type = RegisterTableCellTypeBrandRegisterUpload;
                data.tableViewCellRowHeight = [YYRegisterTableBrandRegisterUploadCell cellheight];
                YYTableViewCellInfoModel *info = [[YYTableViewCellInfoModel alloc] init];
                info.propertyKey = @"brandFiles";
                info.ismust = 1;
                info.warnStr = NSLocalizedString(@"完善信息",nil);
                info.value = @",";
                info.brandRegisterType = self.tmpBrandRegisterType;
                data.object = info;
                [array addObject:data];
            }
            [arrays addObject:array];
        }
    }
    self.cellDataArrays = arrays;
}

#pragma mark - --------------other----------------------

@end
