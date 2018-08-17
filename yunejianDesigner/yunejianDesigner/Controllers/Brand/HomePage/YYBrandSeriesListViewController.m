//
//  YYBrandSeriesListViewController.m
//  Yunejian
//
//  Created by Apple on 15/12/4.
//  Copyright © 2015年 yyj. All rights reserved.
//
#import "YYBrandSeriesViewController.h"

#import "YYBrandSeriesListViewController.h"
#import "YYSeriesListViewCell.h"
#import "YYBrandIntroductionViewCell.h"
#import "YYBrandPicsViewCell.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "YYNavigationBarViewController.h"
#import "YYOpusApi.h"
#import "YYUserApi.h"
#import <MJRefresh.h>
#import "YYMenuPopView.h"
#import "YYConnApi.h"
#import "YYUser.h"
#import "AppDelegate.h"
#import "DTKDropdownMenuView.h"
#import "YYYellowPanelManage.h"

@interface YYBrandSeriesListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@property (strong, nonatomic) YYNavigationBarViewController *navigationBarViewController;
@property (nonatomic,strong) NSMutableArray *seriesArray;
@property (nonatomic,strong) YYHomePageModel *homePageModel;
@property (nonatomic,strong) YYIndexPicsModel *picsModel;
@end

@implementation YYBrandSeriesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    self.navigationBarViewController = navigationBarViewController;
    navigationBarViewController.nowTitle = @"";
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
            if(ws.selectedValue){
                ws.selectedValue(@[@(_isConnStatus)]);
            }
            [ws.navigationController popViewControllerAnimated:YES];
            blockVc = nil;
        }
    }];
    _topBtn.hidden = YES;
//    if(_isConnStatus == kConnStatus1){
//        [_topBtn setImage:[UIImage imageNamed:@"topmore_icon"] forState:UIControlStateNormal];
//    }else{
//        [_topBtn setImage:[UIImage imageNamed:@"addbrand_icon"] forState:UIControlStateNormal];
//    }
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    [self addHeader];
    [self loadBrandInfo];
    [self loadBrandPics];
    [self loadAllSeries];
}

- (void)addHeader{
    WeakSelf(ws);
    // 添加下拉刷新头部控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态就会回调这个Block
        //[weakSelf loadDataByPageIndex:1 queryStr:@""];
        if ([YYCurrentNetworkSpace isNetwork]){
            [ws loadBrandInfo];
            [ws loadBrandPics];
            [ws loadAllSeries];
        }else{
            [ws.collectionView.mj_header endRefreshing];
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        }
    }];
    self.collectionView.mj_header = header;
    self.collectionView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}

-(void)dealloc{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

- (IBAction)topBtnHandler:(id)sender {
    if(_isConnStatus == kConnStatus1){
        [self showMenuUI:nil];
    }else{
        WeakSelf(ws);
        if(_designerId ){
            if(_isConnStatus == kConnStatus0 || _isConnStatus == kConnStatus){
                if(_isConnStatus == kConnStatus){
                    [YYConnApi invite:_designerId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                        if(rspStatusAndMessage.status == kCode100){
                            ws.isConnStatus = kConnStatus0;
                            [ws.topBtn setImage:[UIImage imageNamed:@"addbrand_icon"] forState:UIControlStateNormal];
                            [ws.collectionView reloadData];
                        }
                        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                    }];
                }else{
                
                CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"取消对此品牌的合作邀请吗？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"继续邀请",nil) otherButtonTitles:@[NSLocalizedString(@"取消邀请",nil)]];
                alertView.specialParentView = self.view;
                [alertView setAlertViewBlock:^(NSInteger selectedIndex){
                    if(selectedIndex == 1 && _isConnStatus == kConnStatus0){
                        [ws oprateConnWithDesigner:_designerId status:4];
                    }
                }];
                [alertView show];
                }
            }else if (_isConnStatus == kConnStatus2){
                CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确定品牌的合作邀请吗？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"同意邀请",nil) otherButtonTitles:@[NSLocalizedString(@"拒绝邀请",nil)]];
                alertView.specialParentView = self.view;
                [alertView setAlertViewBlock:^(NSInteger selectedIndex){
                    if (selectedIndex == 1) {
                        [ws oprateConnWithDesigner:_designerId status:2];
                    }else if(selectedIndex == 0 ){
                        [ws oprateConnWithDesigner:_designerId status:1];
                    }
                }];
                [alertView show];
            }
        }
    }
}

