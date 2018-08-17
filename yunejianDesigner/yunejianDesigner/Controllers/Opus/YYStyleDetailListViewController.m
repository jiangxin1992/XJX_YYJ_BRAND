//
//  YYStyleDetailListViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/26.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYStyleDetailListViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYStyleDetailViewController.h"
#import "YYCartDetailViewController.h"

// 自定义视图
#import "MLInputDodger.h"
#import "MBProgressHUD.h"
#import "YYTopBarShoppingCarButton.h"
#import "YYSeriesStyleViewCell.h"
#import "YYSeriesDetailInfoViewCell.h"

// 接口
#import "YYOpusApi.h"

// 分类
#import "UIImage+YYImage.h"
#import "NSManagedObject+helper.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MJRefresh.h>

#import "YYUser.h"
#import "YYPageInfoModel.h"
#import "YYOrderInfoModel.h"
#import "YYOpusSeriesModel.h"
#import "YYOpusStyleListModel.h"
#import "YYOpusSeriesListModel.h"
#import "YYSeriesInfoDetailModel.h"
#import "YYStylesAndTotalPriceModel.h"

#import "AppDelegate.h"

static CGFloat animateDuration = 0.3;
static CGFloat searchFieldWidthDefaultConstraint = 45;
static CGFloat searchFieldWidthMaxConstraint = 200;

@interface YYStyleDetailListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *splitTopLayout;

@property (weak, nonatomic) IBOutlet UIButton *gobackButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UITextField *searchField;


@property (weak, nonatomic) IBOutlet YYTopBarShoppingCarButton *topBarShoppingCarButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchFieldWidthConstraint;

@property (nonatomic,strong) NSMutableArray *onlineOpusStyleArray;

@property (nonatomic,strong) YYPageInfoModel *currentPageInfo;

@property (nonatomic,strong) UIView *noDataView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionLayoutTopConstraints;//30
@property (weak, nonatomic) IBOutlet UIView *buyerTipView;

//修改订单
@property (nonatomic, strong) UIView *seriesview;
@property (nonatomic, strong) UIButton *allSeriesBtn;
@property (nonatomic, strong) UIScrollView *scrollV;
@property(nonatomic,assign) NSInteger seriesId;//系列ID
@property(nonatomic,strong) YYOpusSeriesModel *opusSeriesModel;

@property (nonatomic, strong) NSMutableArray *online_opusSeriesArray;//修改订单时用

@property(nonatomic,strong) YYStylesAndTotalPriceModel *stylesAndTotalPriceModel;//总数
//查询结果
@property (nonatomic) BOOL searchFlag;
@property (nonatomic,strong) NSMutableArray *searchResultArray;

//排序方式
@property (nonatomic,strong) NSString *sortType;
@property (nonatomic,strong) YYPageInfoModel *currentSearchPageInfo;

@property(nonatomic,strong) YYSeriesInfoDetailModel *seriesInfoDetailModel;
@end

