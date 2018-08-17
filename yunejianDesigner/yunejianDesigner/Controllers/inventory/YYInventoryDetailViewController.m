//
//  YYInventoryDetailViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYInventoryDetailViewController.h"
#import "YYNavigationBarViewController.h"
#import <MJRefresh.h>
#import "MBProgressHUD.h"
#import "YYInventoryApi.h"
#import "YYInventoryDetailStyleInfoCell.h"
#import "YYInventoryDetailStyleBuyerInfoCell.h"
#import "YYInventoryApi.h"
#import "YYInventoryBuyersViewController.h"
#import "YYInventoryBuyerInfoViewController.h"

@interface YYInventoryDetailViewController ()<UITableViewDataSource,UITableViewDelegate,YYTableCellDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UIView *noDataView;
@property (strong, nonatomic)NSMutableArray *listArray;
@property (nonatomic,strong)  YYInventoryAllottingInfoModel *infoModel;
@property(nonatomic,assign) NSInteger selectedSegmentIndex;

@property (strong, nonatomic)NSMutableArray *showRowArray;

@end

@implementation YYInventoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    //self.navigationBarViewController = navigationBarViewController;
    navigationBarViewController.nowTitle = NSLocalizedString(@"库存调拨详情",nil);
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

    [self addHeader];

    self.listArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.showRowArray = [[NSMutableArray alloc] initWithCapacity:0];

    self.selectedSegmentIndex = 0;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadListFromServerByPageIndex:1 endRefreshing:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageInventoryDetail];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageInventoryDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showBuyers:(id)sender {
    WeakSelf(ws);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Inventory" bundle:[NSBundle mainBundle]];
    YYInventoryBuyersViewController *inventoryBuyersViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYInventoryBuyersViewController"];
    inventoryBuyersViewController.listArray = _infoModel.buyers;
    [inventoryBuyersViewController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:inventoryBuyersViewController animated:YES];
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

- (void)addHeader{
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.tableView.mj_header endRefreshing];
            return;
        }
        [ws loadListFromServerByPageIndex:1 endRefreshing:YES];
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}