#pragma menu
//- (void)addMenuBtn
//{
//    __weak typeof(self) weakSelf = self;
//    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"全部删除" iconName:@"menu_delete" callBack:^(NSUInteger index, id info) {
//
//    }];
//    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"全部开始" iconName:@"menu_download" callBack:^(NSUInteger index, id info) {
//    }];
//    DTKDropdownItem *item2 = [DTKDropdownItem itemWithTitle:@"全部暂停" iconName:@"menu_pause" callBack:^(NSUInteger index, id info) {
//    }];
//    
//    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 44.f, 44.f) dropdownItems:@[item0,item1,item2] icon:@"more"];
//    
//    menuView.dropWidth = 130.f;
//    menuView.titleFont = [UIFont systemFontOfSize:15.f];
//    menuView.textColor = GLOBLE_GRAY_COLOR_3;
//    menuView.textFont = [UIFont systemFontOfSize:13.f];
//    menuView.cellSeparatorColor = UI_RGBA(229.f, 229.f, 229.f,1);
//    menuView.textFont = [UIFont systemFontOfSize:15.f];
//    menuView.animationDuration = 0.2f;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
//}

-(void)showMenuUI:(id)sender{
    NSInteger menuUIWidth = 137;
    NSInteger menuUIHeight = 116;
    NSArray *menuData;
    NSArray *menuIconData;

    menuData = @[NSLocalizedString(@"联系品牌",nil),NSLocalizedString(@"解除合作",nil)];
    menuIconData = @[@"",@""];
     
    CGPoint p = [self.topBtn convertPoint:CGPointMake(CGRectGetWidth(self.topBtn.frame), CGRectGetHeight(self.topBtn.frame)) toView:self.view];
    WeakSelf(ws);
    [YYMenuPopView addPellTableViewSelectWithWindowFrame:CGRectMake(p.x-menuUIWidth+5, p.y, menuUIWidth, menuUIHeight) selectData:menuData images:menuIconData action:^(NSInteger index) {
        if(index > -1)
        [ws menuBtnHandler:index];
    } animated:YES arrowImage:YES  arrowPositionInfo:nil];
}

-(void)menuBtnHandler:(NSInteger)index{
    NSInteger type = index+1;
     WeakSelf(ws);
    if(type == 1){
        [[YYYellowPanelManage instance] showBrandInfoView:_homePageModel orderCode:nil designerId:0];
    }else if(type == 2){
        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"解除合作关系吗？",nil) message:NSLocalizedString(@"与品牌解除合作后，将不能浏览该品牌作品",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"继续合作_no",nil) otherButtonTitles:@[NSLocalizedString(@"解除合作_yes",nil)]];
        alertView.specialParentView = self.view;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                [ws oprateConnWithDesigner:_designerId status:3];
            }
        }];
        [alertView show];
    }
}

// 1->同意邀请	2->拒绝邀请	3->移除合作 4取消邀请
- (void)oprateConnWithDesigner:(NSInteger)designerId status:(NSInteger)status{
    WeakSelf(ws);
    __block NSInteger blockStatus = status;
    [YYConnApi OprateConnWithDesignerBrand:designerId status:status andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            if(blockStatus == 2 || blockStatus == 3 || blockStatus == 4){
                ws.isConnStatus = kConnStatus;
                [ws.topBtn setImage:[UIImage imageNamed:@"addbrand_icon"] forState:UIControlStateNormal];
            }else{
                ws.isConnStatus = kConnStatus1;//
                [ws.topBtn setImage:[UIImage imageNamed:@"topmore_icon"] forState:UIControlStateNormal];
            }
            [ws.collectionView reloadData];
        }
        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];

    }];
}