@implementation YYStyleDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.splitTopLayout.constant = kStatusBarAndNavigationBarHeight;
    
    self.onlineOpusStyleArray = [[NSMutableArray alloc] initWithCapacity:0];

    self.collectionView.alwaysBounceVertical = YES;
  
    UIView *superView = self.view;
    
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor = [UIColor whiteColor];
    [superView insertSubview:tempView atIndex:0];
    __weak UIView *_weakView = superView;
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakView.mas_top).with.offset(20);
        make.left.equalTo(_weakView.mas_left);
        make.bottom.equalTo(_weakView.mas_bottom);
        make.right.equalTo(_weakView.mas_right);
    }];

    _searchField.alpha = 0.0;
    _searchFieldWidthConstraint.constant = searchFieldWidthDefaultConstraint;
    
    _searchField.layer.borderColor = [UIColor blackColor].CGColor;
    _searchField.layer.borderWidth = 1;
    _searchField.layer.cornerRadius = 15;
    _searchField.clearButtonMode = UITextFieldViewModeAlways;
    _searchField.returnKeyType = UIReturnKeySearch;
    _searchField.enablesReturnKeyAutomatically = YES;
    _searchField.delegate = self;
    
    UILabel *tipLabel = [self.view viewWithTag:10001];
    [tipLabel setAdjustsFontSizeToFitWidth:YES];
    UIImage *image = [UIImage imageNamed:@"goBack_normal"];
    [_gobackButton setImage:[image imageByApplyingAlpha:0.6] forState:UIControlStateHighlighted];
    self.topBarShoppingCarButton.isRight = NO;
    [self.topBarShoppingCarButton initButton];
    _sortType = kSORT_STYLE_CODE_DESC;
    [self updateUI];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateShoppingCarNotification:)
                                                 name:kUpdateShoppingCarNotification
                                               object:nil];
    
    [self addHeader];
    [self addFooter];
    self.noDataView = addNoDataView_phone(self.view,[NSString stringWithFormat:@"%@|icon",NSLocalizedString(@"暂无款式",nil)],nil,nil);
    self.noDataView.hidden = YES;
    
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 44.0f+5.0f;
    [self.view registerAsDodgeViewForMLInputDodger];
    searchFieldWidthMaxConstraint = SCREEN_WIDTH - 50 -50;
    if (self.isModifyOrder) {
        //修改订单的时候添加款式
        self.searchButton.hidden = NO;
        self.online_opusSeriesArray = [[NSMutableArray alloc] initWithCapacity:0];
        [self.topBarShoppingCarButton hideByWidth:YES];
        //修改NavigatioBar为订单修改所需样式
        [self updateNavUI];
        self.collectionLayoutTopConstraints.constant = 0;
        self.buyerTipView.hidden = NO;
        [self loadSeriesListForModifyOrder];
    }else{
        //正常浏览作品款式
        self.collectionLayoutTopConstraints.constant = 0;
        self.buyerTipView.hidden = YES;
        self.searchButton.hidden = NO;


        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadStyleListByPageIndex:1 queryStr:@""];
        [self loadSeriesDetailInfo];

    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //在视图出现的时候更新购物车数据
    [self updateShoppingCar];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageStyleDetailList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageStyleDetailList];
}

//加载系列系列，用于修改订单时添加款式
- (void)loadSeriesListForModifyOrder{
    if ([YYCurrentNetworkSpace isNetwork]) {
        [self loadOnlineAllSeries];
    }
}

//刷新界面
- (void)reloadCollectionViewData{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    
    [self.collectionView reloadData];
    if (self.searchResultArray != nil) {
        if ([self.searchResultArray count] == 0) {
            self.noDataView.hidden = NO;
        }else{
            self.noDataView.hidden = YES;
        }
        return;
    }
    if ([self.onlineOpusStyleArray count] == 0) {
        self.noDataView.hidden = NO;
    }else{
        self.noDataView.hidden = YES;
    }
}



- (void)updateShoppingCarNotification:(NSNotification *)note{
    [self updateShoppingCar];
}

- (void)updateShoppingCar{
    WeakSelf(ws);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            ws.stylesAndTotalPriceModel = getLocalShoppingCartStyleCount(appdelegate.cartDesignerIdArray);
            [ws.topBarShoppingCarButton updateButtonNumber:[NSString stringWithFormat:@"%i", self.stylesAndTotalPriceModel.totalStyles]];
        });
    });
}


//在线请求所有系列
- (void)loadOnlineAllSeries{
    YYUser *user = [YYUser currentUser];
    WeakSelf(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [YYOpusApi getSeriesListWithId:[user.userId intValue] pageIndex:1 pageSize:20 withDraft:@"false" andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOpusSeriesListModel *opusSeriesListModel, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode100
            && opusSeriesListModel.result
            && [opusSeriesListModel.result count] > 0) {

            [ws.online_opusSeriesArray addObjectsFromArray:opusSeriesListModel.result];

            ws.opusSeriesModel = ws.online_opusSeriesArray[0];
            ws.seriesId = [ws.opusSeriesModel.id longValue];
            [self updateNavUI];
            [ws loadStyleListByPageIndex:1 queryStr:@""];
        }else{
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        }
    }];
}

-(void)loadSeriesDetailInfo{
    WeakSelf(ws);
    [YYOpusApi getSeriesInfo:_seriesId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYSeriesInfoDetailModel *infoDetailModel, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode100){
            ws.seriesInfoDetailModel = infoDetailModel;
            [ws.collectionView reloadData];
        }
    }];
}

