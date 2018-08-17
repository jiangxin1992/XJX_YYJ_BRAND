//
//  YYBrandAddViewController.m
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYConnAddViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"
#import "YYBrandSeriesListViewController.h"

// 自定义视图
#import "MBProgressHUD.h"
#import "YYBrandInfoViewCell.h"

// 接口
#import "YYConnApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import <MJRefresh.h>

#import "YYConnDesignerModel.h"
#import "YYOrderInfoModel.h"

#import "AppDelegate.h"
#import "UserDefaultsMacro.h"
#import "RBCollectionViewBalancedColumnLayout.h"

@interface YYConnAddViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,YYTableCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic,strong)YYPageInfoModel *currentPageInfo;
@property (nonatomic,strong) UIView *noDataView;
@property (nonatomic,strong) NSMutableArray *designerListArray;
//查询结果
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopLayoutConstraint;
@property (nonatomic,assign)BOOL isSearchView;
@property (nonatomic,copy) NSString *searchFieldStr;
@property (nonatomic,strong) NSMutableArray *searchResultArray;
@property (nonatomic,strong) YYPageInfoModel *currentSearchPageInfo;

@end

@implementation YYConnAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = NSLocalizedString(@"所有品牌",nil);
    [_containerView addSubview:navigationBarViewController.view];
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
            [[NSNotificationCenter defaultCenter] removeObserver:ws name:UIKeyboardWillHideNotification object:nil];
            
            
            if (ws.cancelButtonClicked) {
                ws.cancelButtonClicked();
            }
            [ws.navigationController popViewControllerAnimated:YES];
            blockVc = nil;
        }
    }];
    
    _searchField.delegate = self;
    _searchFieldStr = @"";

    self.collectionView.alwaysBounceVertical = YES;

    [self addHeader];
    [self addFooter];

    self.noDataView = addNoDataView_phone(self.view,nil,nil,nil);
    self.noDataView.hidden = YES;
    self.designerListArray = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadDataByPageIndex:1 queryStr:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(_isSearchView){
        return [_searchResultArray count];
    }
    return [_designerListArray count];
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);//分别为上、左、下、右
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        YYConnDesignerModel *designerModel = nil;
        if(_isSearchView && ([_searchResultArray count] > indexPath.row)){
            designerModel =[_searchResultArray objectAtIndex:indexPath.row];
        }else if ([_designerListArray count] > indexPath.row) {
            designerModel = [_designerListArray objectAtIndex:indexPath.row];
        }
        static NSString* reuseIdentifier = @"YYBrandInfoViewCell";
        YYBrandInfoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.designerModel = designerModel;
        [cell updateUI];
        return cell;
  }

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self btnClick:indexPath.row section:indexPath.section andParmas:nil];
}

#pragma YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    WeakSelf(ws);
        if(parmas == nil){
            YYConnDesignerModel *designerModel = nil;
            if(_searchResultArray != nil && ([_searchResultArray count] > row)){
                designerModel =[_searchResultArray objectAtIndex:row];
            }else if ([_designerListArray count] > row) {
                designerModel = [_designerListArray objectAtIndex:row];
            }
            
            //初始化或更新(brandName和brandLogo)购物车信息
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdelegate initOrUpdateShoppingCarInfo:designerModel.id];

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Brand" bundle:[NSBundle mainBundle]];
            YYBrandSeriesListViewController *seriesListViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYBrandSeriesListViewController"];
            seriesListViewController.designerId = [designerModel.id integerValue];
            seriesListViewController.isConnStatus = [designerModel.connectStatus integerValue];
            __block YYConnDesignerModel *blockDesignerModel = designerModel;
            [seriesListViewController setSelectedValue:^(NSArray *value){
                blockDesignerModel.connectStatus = [[NSNumber alloc] initWithInteger:[[value objectAtIndex:0] integerValue]];
                [ws.collectionView reloadData];
            }];
            [self.navigationController pushViewController:seriesListViewController animated:YES];

        }else{
            YYConnDesignerModel *designerModel = nil;
            if(_searchResultArray != nil && ([_searchResultArray count] > row)){
                designerModel =[_searchResultArray objectAtIndex:row];
            }else if ([_designerListArray count] > row) {
                designerModel = [_designerListArray objectAtIndex:row];
            }
            if(designerModel && [designerModel.connectStatus integerValue] == -1){
                __block YYConnDesignerModel *blockDesignerModel = designerModel;
                [YYConnApi invite:[blockDesignerModel.id integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                    if(rspStatusAndMessage.status == kCode100){
                        blockDesignerModel.connectStatus = 0;
                        [YYToast showToastWithTitle:NSLocalizedString(@"已向品牌发送合作邀请",nil) andDuration:kAlertToastDuration];
                        [ws.collectionView reloadData];
                    }
                }];
            }else{
                [YYToast showToastWithTitle:NSLocalizedString(@"发送送邀请，未处理",nil) andDuration:kAlertToastDuration];
            }
        }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(SCREEN_WIDTH, [YYBrandInfoViewCell HeightForCell:SCREEN_WIDTH]);
    
}