//加载系列系列，
- (void)loadAllSeries{
    WeakSelf(ws);
    [YYOpusApi getConnSeriesListWithId:(int)_designerId pageIndex:1 pageSize:20 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOpusSeriesListModel *opusSeriesListModel, NSError *error) {
        if (rspStatusAndMessage.status == kCode100
            && opusSeriesListModel.result
            && [opusSeriesListModel.result count] > 0) {
            ws.seriesArray = [[NSMutableArray alloc] init];
            [ws.seriesArray addObjectsFromArray:opusSeriesListModel.result];
        }
        [ws.collectionView.mj_header endRefreshing];
        [ws.collectionView reloadData];
    }];
}
//加载品牌信息
- (void)loadBrandInfo{
    WeakSelf(ws);
    [YYUserApi getHomePageBrandInfo:_designerId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYHomePageModel *homePageModel, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            ws.homePageModel = homePageModel;
            ws.isConnStatus = [homePageModel.connectStatus integerValue];
            ws.navigationBarViewController.nowTitle = homePageModel.brandIntroduction.brandName;
            [ws.navigationBarViewController updateUI];
        }
        [ws.collectionView reloadData];
    }];
}
//加载品牌图片集
-(void)loadBrandPics{
    WeakSelf(ws);
    [YYUserApi getHomePagePics:_designerId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYIndexPicsModel *picsModel, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            ws.picsModel = picsModel;
        }
    }];
    [ws.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return 2;
    }else{
        return [self.seriesArray count];
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(section == 0){
        return UIEdgeInsetsZero;
    }else{
        return UIEdgeInsetsMake(20, 12, 0, 12);//分别为上、左、下、右
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if(section == 0){
        return 0.1;
    }else{
        return 20;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){//
        if(indexPath.row == 0){
            return CGSizeMake(SCREEN_WIDTH,[YYBrandPicsViewCell HeightForCell:SCREEN_WIDTH]);
        }else{
            NSString *descStr = (_homePageModel?_homePageModel.brandIntroduction.brandIntroduction:@"");
            return CGSizeMake(SCREEN_WIDTH, [YYBrandIntroductionViewCell HeightForCell:descStr]);
        }
    }else{
        NSInteger cellWidth = (SCREEN_WIDTH-25-10)/2;
        NSInteger cellHeight =295 - (215-cellWidth);
        return CGSizeMake(cellWidth, cellHeight);
    }

}

-(void)dealConnHandler:(id)sender{
    if(self.isConnStatus == kConnStatus1){
        [self menuBtnHandler:1];
    }else{
        [self topBtnHandler:nil];
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            static NSString* reuseIdentifier = @"YYBrandPicsViewCell";
            YYBrandPicsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            cell.logoPath = (_homePageModel?_homePageModel.logo:@"");
            cell.brandName = (_homePageModel?_homePageModel.brandIntroduction.brandName:@"");
            cell.pics = _picsModel.result;
            if(self.isConnStatus == kConnStatus1){
                [cell.connStatusImg setBackgroundColor:[UIColor colorWithHex:@"58c776"]];
                [cell.connStatusImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cell.connStatusImg setTitle:NSLocalizedString(@"已经合作",nil) forState:UIControlStateNormal];
                [cell.connStatusImg setImage:[UIImage imageNamed:@"brandconn_icon"] forState:UIControlStateNormal];
                cell.connStatusImg.layer.borderWidth = 1;
                cell.connStatusImg.layer.borderColor = [UIColor colorWithHex:@"58c776"].CGColor;
                cell.connStatusImg.layer.cornerRadius = 2.5;
                cell.connStatusImg.layer.masksToBounds = YES;
            }else if(self.isConnStatus == kConnStatus0 || self.isConnStatus == kConnStatus2){
                [cell.connStatusImg setBackgroundColor:[UIColor colorWithHex:@"FFFFFF"]];
                [cell.connStatusImg setTitleColor:[UIColor colorWithHex:@"58c776"] forState:UIControlStateNormal];
                [cell.connStatusImg setTitle:NSLocalizedString(@"已经邀请",nil) forState:UIControlStateNormal];
                [cell.connStatusImg setImage:[UIImage imageNamed:@"brandwait_icon"] forState:UIControlStateNormal];
                cell.connStatusImg.layer.borderWidth = 1;
                cell.connStatusImg.layer.borderColor = [UIColor colorWithHex:@"58c776"].CGColor;
                cell.connStatusImg.layer.cornerRadius = 2.5;
                cell.connStatusImg.layer.masksToBounds = YES;
            }else{
                [cell.connStatusImg setBackgroundColor:[UIColor colorWithHex:@"FFFFFF"]];
                [cell.connStatusImg setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
                [cell.connStatusImg setTitle:NSLocalizedString(@"添加品牌",nil) forState:UIControlStateNormal];
                [cell.connStatusImg setImage:[UIImage imageNamed:@"brandadd_icon"] forState:UIControlStateNormal];
                cell.connStatusImg.layer.borderWidth = 1;
                cell.connStatusImg.layer.borderColor = [UIColor colorWithHex:@"000000"].CGColor;
                cell.connStatusImg.layer.cornerRadius = 2.5;
                cell.connStatusImg.layer.masksToBounds = YES;
            }
            [cell.connStatusImg addTarget:self action:@selector(dealConnHandler:) forControlEvents:UIControlEventTouchUpInside];
            [cell updateUI];
            return cell;
        }else{
            static NSString* reuseIdentifier = @"YYBrandIntroductionViewCell";
            YYBrandIntroductionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            cell.descStr = (_homePageModel?_homePageModel.brandIntroduction.brandIntroduction:@"");
            [cell updateUI];
            return cell;
        }
    }else{
        YYOpusSeriesModel *seriesModel = [self.seriesArray objectAtIndex:indexPath.row];
        static NSString* reuseIdentifier = @"YYSeriesListViewCell";
        YYSeriesListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        NSInteger cellWidth = (SCREEN_WIDTH-25-10)/2;
        [cell.coverImageView setConstraintConstant:cellWidth forAttribute:NSLayoutAttributeHeight];
        cell.seriesModel = seriesModel;
        [cell updateUI];
        return cell;
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section != 0){
        YYOpusSeriesModel *seriesModel = [self.seriesArray objectAtIndex:indexPath.row];
        if(seriesModel){
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appdelegate showSeriesInfoViewController:seriesModel.designerId seriesId:seriesModel.id parentViewController:self];
        }
    }
}

@end