- (void)loadStyleListByPageIndex:(int)pageIndex queryStr:(NSString*)str{
    WeakSelf(ws);
    [YYOpusApi getConnStyleListWithDesignerId:_designerId seriesId:_seriesId orderBy:nil queryStr:str pageIndex:pageIndex pageSize:kPageSize andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOpusStyleListModel *opusStyleListModel, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode100
            && opusStyleListModel.result
            && [opusStyleListModel.result count] > 0) {
            if(ws.searchResultArray == nil){

                if (pageIndex == 1) {
                    [ws.onlineOpusStyleArray removeAllObjects];
                }
                ws.currentPageInfo = opusStyleListModel.pageInfo;

                [ws.onlineOpusStyleArray addObjectsFromArray:opusStyleListModel.result];

            }else{
                if (pageIndex == 1) {
                    [ws.searchResultArray removeAllObjects];
                }
                ws.currentSearchPageInfo = opusStyleListModel.pageInfo;

                [ws.searchResultArray addObjectsFromArray:opusStyleListModel.result];
            }
        }

        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];

        if (rspStatusAndMessage.status != YYReqStatusCode100) {
            [YYToast showToastWithTitle:rspStatusAndMessage.message  andDuration:kAlertToastDuration];
        }

        [ws reloadCollectionViewData];
    }];
}


- (void)addHeader{
    WeakSelf(ws);
    // 添加下拉刷新头部控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        if ([YYCurrentNetworkSpace isNetwork]){
            if(self.searchResultArray == nil){
                [ws loadStyleListByPageIndex:1 queryStr:@""];
            }else{
                if(![ws.searchField.text isEqualToString:@""]){
                    [ws loadStyleListByPageIndex:1 queryStr:ws.searchField.text];
                }
            }
        }else{
            [ws.collectionView.mj_header endRefreshing];
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        }
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


        if(ws.searchResultArray == nil){
            if( [ws.onlineOpusStyleArray count] > 0 && ws.currentPageInfo
               && !ws.currentPageInfo.isLastPage){
                [ws loadStyleListByPageIndex:[ws.currentPageInfo.pageIndex intValue]+1 queryStr:@""];
                return;
            }
        }else if(![ws.searchField.text isEqualToString:@""] && [ws.searchResultArray count] > 0 && ws.currentSearchPageInfo
                 && !ws.currentSearchPageInfo.isLastPage){
            [ws loadStyleListByPageIndex:[ws.currentSearchPageInfo.pageIndex intValue]+1 queryStr:ws.searchField.text];
            return;
        }

        [ws.collectionView.mj_footer endRefreshing];
    }];
}

- (void)updateUI{
    if (_opusSeriesModel) {
        NSString *seriesTitle = _opusSeriesModel.name;
        if (seriesTitle
            && [seriesTitle length] > 10) {
            seriesTitle = [seriesTitle substringToIndex:10];
        }
        NSString *tempStr = [[NSString alloc] initWithFormat:NSLocalizedString(@"最晚下单：%@",nil),getShowDateByFormatAndTimeInterval(@"yy/MM/dd",_opusSeriesModel.orderDueTime)];
        NSString *titleValue = [NSString stringWithFormat:@"%@(%@)",seriesTitle,tempStr];
        
        _titleLabel.text = titleValue;
    }
}


