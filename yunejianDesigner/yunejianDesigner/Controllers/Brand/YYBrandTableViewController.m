//
//  YYBrandTableViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/5/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandTableViewController.h"
#import "YYOrderApi.h"
#import "YYConnApi.h"
#import "YYPageInfoModel.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <MJRefresh.h>
#import "YYBrandViewCell.h"
#import "YYBrandAddViewCell.h"
#import "YYConnAddViewController.h"
@interface YYBrandTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong)YYPageInfoModel *currentPageInfo;
@property (nonatomic,strong) UIView *noDataView;

@property (nonatomic,strong) NSMutableArray *brandListArray;
@end

@implementation YYBrandTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.alwaysBounceVertical = YES;
    [self addHeader];
    [self addFooter];

    self.noDataView = addNoDataView_phone(self.view,[NSString stringWithFormat:@"%@|icon|nobrand_icon|192|135",NSLocalizedString(@"您还未邀请任何品牌哦~",nil)],nil,nil);
    self.noDataView.hidden = YES;
    
    if ([YYCurrentNetworkSpace isNetwork]) {
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        UIView *superView = appDelegate.window.rootViewController.view;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self loadDataByPageIndex:1 endRefreshing:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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
    
    if (!self.brandListArray || [self.brandListArray count ]==0) {
        self.noDataView.hidden = NO;
        self.collectionView.scrollEnabled = NO;
    }else{
        self.noDataView.hidden = YES;
        self.collectionView.scrollEnabled = YES;
    }
}

- (void)loadDataByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    WeakSelf(ws);
    __block BOOL blockEndrefreshing =endrefreshing;
    [YYConnApi getConnBrands:_currentListType andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYConnBrandInfoListModel *listModel, NSError *error) {
        if (rspStatusAndMessage.status == kCode100){
            ws.currentPageInfo = listModel.pageInfo;
            if( !ws.currentPageInfo || ws.currentPageInfo.isFirstPage){
                ws.brandListArray =  [[NSMutableArray alloc] init];//;
            }
            [ws.brandListArray addObjectsFromArray:listModel.result];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [ws reloadCollectionViewData:blockEndrefreshing];
        });
        
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        UIView *superView = appDelegate.window.rootViewController.view;
        
        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        
        if (rspStatusAndMessage.status != kCode100) {
            [YYToast showToastWithTitle:rspStatusAndMessage.message  andDuration:kAlertToastDuration];
        }
    }];
}

- (void)addHeader{
    WeakSelf(ws);
    // 添加下拉刷新头部控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.collectionView.mj_header endRefreshing];
            return;
        }
        [ws loadDataByPageIndex:1 endRefreshing:YES];
    }];
    self.collectionView.mj_header = header;
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
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

        if ([ws.brandListArray count] > 0
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
    return [self.brandListArray count]+1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(SCREEN_WIDTH, 80);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        static NSString* reuseIdentifier = @"YYBrandAddViewCell";
        YYBrandAddViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        //cell.delegate = self;
        [cell updateUI];
        return cell;
    }else{
        YYConnBrandInfoModel * brandInfoModel = [self.brandListArray objectAtIndex:(indexPath.row-1)];
        static NSString* reuseIdentifier = @"YYBrandViewCell";
        YYBrandViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.indexPath = indexPath;
        //cell.delegate = self;
        cell.brandInfoModel = brandInfoModel;
        [cell updateUI];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        if(self.delegate){
            [self.delegate btnClick:indexPath.row section:indexPath.section andParmas:@[@"addBrand"]];
        }
    }else{
         YYConnBrandInfoModel * brandInfoModel = [self.brandListArray objectAtIndex:(indexPath.row-1)];
        if(self.delegate && brandInfoModel){
            [self.delegate btnClick:indexPath.row section:indexPath.section andParmas:@[@"brandInfo",brandInfoModel]];
        }
    }
}


@end