- (void)loadListFromServerByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    WeakSelf(ws);
    
    __block BOOL blockEndrefreshing = endrefreshing;
    [YYInventoryApi getAllottingInfo:[_allottingModel.styleId integerValue] colorId:[_allottingModel.colorId integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYInventoryAllottingInfoModel *infoModel, NSError *error) {
        if (rspStatusAndMessage.status == kCode100) {
            ws.infoModel = infoModel;
        }else{
            ws.infoModel = nil;
        }
        [ws switchTableData];
        if(blockEndrefreshing){
            [self.tableView.mj_header endRefreshing];
        }
        
        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
    }];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        if(section == 0){
            return 1;
        }
        if([_listArray count] > 0){
            return [_listArray count];
        }else{
            return 1;
        }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if(indexPath.section == 0){
            NSString *CellIdentifier = @"YYInventoryDetailStyleInfoCell";
            YYInventoryDetailStyleInfoCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.selectedSegmentIndex = self.selectedSegmentIndex;
            cell.allottingModel = _allottingModel;
            [cell updateUI];
            return cell;
        }else{
            if([_listArray count] > 0){//
                YYInventoryStyleDemandModel *styleDemandModel = [_listArray objectAtIndex:indexPath.row];
                NSString *CellIdentifier = @"YYInventoryDetailStyleBuyerInfoCell";
                YYInventoryDetailStyleBuyerInfoCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                cell.indexPath = indexPath;
                cell.delegate = self;
                cell.styleDemandModel = styleDemandModel;
                NSString *key = [NSString stringWithFormat:@"%ld_%ld",(long)self.selectedSegmentIndex,indexPath.row];
                if([self.showRowArray containsObject:key]){
                    cell.isShow = YES;
                }else{
                    cell.isShow = NO;
                }
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

        if(indexPath.section == 0){
            return 140;
        }
        if([_listArray count] > 0){
            NSString *key = [NSString stringWithFormat:@"%ld_%ld",(long)self.selectedSegmentIndex,indexPath.row];
            if([self.showRowArray containsObject:key]){
                return 105;
            }else{
                return 105-46;
            }
        }else{
            return SCREEN_HEIGHT - 65 -140;
        }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        if(indexPath.section == 1 && [_listArray count] > 0){
            NSString *key = [NSString stringWithFormat:@"%ld_%ld",(long)self.selectedSegmentIndex,indexPath.row];
            if([self.showRowArray containsObject:key]){
                [self.showRowArray removeObject:key];

            }else{
                [self.showRowArray addObject:key];
            }
            
            [self reloadTableData];
        }else if(indexPath.section == 0){
        
            
        }
    
}

-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    WeakSelf(ws);
    NSString *type = [parmas objectAtIndex:0];
    if([type isEqualToString:@"SegmentIndex"]){
        self.selectedSegmentIndex = [[parmas objectAtIndex:1] integerValue];
        [self switchTableData];
    }else if([type isEqualToString:@"SetResolve"]){
        CMAlertView *alertView = nil;
        if( self.selectedSegmentIndex == 0){
            alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"标记此条补货需求为“已解决”？",nil) message:NSLocalizedString(@"标记为已解决后不可修改此条收到库存的消息状态。",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[[NSString stringWithFormat:@"%@|000000",NSLocalizedString(@"标记已解决",nil)]]];;
        }else if( self.selectedSegmentIndex == 1){
            alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"标记此条我有库存为“已解决”？",nil) message:NSLocalizedString(@"标记为已解决后不可修改此条补货需求的消息状态。",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[[NSString stringWithFormat:@"%@|000000",NSLocalizedString(@"标记已解决",nil)]]];
        }
        alertView.specialParentView = self.view ;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                YYInventoryStyleDemandModel *styleDemandModel = [ws.listArray objectAtIndex:row];

                if( ws.selectedSegmentIndex == 0){
                    [YYInventoryApi setDemandResolve:[styleDemandModel.id integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                        if(rspStatusAndMessage.status == kCode100){
                            [MBProgressHUD showHUDAddedTo:ws.view animated:YES];
                            [ws loadListFromServerByPageIndex:1 endRefreshing:NO];
                        }
                        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                    }];
                }else if( ws.selectedSegmentIndex == 1){
                    [YYInventoryApi setAllottingResolve:[styleDemandModel.id integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                        if(rspStatusAndMessage.status == kCode100){
                            [MBProgressHUD showHUDAddedTo:ws.view animated:YES];
                            [ws loadListFromServerByPageIndex:1 endRefreshing:NO];
                        }
                        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];

                    }];
                }
            }
        }];
        [alertView show];
    }else if([type isEqualToString:@"buyerInfo"]){
        WeakSelf(ws);
        YYInventoryStyleDemandModel *styleDemandModel = [ws.listArray objectAtIndex:row];

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Inventory" bundle:[NSBundle mainBundle]];
        YYInventoryBuyerInfoViewController *inventoryBuyerInfoViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYInventoryBuyerInfoViewController"];
        inventoryBuyerInfoViewController.buyerModel = [self getBuyerModel:styleDemandModel];
        [inventoryBuyerInfoViewController setCancelButtonClicked:^(){
            [ws.navigationController popViewControllerAnimated:YES];
        }];
        [self.navigationController pushViewController:inventoryBuyerInfoViewController animated:YES];

    }
}

-(YYInventoryBuyerModel*)getBuyerModel:(YYInventoryStyleDemandModel *)styleDemandModel{
    for (YYInventoryBuyerModel * buyerModel in  _infoModel.buyers) {
        if([buyerModel.buyerId integerValue] == [styleDemandModel.buyerId integerValue]){
            return buyerModel;
        }
    }
    return nil;
}

-(void)switchTableData{
    [_listArray removeAllObjects];
    if( self.selectedSegmentIndex == 0){
        [_listArray  addObjectsFromArray:_infoModel.demands];
    }else if( self.selectedSegmentIndex == 1){
        [_listArray  addObjectsFromArray:_infoModel.inventories];
    }
    [self reloadTableData];
}



@end