- (IBAction)goBackButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)shoppingCarClicked:(id)sender{
    if (self.stylesAndTotalPriceModel.totalStyles <= 0) {
        [YYToast showToastWithView:self.view title:NSLocalizedString(@"购物车暂无数据",nil)  andDuration:kAlertToastDuration];
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Order" bundle:[NSBundle mainBundle]];
    YYCartDetailViewController *cartVC = [storyboard instantiateViewControllerWithIdentifier:@"YYCartDetailViewController"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cartVC];
    nav.navigationBar.hidden = YES;
    
    WeakSelf(ws);
    [cartVC setGoBackButtonClicked:^(){
        [ws dismissViewControllerAnimated:YES completion:^{
            //刷新购物车图标数据
            [ws updateShoppingCar];
        }];
    }];
    
    [cartVC setToOrderList:^(){
        [ws dismissViewControllerAnimated:NO completion:^{
            //进入订单列表界面
            [[NSNotificationCenter defaultCenter] postNotificationName:kShowOrderListNotification object:nil];
        }];
    }];
    
    [self presentViewController:nav animated:YES completion:nil];
}


- (IBAction)searchButtonClicked:(id)sender{
    _searchField.text = nil;
    if (_searchField.alpha == 0.0) {
        _allSeriesBtn.hidden = YES;
        _searchField.alpha = 1.0;
        _searchField.transform = CGAffineTransformMakeScale(1.00f, 1.00f);
        _searchButton.alpha = 0.0;
        _searchButton.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        _searchFieldWidthConstraint.constant = searchFieldWidthMaxConstraint;
        _searchField.placeholder = NSLocalizedString(@"输入款式名称/款号/颜色搜索",nil);

        [UIView animateWithDuration:animateDuration animations:^{
            [_searchField layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_searchField becomeFirstResponder];
        }];
    }
    
}

#pragma mark -  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    if(_searchResultArray != nil){
        return [_searchResultArray count];
    }
    
    if([_onlineOpusStyleArray count] > 0){
       return [_onlineOpusStyleArray count];
        
    }
    return 0;
}

////定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {

        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
    if (_seriesInfoDetailModel == nil || self.searchResultArray != nil) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
        
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);//分别为上、左、下、右
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if(section == 0){
        return 0.1;
    }else{
        return 15;
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if (_seriesInfoDetailModel == nil || self.searchResultArray != nil) {
            return CGSizeMake(CGRectGetWidth(collectionView.frame), 0.1);

        }
        NSInteger cellheight = 247;
        return CGSizeMake(SCREEN_WIDTH-80, cellheight);
    }
    NSInteger cellWidth = (SCREEN_WIDTH-25-7)/2;
    NSInteger cellHeight =[YYSeriesStyleViewCell CellHeight:cellWidth showtax:NO];
    return CGSizeMake(cellWidth, cellHeight);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        static NSString* reuseIdentifier =@"YYSeriesDetailInfoViewCell";
        YYSeriesDetailInfoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        if(_seriesInfoDetailModel && self.searchResultArray == nil){
            cell.seriesModel = _seriesInfoDetailModel.series;
            cell.lookBookId = _seriesInfoDetailModel.lookBookId;
            cell.brandDescription = _seriesInfoDetailModel.brandDescription;
        }else{
            cell.seriesModel = nil;
            cell.lookBookId = nil;
            cell.brandDescription = @"";
        }
        WeakSelf(ws);
        cell.sortType = _sortType;
        [cell setSelectButtonClicked:^(BOOL isSelectedNow){
            if(isSelectedNow){
                ws.sortType = kSORT_STYLE_CODE_DESC;
            }else{
                ws.sortType = kSORT_STYLE_CODE;
            }

            [ws.collectionView.mj_header beginRefreshing];
            
         }];
        [cell updateUI];
        return cell;
    }
    static NSString* reuseIdentifier = @"YYSeriesStyleViewCell";
    YYSeriesStyleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if(_searchResultArray != nil && ([_searchResultArray count] > indexPath.row)){
        YYOpusStyleModel *opusStyleModel =[_searchResultArray objectAtIndex:indexPath.row];
        cell.opusStyleModel = opusStyleModel;
    }else if ([_onlineOpusStyleArray count] > indexPath.row) {
        YYOpusStyleModel *opusStyleModel = [_onlineOpusStyleArray objectAtIndex:indexPath.row];
        cell.opusStyleModel = opusStyleModel;
    }
    cell.isModifyOrder = _isModifyOrder;
    [cell updateUI];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return;
    }
    if (!self.isModifyOrder) {

        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //初始化或更新(brandName和brandLogo)购物车信息
        [appDelegate initOrUpdateShoppingCarInfo:@(_designerId)];

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Opus" bundle:[NSBundle mainBundle]];
        YYStyleDetailViewController *styleDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYStyleDetailViewController"];
        styleDetailViewController.currentIndex = indexPath.row;
        if(_searchResultArray != nil){
            styleDetailViewController.onlineOrOfflineOpusStyleArray = self.searchResultArray;
            if(self.currentSearchPageInfo == nil){
                styleDetailViewController.totalPages = [self.searchResultArray count];
            }else{
                styleDetailViewController.totalPages = [self.currentSearchPageInfo.recordTotalAmount integerValue];
            }
            styleDetailViewController.opusSeriesModel = self.opusSeriesModel;
        }else if([_onlineOpusStyleArray count] > 0){
            styleDetailViewController.onlineOrOfflineOpusStyleArray = self.onlineOpusStyleArray;
             styleDetailViewController.totalPages = [self.currentPageInfo.recordTotalAmount integerValue];
            styleDetailViewController.opusSeriesModel = self.opusSeriesModel;
        }

        [self.navigationController pushViewController:styleDetailViewController animated:YES];
    }
}

