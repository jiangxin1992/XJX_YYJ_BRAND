//
//  YYBuyerTableViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//
#import "YYOrderApi.h"
#import "YYConnApi.h"
#import "YYPageInfoModel.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <MJRefresh.h>
#import "YYBuyerViewCell.h"
#import "YYBuyerAddViewCell.h"
#import "YYBuyerTableViewController.h"
#import "YYConnBuyerListModel.h"
#import "YYUser.h"

@interface YYBuyerTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)YYPageInfoModel *currentPageInfo;
@property (nonatomic,weak) UIView *noDataView;

@property (nonatomic,strong) NSMutableArray *buyerListArray;
@end

@implementation YYBuyerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.alwaysBounceVertical = YES;
    //self.collectionView.contentInset = UIEdgeInsetsMake(45, 0, 58, 0);

    [self addHeader];
    [self addFooter];

    //self.noDataView.hidden = YES;
    
    if ([YYCurrentNetworkSpace isNetwork]) {
        //        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //        UIView *superView = appDelegate.window.rootViewController.view;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate checkNoticeCount];
    [self loadDataByPageIndex:1 endRefreshing:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveAction) name:kApplicationDidBecomeActive object:nil];
}
-(void)applicationDidBecomeActiveAction{
    if(!self.noDataView.hidden){
        YYUser *user = [YYUser currentUser];

        if(!((user.userType == YYUserTypeShowroom || user.userType == YYUserTypeShowroomSub)&&![YYUser isShowroomToBrand])){
            [self headerWithRefreshingAction];
        }else{
            NSLog(@"showroom主页");
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.noDataView.hidden){
        [self headerWithRefreshingAction];
    }
}

-(void)reloadBrandData{
    if(self.currentPageInfo != nil){
        [self loadDataByPageIndex:1 endRefreshing:NO];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma MJRefresh.h
//刷新界面
- (void)reloadCollectionViewData:(BOOL)endrefreshing{
    if(endrefreshing){
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }
    [self.collectionView reloadData];
    
    if (!self.buyerListArray || [self.buyerListArray count ]==0) {
        //self.noDataView.hidden = NO;
       // self.collectionView.scrollEnabled = NO;
    }else{
       // self.noDataView.hidden = YES;
      //  self.collectionView.scrollEnabled = YES;
    }
}

- (void)loadDataByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    WeakSelf(ws);
    __block BOOL blockEndrefreshing =endrefreshing;
    [YYConnApi getConnBuyers:_currentListType pageIndex:pageIndex pageSize:8 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYConnBuyerListModel *listModel, NSError *error) {
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            ws.currentPageInfo = listModel.pageInfo;
            if( !ws.currentPageInfo || ws.currentPageInfo.isFirstPage){
                ws.buyerListArray =  [[NSMutableArray alloc] init];//;
            }
            [ws.buyerListArray addObjectsFromArray:listModel.result];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws reloadCollectionViewData:blockEndrefreshing];
        });
        
        //        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //        UIView *superView = appDelegate.window.rootViewController.view;
        
        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        
        if (rspStatusAndMessage.status != YYReqStatusCode100) {
            [YYToast showToastWithTitle:rspStatusAndMessage.message  andDuration:kAlertToastDuration];
        }
    }];
}

- (void)addHeader{
    WeakSelf(ws);
    // 添加下拉刷新头部控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        [ws headerWithRefreshingAction];
    }];
    self.collectionView.mj_header = header;
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}
-(void)headerWithRefreshingAction{
    if (![YYCurrentNetworkSpace isNetwork]) {
        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        [self.collectionView.mj_header endRefreshing];
        return;
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate checkNoticeCount];
    }
    [self loadDataByPageIndex:1 endRefreshing:YES];
}
- (void)addFooter{
    WeakSelf(ws);
    // 添加上拉刷新尾部控件
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block

        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.collectionView.mj_footer endRefreshing];
            return;
        }


        if ([ws.buyerListArray count] > 0
            && ws.currentPageInfo
            && !ws.currentPageInfo.isLastPage) {
            [ws loadDataByPageIndex:[ws.currentPageInfo.pageIndex intValue]+1 endRefreshing:YES];
        }else{
            [ws.collectionView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark -  UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if([self.buyerListArray count]>0){
        return [self.buyerListArray count]+1;
    }else{
        return 1+1;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.buyerListArray count]>0){
        
    }else{
        if(indexPath.row == 1){
            return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-65-60-80*2);
        }
    }
    return CGSizeMake(SCREEN_WIDTH, 80);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        static NSString* reuseIdentifier = @"YYBuyerAddViewCell";
        YYBuyerAddViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        //cell.delegate = self;
        [cell updateUI];
        return cell;
    }else{
        if([self.buyerListArray count] > 0){
            YYConnBuyerModel * infoModel = [self.buyerListArray objectAtIndex:(indexPath.row-1)];
            static NSString* reuseIdentifier = @"YYBuyerViewCell";
            YYBuyerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            cell.indexPath = indexPath;
            //cell.delegate = self;
            cell.infoModel = infoModel;
            [cell updateUI];
            return cell;
        }else{
            static NSString* reuseIdentifier = @"YYBuyerViewNullCell";
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
             if(self.noDataView == nil){
            if(_currentListType == 1){
                self.noDataView = addNoDataView_phone(cell.contentView,[NSString stringWithFormat:@"%@|icon:noconn_icon|60",NSLocalizedString(@"还没有合作的买手店/n与买手店合作后，设置作品权限只给合作买手店查看，可以保护您的原创作品哦~",nil)],nil,nil);
            }else if(_currentListType == 0){
                self.noDataView = addNoDataView_phone(cell.contentView,[NSString stringWithFormat:@"%@|icon:noconn_icon|60",NSLocalizedString(@"还没有邀请中的买手店/n与买手店合作后，设置作品权限只给合作买手店查看，可以保护您的原创作品哦~",nil)],nil,nil);
            }}
            return cell;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        if(self.delegate){
            [self.delegate btnClick:indexPath.row section:indexPath.section andParmas:@[@"addBrand"]];
        }
    }else{
        if([self.buyerListArray count]>0){
        YYConnBuyerModel * infoModel = [self.buyerListArray objectAtIndex:(indexPath.row-1)];
        if(self.delegate && infoModel){
            [self.delegate btnClick:indexPath.row section:indexPath.section andParmas:@[@"brandInfo",infoModel]];
        }
        }
    }
}



@end
