//
//  YYInventoryBuyersViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYInventoryBuyersViewController.h"
#import "YYNavigationBarViewController.h"
#import "YYInventoryApi.h"
#import "YYInventoryBuyersViewCell.h"
#import "YYOrderApi.h"
#import "YYOrderDetailViewController.h"
#import "YYUser.h"
#import "MBProgressHUD.h"
#import "YYInventoryBuyerOrderInfoViewCell.h"

@interface YYInventoryBuyersViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UIView *noDataView;

@property (strong, nonatomic)CMAlertView *selectListAlert;
@property (nonatomic,strong) UITableView *selectListTableView;
@property (strong, nonatomic)NSArray *selectListArray;

@end

@implementation YYInventoryBuyersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    //self.navigationBarViewController = navigationBarViewController;
    navigationBarViewController.nowTitle = NSLocalizedString(@"订货买手店",nil);
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
-(void)reloadTableData{
    //    if(self.isSearchView){
    //        self.noDataView.hidden = YES;
    //    }else{
    //        if ([self.listArray count] <= 0) {
    //            self.noDataView.hidden = NO;
    //        }else{
    //            self.noDataView.hidden = YES;
    //        }
    //    }
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_selectListTableView && _selectListTableView ==tableView){
        return [_selectListArray count];
    }else{
    if([_listArray count] > 0){
        return [_listArray count];
    }else{
        return 1;
    }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_selectListTableView && _selectListTableView ==tableView){
        YYInventoryOrderModel * orderModel = [_selectListArray objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"YYInventoryBuyerOrderInfoViewCell";
        YYInventoryBuyerOrderInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//        if(indexPath.row%2 == 0){
//            cell.contentView.backgroundColor = [UIColor colorWithHex:@"efefef"];
//        }else{
//            cell.contentView.backgroundColor = [UIColor whiteColor];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderCodeLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"单号",nil),orderModel.orderCode];
        cell.timerLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"建单",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd HH:mm",[orderModel.orderCreateTime stringValue])];
        cell.priceLabel.text =  replaceMoneyFlag([NSString stringWithFormat:NSLocalizedString(@"共%@款%@件 ￥%0.2f",nil),orderModel.amount,orderModel.styleCount,[orderModel.finalTotalPrice doubleValue]],[orderModel.curType integerValue]);
        return cell;
    }else{
    
    if([_listArray count] > 0){//
        YYInventoryBuyerModel *buyerModel = [_listArray objectAtIndex:indexPath.row];
        NSString *CellIdentifier = @"YYInventoryBuyersViewCell";
        YYInventoryBuyersViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.buyerModel = buyerModel;
        [cell updateUI];
        return cell;
    }else{
        static NSString* reuseIdentifier = @"YYInventoryViewNullCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        if(self.noDataView == nil){
            self.noDataView = addNoDataView_phone(cell.contentView,[NSString stringWithFormat:@"%@|icon|noorder_icon|40",NSLocalizedString(@"暂无相关数据哦~",nil)],nil,nil);
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    }
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_selectListTableView && _selectListTableView ==tableView){
        if(indexPath.row == ([_selectListArray count]-1)){
            return 85;
        }
        return 83;
    }else{
        if([_listArray count] > 0){
            return 67;
        }else{
            return 280;
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_selectListTableView && _selectListTableView ==tableView){
        YYInventoryOrderModel * orderModel = [_selectListArray objectAtIndex:indexPath.row];
        NSString *orderCode = orderModel.orderCode;
        [self showOrderDetail:orderCode];
    }else{
    YYInventoryBuyerModel *buyerModel = [_listArray objectAtIndex:indexPath.row];
    if(buyerModel){
    if([buyerModel.orderCodes count]>1){
        WeakSelf(ws);
        NSString *orderCodes = [buyerModel.orderCodes componentsJoinedByString:@","];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [YYInventoryApi getBuyerOrders:orderCodes andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYInventoryOrderListModel *listModel, NSError *error) {
            if(rspStatusAndMessage.status == kCode100){
                ws.selectListArray = listModel.result;
                [ws showOrdersInfo];
            }else{
                [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];//“
            }
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        }];
    }else{
        NSString *orderCode = [buyerModel.orderCodes objectAtIndex:0];
        [self showOrderDetail:orderCode];
    }
    }}
}

-(void)showOrderDetail:(NSString *)orderCode{
    WeakSelf(ws);
    __block NSString* blockorderCode = orderCode;
    [YYOrderApi getOrderTransStatus:orderCode andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOrderTransStatusModel *transStatusModel, NSError *error) {
        NSInteger transStatus = getOrderTransStatus(transStatusModel.designerTransStatus, transStatusModel.buyerTransStatus);
        if (transStatusModel == nil || transStatus == kOrderCode_DELETED) {
            [YYToast showToastWithView:self.view title:NSLocalizedString(@"此订单已被删除",nil) andDuration:kAlertToastDuration];//“
            return ;
        }else{
            YYUser *user = [YYUser currentUser];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
            YYOrderDetailViewController *orderDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderDetailViewController"];
            orderDetailViewController.currentOrderCode = blockorderCode;
            orderDetailViewController.currentOrderLogo =  user.logo;
            orderDetailViewController.currentOrderConnStatus = kOrderStatusNUll;
            [ws.navigationController pushViewController:orderDetailViewController animated:YES];
        }
        
    }];
}

-(void)showOrdersInfo{
    NSInteger listUIWidth = SCREEN_WIDTH - 36;
    NSInteger listUIHeight = 63*MIN(4, [self.selectListArray count])+44+2;
    //UITableView *table = [self listTableView];
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, listUIWidth, listUIHeight);
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 4;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, listUIWidth, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = NSLocalizedString(@"选择订单",nil);
    [view addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, listUIWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithHex:@"efefef"];
    [view addSubview:lineView];
    
    UITableView *listTableView = [self listTableView];
    listTableView.frame = CGRectMake(0, 44, listUIWidth, listUIHeight-44);
    [view addSubview:listTableView];

    _selectListAlert = [[CMAlertView alloc] initWithViews:@[view] imageFrame:CGRectMake(0, 0, listUIWidth, listUIHeight) bgClose:NO];
    UIView *parentview = self.view;
    [_selectListAlert show:parentview];
}
-(UITableView *)listTableView{
    if(_selectListTableView == nil){
        _selectListTableView = [[UITableView alloc] init];
        _selectListTableView.delegate = self;
        _selectListTableView.dataSource = self;
        //_dateRangeListTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //_selectListTableView.separatorColor = [UIColor colorWithHex:@"efefef"];
        //_selectListTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _selectListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectListTableView.backgroundColor = [UIColor whiteColor];
        
        [_selectListTableView registerNib:[UINib nibWithNibName:@"YYInventoryBuyerOrderInfoViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"YYInventoryBuyerOrderInfoViewCell"];
        
    }
    [_selectListTableView reloadData];
    return _selectListTableView;
}
@end