#pragma MJRefresh.h
//刷新界面
- (void)reloadCollectionViewData{
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    [self.collectionView reloadData];
    
    if (!self.designerListArray || [self.designerListArray count ]==0) {
        self.noDataView.hidden = NO;
    }else{
        self.noDataView.hidden = YES;
    }
}

//加载品牌，
- (void)loadDataByPageIndex:(int)pageIndex queryStr:(NSString*)queryStr{
    WeakSelf(ws);
        [YYConnApi queryDesignerWithQueryStr:queryStr pageIndex:pageIndex pageSize:4 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYConnDesignerListModel *designerListModel, NSError *error) {
            if (rspStatusAndMessage.status == kCode100 && designerListModel.result
                    && [designerListModel.result count] > 0) {
                if(!_isSearchView){
                    ws.currentPageInfo = designerListModel.pageInfo;
                    if (ws.currentPageInfo== nil || ws.currentPageInfo.isFirstPage) {
                        [ws.designerListArray removeAllObjects];
                    }
                    [ws.designerListArray addObjectsFromArray:designerListModel.result];
                }else{
                    ws.currentSearchPageInfo = designerListModel.pageInfo;
                    if (ws.currentSearchPageInfo == nil || ws.currentSearchPageInfo.isFirstPage) {
                        [ws.searchResultArray removeAllObjects];
                    }
                    [ws.searchResultArray addObjectsFromArray:designerListModel.result];
                }
            }
        
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
            if (rspStatusAndMessage.status != kCode100) {
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
            if(!_isSearchView){
                [ws loadDataByPageIndex:1 queryStr:@""];
            }else{
                if(![ws.searchFieldStr isEqualToString:@""]){
                    [ws loadDataByPageIndex:1 queryStr:ws.searchFieldStr];
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

        if(!_isSearchView){
            if( [ws.designerListArray count] > 0 && ws.currentPageInfo
               && !ws.currentPageInfo.isLastPage){
                [ws loadDataByPageIndex:[ws.currentPageInfo.pageIndex intValue]+1 queryStr:@""];
                return;
            }
        }else if(![_searchFieldStr isEqualToString:@""] && [ws.searchResultArray count] > 0 && ws.currentSearchPageInfo
                 && !ws.currentSearchPageInfo.isLastPage){
            [ws loadDataByPageIndex:[ws.currentSearchPageInfo.pageIndex intValue]+1 queryStr:_searchFieldStr];
            return;
        }

        [ws.collectionView.mj_footer endRefreshing];
    }];
}

#pragma search
- (IBAction)showSearchView:(id)sender {
    if (_searchView.hidden == YES) {
        _searchView.hidden = NO;
        _searchField.text = nil;
        _searchFieldStr = @"";
        _searchView.alpha = 0.0;
        _searchViewTopLayoutConstraint.constant = -44;
        self.searchResultArray = [[NSMutableArray alloc] init];
        [_searchView layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            _searchView.alpha = 1.0;
            _searchViewTopLayoutConstraint.constant = 0;
            [_searchView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_searchField becomeFirstResponder];
            _isSearchView = YES;
            _noDataView.hidden = YES;
            [_collectionView reloadData];
        }];
    }
}
- (IBAction)hideSearchView:(id)sender {
    if ( _searchView.hidden == NO) {
        _searchFieldStr = @"";
        _searchView.alpha = 1.0;
        _searchViewTopLayoutConstraint.constant = 0;
        [_searchView layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            _searchViewTopLayoutConstraint.constant = -44;
            _searchView.alpha = 0.0;
            [_searchView layoutIfNeeded];
        } completion:^(BOOL finished) {
            _searchView.hidden = YES;
           [_searchField resignFirstResponder];
            _isSearchView = NO;
            _searchResultArray = nil;
            _noDataView.hidden = YES;
            [_collectionView reloadData];
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:_searchField];
    
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    _isSearchView = YES;
    [self.collectionView reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:_searchField];
}

- (void)textFieldDidChange:(NSNotification *)note{
    NSString *toBeString = _searchField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    NSString *str = @"";
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_searchField markedTextRange];
        //高亮部分
        UITextPosition *position = [_searchField positionFromPosition:selectedRange.start offset:0];
        //已输入的文字进行字数统计和限制
        if (!position) {
            str = toBeString;
        }else{
            return ;
        }
    }
    else{
        str = toBeString;
    }
    if(![str isEqualToString:@""]){
        _searchFieldStr = str;
        _isSearchView = YES;
    }else{
        _searchFieldStr = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(![_searchFieldStr isEqualToString:@""]){
        [_searchField resignFirstResponder];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadDataByPageIndex:1 queryStr:_searchFieldStr];
        return YES;
    }
    return NO;
}

@end
