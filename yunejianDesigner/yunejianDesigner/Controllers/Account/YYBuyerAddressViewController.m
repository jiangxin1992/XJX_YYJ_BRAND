//
//  YYBuyerAddressViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/2/14.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerAddressViewController.h"

#import "YYUserApi.h"
#import "YYAddressCell.h"
#import "YYAddAddressCell.h"
#import "YYAddress.h"
#import "YYCreateOrModifyAddressViewController.h"
#import "AppDelegate.h"
#import "YYAddressModel.h"
#import "YYAddressListModel.h"
#import "YYNavigationBarViewController.h"

@interface YYBuyerAddressViewController ()<UITableViewDataSource,UITableViewDelegate,YYTableCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *_containerView;
@property (nonatomic,strong) NSMutableArray *addressArray;
@property(nonatomic,strong) YYCreateOrModifyAddressViewController *createOrModifyAddressViewController;

@end

@implementation YYBuyerAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    //self.navigationBarViewController = navigationBarViewController;
    if(_isSelect){
         navigationBarViewController.nowTitle = NSLocalizedString(@"添加收件地址",nil);
    }else{
        navigationBarViewController.nowTitle = NSLocalizedString(@"管理收件地址",nil);
    }
    [__containerView insertSubview:navigationBarViewController.view atIndex:0];
    //[_containerView addSubview:navigationBarViewController.view];
    __weak UIView *_weakContainerView = __containerView;
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
            //[weakSelf.navigationController popViewControllerAnimated:YES];
            [ws closeBtnHandler:nil];
            blockVc = nil;
        }
    }];
    //_tableView.backgroundColor = [UIColor colorWithHex:@"efefef"];
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self getAddressList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)getAddressList{
    WeakSelf(ws);
    [YYUserApi getAddressListWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYAddressListModel *addressListModel, NSError *error) {
        if (addressListModel) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            for (YYAddressModel *addressModel in addressListModel.result) {
                YYAddress *address = [[YYAddress alloc] init];
                
                address.addressId = addressModel.addressId;
                address.detailAddress = addressModel.detailAddress;
                address.receiverName = addressModel.receiverName;
                address.receiverPhone = addressModel.receiverPhone;
                address.defaultShipping = addressModel.defaultShipping;
                address.defaultBilling = addressModel.defaultBilling;
                
                address.street = addressModel.street;
                address.zipCode = addressModel.zipCode;
                
                address.nation = addressModel.nation;
                address.province = addressModel.province;
                address.city = addressModel.city;
                address.nationEn = addressModel.nationEn;
                address.provinceEn = addressModel.provinceEn;
                address.cityEn = addressModel.cityEn;
                address.nationId = addressModel.nationId;
                address.provinceId = addressModel.provinceId;
                address.cityId = addressModel.cityId;
                
                [array addObject:address];
            }
            
            _addressArray = [NSArray arrayWithArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws reloadTableView];
            });
        }
    }];
}
- (void)reloadTableView{
    [_tableView reloadData];
}

-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{

    [self createOrModifyAddress:nil];
    
}

//创建或修改收件地址
- (void)createOrModifyAddress:(YYAddress *)address{
    
    WeakSelf(ws);
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYCreateOrModifyAddressViewController *createOrModifyAddressViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYCreateOrModifyAddressViewController"];
    self.createOrModifyAddressViewController = createOrModifyAddressViewController;
    
    if (address
        && [address isKindOfClass:[YYAddress class]]) {
        createOrModifyAddressViewController.currentOperationType = OperationTypeModify;
        createOrModifyAddressViewController.address = address;
    }else{
        createOrModifyAddressViewController.currentOperationType = OperationTypeCreate;
        createOrModifyAddressViewController.address = nil;
    }
    [self.navigationController pushViewController:createOrModifyAddressViewController animated:YES];

    [createOrModifyAddressViewController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [createOrModifyAddressViewController setModifySuccess:^(){
        [ws.navigationController popViewControllerAnimated:NO];
        [ws getAddressList];
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    
    if(section == 0){
        rows = 1;
    }else if (section == 1) {
        if ([_addressArray count]) {
            rows = [_addressArray count];
        }
    }
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
//    YYUser *user = [YYUser currentUser];
    
//    WeakSelf(weakSelf);
    if(section == 0){
        static NSString *CellIdentifier = @"addAddressCell";
        YYAddAddressCell *addAddressCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        addAddressCell.selectionStyle = UITableViewCellSelectionStyleNone;
        addAddressCell.delegate = self;
        [addAddressCell updateUI];
        cell = addAddressCell;
    }else if(section == 1) {
        static NSString *CellIdentifier = @"addressCell";
        YYAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        addressCell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (_addressArray
            && [_addressArray count] > 0
            && row < [_addressArray count]) {
            YYAddress *address = [_addressArray objectAtIndex:row];
            
            addressCell.address = address;
            [addressCell updateUI];
        }
        cell = addressCell;
        
    }
    
    if (cell == nil){
        [NSException raise:@"DetailCell == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section== 0){
        return 80;
    }
    YYAddress *address = [_addressArray objectAtIndex:indexPath.row];
    return [YYAddressCell getCellHeight:address];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //if(section == 0){
        return 0.1;
    //}
    
    //return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        YYAddress *address = [_addressArray objectAtIndex:indexPath.row];
        
        if(_isSelect){
            if(self.selectAddressClicked){
                self.selectAddressClicked(address);
            }
        }else{
            [self createOrModifyAddress:address];
        }
    }
}

////下面设置可以出现删除按钮 或者直接不写这个方法
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return  UITableViewCellEditingStyleNone;
    }
    return UITableViewCellEditingStyleDelete;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"      ";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        WeakSelf(ws);

        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确认删除此收件地址吗？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[@"删除"]];
        alertView.specialParentView = self.view;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                YYAddress *address = [ws.addressArray objectAtIndex:indexPath.row];
                //__block NSInteger row = indexPath.row;
                [YYUserApi deleteAddress:[address.addressId integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                    if(rspStatusAndMessage.status == YYReqStatusCode100){
                        //                [weakself.addressArray removeObjectAtIndex:row];  //删除数组里的数据
                        //                [weakself.tableView reloadData];
                        //[weakself.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                        [ws getAddressList];
                    }else{
                        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                    }
                }];
            }
        }];
        [alertView show];

    }
}

- (IBAction)closeBtnHandler:(id)sender {
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}

@end