#pragma mark -  UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        _searchFlag = YES;
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

    if(_searchFlag){
        _searchFlag = NO;
         self.searchResultArray = [[NSMutableArray alloc] init];
        _currentSearchPageInfo = nil;
        if(![textField.text isEqualToString:@""]){

        [self loadStyleListByPageIndex:1 queryStr:textField.text];
          
        }
    }else{
        if(![textField.text isEqualToString:@""]){
            textField.text = nil;
            [self keyboardWillHide:nil];
        }
        self.searchResultArray = nil;
    }
    [self reloadCollectionViewData];
}


#pragma mark - 修改订单部分

- (void)updateNavUI{
    WeakSelf(ws);
    if(self.allSeriesBtn == nil){
    self.allSeriesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.allSeriesBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.allSeriesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [self.allSeriesBtn addTarget:self action:@selector(showsAllSeries:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.allSeriesBtn];
    [self.allSeriesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.and.left.and.right.equalTo(ws.titleLabel);
    }];
    }
    self.titleLabel.hidden = YES;
    
    NSString *currentSeriesName = @"";
    
    if ([self.online_opusSeriesArray count] > 0){
        currentSeriesName = self.opusSeriesModel.name;
    }
    //动态更新按钮标题
    [self.allSeriesBtn setTitle:@"    " forState:UIControlStateNormal];
    [self.allSeriesBtn setImage:nil forState:UIControlStateNormal];
    if(![currentSeriesName isEqualToString:@""]){
        [self.allSeriesBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [self.allSeriesBtn setTitle:currentSeriesName forState:UIControlStateNormal];
        CGSize seriesNameTextSize =[currentSeriesName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        CGSize imageSize = [UIImage imageNamed:@"down"].size;
        float labelWidth = seriesNameTextSize.width+4;
        float imageWith = imageSize.width;
        self.allSeriesBtn.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
        self.allSeriesBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);
    }
}

- (void)showsAllSeries:(UIButton *)sender{
    WeakSelf(ws);
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.seriesview= [[UIView alloc] init];
        [self.view addSubview:self.seriesview];
        [self.seriesview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.and.left.and.right.equalTo(ws.view);
        }];
       

        self.scrollV = [self aScrollView];
        //self.scrollV.backgroundColor = [UIColor greenColor];
        [self.seriesview addSubview:_scrollV];
        [_scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.seriesview.mas_top).with.offset(kStatusBarAndNavigationBarHeight);
            make.centerX.equalTo(ws.seriesview);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(300);
        }];
        
    }else{
        [self.seriesview removeFromSuperview];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.allSeriesBtn.selected = NO;
    [self.seriesview removeFromSuperview];
}

- (UIScrollView *)aScrollView{
    WeakSelf(ws);
    self.scrollV = [[UIScrollView alloc] init];
    _scrollV.backgroundColor = [UIColor whiteColor];
    
    long seriesCount = 0;
    NSString *currentSeriesName = nil;
    NSString *currentSeriesId = nil;
    if ([self.online_opusSeriesArray count] > 0){
        seriesCount = self.online_opusSeriesArray.count;
        currentSeriesName = self.opusSeriesModel.name;
        currentSeriesId = [self.opusSeriesModel.id stringValue];
    }
    NSInteger rowHeight = 44;
    NSInteger tableHeight = 200;
    _scrollV.contentSize = CGSizeMake(0, seriesCount * rowHeight);
    for (int i = 0; i < seriesCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *nowSeriesName = nil;
        NSString *nowSeriesId = nil;
        if([self.online_opusSeriesArray count] > i){
            YYOpusSeriesModel *opusSeriesMod = self.online_opusSeriesArray[i];
            nowSeriesName = opusSeriesMod.name;
            nowSeriesId = [opusSeriesMod.id stringValue];
        }
        [btn setTitle:nowSeriesName forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        btn.titleLabel.numberOfLines = 2;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        btn.tag = 100 * i;
        
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        if ([nowSeriesId isEqualToString:currentSeriesId]) {
            btn.enabled = NO;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor blackColor]];
        }
        
        [btn addTarget:self action:@selector(swithSeries:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"black"] forState:UIControlStateHighlighted];
        _scrollV.layer.borderWidth = 4;
        _scrollV.layer.borderColor = [UIColor blackColor].CGColor;
        [_scrollV addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.scrollV);
            make.top.mas_equalTo(i * rowHeight);
            make.width.mas_equalTo(tableHeight);
            make.height.mas_equalTo(rowHeight-1);
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor blackColor];
        [_scrollV addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ws.scrollV);
            make.top.mas_equalTo(i * rowHeight+rowHeight-1);
            make.width.mas_equalTo(tableHeight);
            make.height.mas_equalTo(1);
        }];
    }
    return _scrollV;
}

#pragma mark - 修改订单部分
- (void)swithSeries:(UIButton *)sender{
    long index = sender.tag / 100;
    
    if ([self.online_opusSeriesArray count] > 0){
        YYOpusSeriesModel *opusSeriesModel = _online_opusSeriesArray[index];
        self.opusSeriesModel = opusSeriesModel;
        self.seriesId = [_opusSeriesModel.id longValue];
        self.designerId = [_opusSeriesModel.designerId longValue];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadStyleListByPageIndex:1 queryStr:@""];
        
    }
    [self updateNavUI];
    self.allSeriesBtn.selected = NO;
    [self.seriesview removeFromSuperview];
}

#pragma mark - 添加按钮进入订单弹窗
- (IBAction)addOrderAction:(id)sender forEvent:(UIEvent *)event {
    NSSet *touchSets = [event allTouches];
    UITouch *touch = [touchSets anyObject];
    CGPoint currentPoint = [touch locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:currentPoint];

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSInteger moneyType = -1;
    
    YYOpusStyleModel *opusStyleModel = (self.searchResultArray == nil?self.onlineOpusStyleArray[indexPath.row]:self.searchResultArray[indexPath.row]);
    if (opusStyleModel) {
        moneyType = [opusStyleModel.curType integerValue];
    }
    NSInteger orderMoneyType = -1;
    if(appDelegate.orderModel == nil){
        orderMoneyType = -1;
    }else{
        orderMoneyType = [appDelegate.orderModel.curType integerValue];
    }
    
    if(orderMoneyType > -1 && moneyType != orderMoneyType){
        [YYToast showToastWithView:self.view title:NSLocalizedString(@"订单中存在其他币种的款式，不能将此款式加入当前订单。",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    
    UIView *superView = self.view;
    [appDelegate showShoppingView:YES styleInfoModel:nil seriesModel:_opusSeriesModel opusStyleModel:opusStyleModel parentView:superView fromBrandSeriesView:NO WithBlock:nil];
}
#pragma mark - Other

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 键盘隐藏
- (void)keyboardWillHide:(NSNotification *)note
{
    if (_searchField.text == nil
        || [_searchField.text length] == 0) {
        _searchFieldWidthConstraint.constant = searchFieldWidthDefaultConstraint;
        _searchField.placeholder = nil;
        
        [UIView animateWithDuration:animateDuration animations:^{
            [_searchField layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_searchField resignFirstResponder];
            
            [UIView animateWithDuration:animateDuration animations:^{
                _searchField.alpha = 0.0;
                _searchField.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:animateDuration animations:^{
                    _searchButton.alpha = 1.0;
                    _searchButton.transform = CGAffineTransformMakeScale(1.00f, 1.00f);
                    _allSeriesBtn.hidden = NO;
                }];
            }];
        }];
    }
}

@end
