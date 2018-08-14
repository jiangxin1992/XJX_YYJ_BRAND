//
//  YYBrandHomePageViewController.m
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYBrandHomePageViewController.h"

#import <MessageUI/MFMailComposeViewController.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

#import "YYNavigationBarViewController.h"
#import "YYBrandModifyInfoViewController.h"
#import "YYMessageDetailViewController.h"

#import "YYBrandInfoHeadViewNew.h"
#import "YYBrandInfoContactCell.h"
#import "YYBrandInfoAboutCell.h"
#import "YYBrandInfoSeriesCell.h"
#import "YYBrandInfoAboutContactCell.h"
#import "YYTypeButton.h"

#import "regular.h"
#import "YYBuyerInfoTool.h"
#import <MJRefresh.h>
#import "YYUser.h"
#import "YYOpusSeriesModel.h"
#import "YYBrandHomeInfoModel.h"
#import "YYUserApi.h"
#import "MBProgressHUD.h"
#import "YYConnApi.h"
#import "YYOpusApi.h"
#import "SCGIFImageView.h"
#import "YYZbarCodeView.h"
#import "YYNavView.h"
#import "AppDelegate.h"
#import "YYOpusSeriesListModel.h"
#import "YYMenuPopView.h"
#import "SCLoopScrollView.h"

@interface YYBrandHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

@property (nonatomic,strong) UIButton *operationBtn;

@property (nonatomic, strong) YYBrandInfoHeadViewNew *headView;
@property (nonatomic, strong) YYBrandHomeInfoModel *homeInfoModel;

@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic, strong) UITableView *tableview;

//@property (nonatomic, strong) UIView *editReadView;//编辑按钮new  已去除  在版本（19）中体现
//@property (nonatomic, strong) UIImageView *editTechImg;//买手主页 新手引导页  已去除  在版本（19）中体现

@property (nonatomic, strong) YYNavView *navView;

@property (nonatomic, assign) CGFloat aboutHeight;
@property (nonatomic, assign) CGFloat contactHeight;
@property (nonatomic, assign) CGFloat seriesHeight;

@property (nonatomic,strong) NSMutableArray *seriesArray;

@end

@implementation YYBrandHomePageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
    [self RequestData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageBrandHomePage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageBrandHomePage];
}

-(instancetype)initWithBlock:(void (^)(NSString *,NSNumber *connectStatus))block
{
    self=[super init];
    if(self)
    {
        _block=block;
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData
{
    _aboutHeight = 0;
    _contactHeight = 0;
    _seriesHeight = 0;
    _currentPage = 0;
    _pageIndex = 1;
    _seriesArray = [[NSMutableArray alloc] init];
}

-(void)PrepareUI{
    self.view.backgroundColor = [UIColor colorWithHex:kDefaultBGColor];
}

#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateTableView];
    [self addHeader];
    [self addFooter];
    [self setFooterState];
    [self CreateNavView];
}

-(void)CreateTableView
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableview];
    //    消除分割线
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kIPhoneX?(kStatusBarHeight):(-20));
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop).with.offset(0);
    }];
}
-(void)addHeader{
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        ws.pageIndex = 1;
        [ws RequestData];
    }];
    self.tableview.mj_header = header;
    self.tableview.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}
-(void)addFooter{
    WeakSelf(ws);
    self.tableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        ws.pageIndex += 1;
        [ws loadAllSeries];
    }];
}
-(void)CreateNavView{
    
    _navView = [[YYNavView alloc] initWithTitle:_previousTitle WithSuperView:self.view haveStatusView:NO];
    _navView.hidden = YES;
    
    _operationBtn = [UIButton getCustomImgBtnWithImageStr:@"operation_circle_icon" WithSelectedImageStr:nil];
    [self.view addSubview:_operationBtn];
    [_operationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(36);
        make.right.mas_equalTo(-7);
        make.top.mas_equalTo(kStatusBarHeight);
    }];
    [_operationBtn setAdjustsImageWhenHighlighted:NO];
    _operationBtn.hidden = YES;
    [_operationBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn = [UIButton getCustomImgBtnWithImageStr:@"topback_circle_icon" WithSelectedImageStr:nil];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(36);
        make.left.mas_equalTo(7);
        make.top.mas_equalTo(kStatusBarHeight);
    }];
    [backBtn setAdjustsImageWhenHighlighted:NO];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - RequestData
-(void)RequestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeakSelf(ws);
    NSString *designerID = _isHomePage?@"":[[NSString alloc] initWithFormat:@"%ld",_designerId];
    [YYUserApi getDesignerHomeInfo:designerID andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYBrandHomeInfoModel *infoModel, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            
            ws.homeInfoModel = infoModel;
            
            if(ws.isHomePage || (ws.homeInfoModel && [ws.homeInfoModel.connectStatus integerValue] == YYUserConnStatusConnected)){
                _operationBtn.hidden = NO;
            }else{
                _operationBtn.hidden = YES;
            }
            
            _aboutHeight = [YYBrandInfoAboutCell getHeightWithHomeInfoModel:_homeInfoModel];
            _contactHeight = [YYBrandInfoContactCell getHeightWithHomeInfoModel:_homeInfoModel IsHomePage:_isHomePage];
            
            [ws loadAllSeries];
            
        }else{
            [_tableview.mj_header endRefreshing];
            [_tableview.mj_footer endRefreshing];
            [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
- (void)loadAllSeries{
    WeakSelf(ws);
    [YYOpusApi getBrandSeriesListWithPageIndex:(int)_pageIndex pageSize:20 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYOpusSeriesListModel *opusSeriesListModel, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode100
            && opusSeriesListModel.result) {
            
            if(opusSeriesListModel.result.count)
            {
                if(_pageIndex==1)
                {
                    [ws.seriesArray removeAllObjects];//删除所有数据
                }
                [ws.seriesArray addObjectsFromArray:opusSeriesListModel.result];
            }else
            {
                if(_pageIndex==1)
                {
                    [ws.seriesArray removeAllObjects];//删除所有数据
                }else
                {
                    _pageIndex--;
                }
            }
            _seriesHeight = [YYBrandInfoSeriesCell getHeightWithHomeSeriesArray:_seriesArray];
        }
        [_tableview.mj_header endRefreshing];
        [_tableview.mj_footer endRefreshing];
        [ws updateUI];
//        [self showNewTechView];
    }];
}
#pragma mark - updateUI
-(void)updateUI
{

    if(!_headView)
    {
        _headView = [[YYBrandInfoHeadViewNew alloc] initWithHomeInfoModel:_homeInfoModel WithBlock:^(NSString *type ,NSInteger index) {
            if([type isEqualToString:@"switch"])
            {
                //切换
                _currentPage = index;
                if(index==1)
                {
                    _tableview.backgroundColor = _define_white_color;
                }else
                {
                    _tableview.backgroundColor = [UIColor colorWithHex:@"EFEFEF"];
                }
                [self setFooterState];
                [_tableview reloadData];
            }else if([type isEqualToString:@"oprate"])
            {
                [self showOprateView];
            }else if([type isEqualToString:@"show_pics"]){
                [self showLookBookPics];
            }
        }];
        
    }
    _aboutHeight = [YYBrandInfoAboutCell getHeightWithHomeInfoModel:_homeInfoModel];
    _contactHeight = [YYBrandInfoContactCell getHeightWithHomeInfoModel:_homeInfoModel IsHomePage:_isHomePage];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 190 + (_isHomePage?76:120) + 11 + 50);
    _headView.frame = rect;
    _headView.isHomePage = _isHomePage;
    _headView.infoModel = self.homeInfoModel;
    _tableview.tableHeaderView = _headView;
    [_headView SetData];
    [_tableview reloadData];
}
#pragma mark - TableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_homeInfoModel){
        return 0;
    }
    if(_currentPage == 0)
    {
        _tableview.backgroundColor = [UIColor colorWithHex:@"EFEFEF"];
        return _seriesHeight;
    }else if(_currentPage==1)
    {
        CGFloat buyerInfoHeight = [self getBuyerInfoHeight];
        if(buyerInfoHeight == 250){
            _tableview.backgroundColor = [UIColor colorWithHex:@"EFEFEF"];
        }else{
            _tableview.backgroundColor = _define_white_color;
        }
        return buyerInfoHeight;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_homeInfoModel){
        static NSString *cellid=@"cellid";
        UITableViewCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell)
        {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if(_currentPage==1)
    {
        //获取到数据以后
        static NSString *cellid=@"YYBuyerInfoAboutContactCell";
        YYBrandInfoAboutContactCell *cell = [_tableview dequeueReusableCellWithIdentifier:cellid];
        if(!cell){
            cell=[[YYBrandInfoAboutContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type, CGFloat height,YYTypeButton *typeButton) {
                if([type isEqualToString:@"openPancrase"])
                {
                    clickWebUrl_phone(_homeInfoModel.webUrl);
                }else if([type isEqualToString:@"social"])
                {
                    [self socialAction:typeButton];
                }else if([type isEqualToString:@"contact"])
                {
                    [self contactAction:typeButton];
                }
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.isHomePage = _isHomePage;
        cell.aboutHeight = _aboutHeight;
        cell.contactHeight = _contactHeight;
        cell.homePageModel = _homeInfoModel;
        return cell;
        
    }
    static NSString *cellid=@"YYDesignerInfoSeriesView";
    YYBrandInfoSeriesCell *cell=[_tableview dequeueReusableCellWithIdentifier:cellid];
    if(!cell)
    {
        
        cell=[[YYBrandInfoSeriesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid WithBlock:^(NSString *type, NSInteger idx) {
            if([type isEqualToString:@"cardClick"])
            {
                YYOpusSeriesModel *seriesModel = _seriesArray[idx];
                if(seriesModel){
                    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [appdelegate showSeriesInfoViewController:seriesModel.designerId seriesId:seriesModel.id parentViewController:self];
                }
            }
        }];
    }
    cell.isHomePage = _isHomePage;
    cell.seriesArray = _seriesArray;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
#pragma mark - 动画相关
//导航栏的动画显示与隐藏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if(scrollView.contentOffset.y <= 125.0f){
        //消失
        if(_navView){
            [_navView setAnimationHide:YES];
        }
    }else{
        //出现
        if(_navView){
            [_navView setAnimationHide:NO];
        }
    }
}
#pragma mark - SomeAction
-(void)showLookBookPics{
    if(_homeInfoModel && [_homeInfoModel.indexPics count] > 0){
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        NSInteger count = [_homeInfoModel.indexPics count];
        for(int i = 0 ; i < count; i++){
            NSString *imageName = [_homeInfoModel.indexPics objectAtIndex:i];
            NSString *_imageRelativePath = imageName;
            NSString *imgInfo = [NSString stringWithFormat:@"%@%@|%@",_imageRelativePath,kLookBookImage,@""];
            [tmpArr addObject:imgInfo];
        }
        
        float UIWidth = SCREEN_WIDTH;
        float UIHeight = SCREEN_HEIGHT;
        
        SCLoopScrollView *scrollView = [[SCLoopScrollView alloc] initWithFrame:CGRectMake(0, 0, UIWidth, UIHeight)];
        scrollView.backgroundColor = [UIColor clearColor];
        
        if([tmpArr count] == 1){
            scrollView.images = @[[tmpArr objectAtIndex:0],[tmpArr objectAtIndex:0]];
        }else{
            scrollView.images = tmpArr;
        }
        UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(scrollView.frame)-100)/2, (CGRectGetHeight(scrollView.frame) -28-15), 100, 28)];
        pageLabel.textColor = [UIColor whiteColor];//[UIColor colorWithHex:@"0xafafafaf99"];
        pageLabel.font = [UIFont systemFontOfSize:15];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.text = [NSString stringWithFormat:@"%d / %ld",1,[tmpArr count]];
        __block UILabel *weakpageLabel = pageLabel;
        __block NSInteger blockPagecount = [tmpArr count];
        
        CMAlertView *alert = [[CMAlertView alloc] initWithViews:@[scrollView,pageLabel] imageFrame:CGRectMake(0, 0, UIWidth, UIHeight) bgClose:NO];
        __block  CMAlertView *blockalert = alert;
        [scrollView show:^(NSInteger index) {
            [blockalert OnTapBg:nil];
        } finished:^(NSInteger index) {
            if(blockPagecount == 0){
                [weakpageLabel setText:@""];
            }else{
                [weakpageLabel setText:[NSString stringWithFormat:@"%ld / %ld",MIN(blockPagecount,index+1),blockPagecount]];
            }
        }];
        [alert show];
    }
}
-(void)operationAction:(UIButton *)btn{
    
    if(_isHomePage || (_homeInfoModel && [_homeInfoModel.connectStatus integerValue] == YYUserConnStatusConnected)){
        NSInteger menuUIWidth = 137;
        NSInteger menuUIHeight = 58;
        NSArray *menuData = @[@""];
        NSArray *menuIconData = @[@""];
        
        if(_isHomePage){
            menuData = @[NSLocalizedString(@"编辑",nil)];
        }else if(_homeInfoModel && [_homeInfoModel.connectStatus integerValue] == YYUserConnStatusConnected){
            menuData = @[NSLocalizedString(@"解除合作",nil)];
        }
        
        CGPoint p = [self.operationBtn convertPoint:CGPointMake(CGRectGetWidth(self.operationBtn.frame), CGRectGetHeight(self.operationBtn.frame)) toView:self.view];
        WeakSelf(ws);
        [YYMenuPopView addPellTableViewSelectWithWindowFrame:CGRectMake(p.x-menuUIWidth, p.y, menuUIWidth, menuUIHeight) selectData:menuData images:menuIconData action:^(NSInteger index) {
            if(index > -1){
                //编辑
                //取消合作
                if(_isHomePage){
                    //编辑
                    [self editAction];
                }else if(_homeInfoModel && [_homeInfoModel.connectStatus integerValue] == YYUserConnStatusConnected){
                    
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
        } animated:YES arrowImage:YES  arrowPositionInfo:nil];
    }
}
//编辑
-(void)editAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Brand" bundle:[NSBundle mainBundle]];
    YYBrandModifyInfoViewController *buyerModifyInfoController = [storyboard instantiateViewControllerWithIdentifier:@"YYBrandModifyInfoViewController"];
    buyerModifyInfoController.homeInfoModel = _homeInfoModel;
    WeakSelf(ws);
    [buyerModifyInfoController setBlock:^(NSString * type) {
        if([type isEqualToString:@"readEdit"]){
            //            [self updateEditReadView];
            //更新编辑按钮
            if(ws.block){
                ws.block(@"reload",_homeInfoModel.connectStatus);
            }
        }
    }];
    [buyerModifyInfoController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
        [ws updateUI];
    }];
    [self.navigationController pushViewController:buyerModifyInfoController animated:YES];
}
-(void)showChatView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Message" bundle:[NSBundle mainBundle]];
    YYMessageDetailViewController *messageViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYMessageDetailViewController"];
    messageViewController.userlogo = _homeInfoModel.logoPath;
    messageViewController.userEmail = _homeInfoModel.email;
    messageViewController.userId = @(_designerId);
    messageViewController.buyerName = _homeInfoModel.brandName;
    WeakSelf(ws);
    [messageViewController setCancelButtonClicked:^(void){
        [ws.navigationController popViewControllerAnimated:YES];
        [YYMessageDetailViewController markAsRead];
    }];
    [self.navigationController pushViewController:messageViewController animated:YES];
}
-(void)showOprateView
{
    WeakSelf(ws);
    if(_homeInfoModel == nil){
        return;
    }
    if([_homeInfoModel.connectStatus integerValue] == YYUserConnStatusConnected){
        [self showChatView];
    }else{
        if(_designerId ){
            if([_homeInfoModel.connectStatus integerValue] == YYUserConnStatusInvite || [_homeInfoModel.connectStatus integerValue] == YYUserConnStatusNone){
                if([_homeInfoModel.connectStatus integerValue] == YYUserConnStatusNone){
                    [YYConnApi invite:_designerId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                        if(rspStatusAndMessage.status == YYReqStatusCode100){
                            _homeInfoModel.connectStatus = @(YYUserConnStatusInvite);
                            [_headView.oprateBtn setImage:[UIImage imageNamed:@"addbrand_icon"] forState:UIControlStateNormal];
                            [_tableview reloadData];
                            [_headView reloadData];
                            if(_block){
                                _block(@"refresh",_homeInfoModel.connectStatus);
                            }
                        }
                        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                    }];
                }else{
                    
                    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"取消对此品牌的合作邀请吗？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"继续邀请",nil) otherButtonTitles:@[NSLocalizedString(@"取消邀请",nil)]];
                    alertView.specialParentView = self.view;
                    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
                        if(selectedIndex == 1 && [_homeInfoModel.connectStatus integerValue] == YYUserConnStatusInvite){
                            [ws oprateConnWithDesigner:_designerId status:4];
                        }
                    }];
                    [alertView show];
                }
            }else if ([_homeInfoModel.connectStatus integerValue] == YYUserConnStatusBeInvited){
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
// 1->同意邀请	2->拒绝邀请	3->移除合作 4取消邀请
- (void)oprateConnWithDesigner:(NSInteger)designerId status:(NSInteger)status{
    __block NSInteger blockStatus = status;
    [YYConnApi OprateConnWithDesignerBrand:designerId status:status andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if(rspStatusAndMessage.status == YYReqStatusCode100){
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            if(blockStatus == 2 || blockStatus == 3 || blockStatus == 4){
                _homeInfoModel.connectStatus = @(YYUserConnStatusNone);
                [_headView.oprateBtn setImage:[UIImage imageNamed:@"addbrand_icon"] forState:UIControlStateNormal];
            }else{
                _homeInfoModel.connectStatus = @(YYUserConnStatusConnected);
                [_headView.oprateBtn setImage:[UIImage imageNamed:@"topmore_icon"] forState:UIControlStateNormal];
            }
            [_tableview reloadData];
            [_headView reloadData];
            if(_block){
                _block(@"refresh",_homeInfoModel.connectStatus);
            }
        }
        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        
    }];
}
//获取 YYBuyerInfoAboutContactCell 的高度
-(CGFloat )getBuyerInfoHeight{
    if(_aboutHeight > 0){
        if(_contactHeight > 0){
            return _aboutHeight + _contactHeight + 1 + 16;
        }else{
            return _aboutHeight + 16;
        }
    }else{
        if(_contactHeight > 0){
            return _contactHeight + 16;
        }else{
            return 250;
        }
    }
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setFooterState
{
    if(_currentPage == 1)
    {
        _tableview.mj_header.hidden =YES;
    }else
    {
        _tableview.mj_header.hidden = NO;
    }
}
#pragma mark - 社交账户回调
-(void)socialAction:(YYTypeButton *)typeButton
{
    if([typeButton.type isEqualToString:@"weixin"])
    {
        [self ShowWechat2Dbarcode:typeButton];
    }else
    {
        //跳转网页
        [self JumpWebsite:typeButton];
    }
}
-(void)ShowWechat2Dbarcode:(YYTypeButton *)typeButton
{
    //显示二维码
    NSString *imageUrl = nil;
    NSString *nameStr = nil;
    if([typeButton.value isKindOfClass:[YYBuyerSocialInfoModel class]]){
        imageUrl = ((YYBuyerSocialInfoModel *)typeButton.value).image;
        nameStr = ((YYBuyerSocialInfoModel *)typeButton.value).socialName;
    }else if([typeButton.value isKindOfClass:[NSDictionary class]]){
        imageUrl = [typeButton.value objectForKey:@"image"];
        nameStr = [typeButton.value objectForKey:@"socialName"];
    }
    
    YYZbarCodeView *zbarCodeView = [[YYZbarCodeView alloc] initWithImageUrl:imageUrl WithNameStr:nameStr WithSuperViewController:self];
    zbarCodeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view.window addSubview:zbarCodeView];
}
-(void)JumpWebsite:(YYTypeButton *)typeButton
{
    NSString *url = [self getUrlWithObj:typeButton.value];
    clickWebUrl_phone(url);
}
-(NSString *)getUrlWithObj:(id )value
{
    NSString *url = nil;
    if([value isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *tempdict = (NSDictionary *)value;
        url = [tempdict objectForKey:@"url"];
    }else if([value isKindOfClass:[YYBuyerSocialInfoModel class]])
    {
        YYBuyerSocialInfoModel *tempModel = (YYBuyerSocialInfoModel *)value;
        url = tempModel.url;
    }
    return url;
}
#pragma mark - 联系方式回调
-(void)contactAction:(YYTypeButton *)typeButton
{
    if([typeButton.type isEqualToString:@"phone"])
    {
        [self CallPhoneNumber:typeButton];
    }else if([typeButton.type isEqualToString:@"telephone"])
    {
        [self CallPhoneNumber:typeButton];
    }else if([typeButton.type isEqualToString:@"email"])
    {
        [self SendEmail:typeButton];
    }
}

-(void)CallPhoneNumber:(YYTypeButton *)typeButton
{
    NSString *contactValue = nil;
    NSNumber *contactType = nil;
    if([typeButton.value isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *tempdict = (NSDictionary *)typeButton.value;
        contactValue = [tempdict objectForKey:@"contactValue"];
        contactType = [tempdict objectForKey:@"contactType"];
    }else if([typeButton.value isKindOfClass:[YYBuyerContactInfoModel class]])
    {
        YYBuyerContactInfoModel *tempmodel = (YYBuyerContactInfoModel *)typeButton.value;
        contactValue = tempmodel.contactValue;
        contactType = tempmodel.contactType;
    }
    if(![NSString isNilOrEmpty:contactValue]&&contactType)
    {
        if(![YYBuyerInfoTool isNilOrEmptyWithContactValue:contactValue WithContactType:contactType])
        {
            NSString *availablePhoneNum = nil;
            if([typeButton.type isEqualToString:@"phone"])
            {
                availablePhoneNum = [YYBuyerInfoTool getAvailablePhoneNum:contactValue];
            }else if([typeButton.type isEqualToString:@"telephone"])
            {
                availablePhoneNum = [YYBuyerInfoTool getAvailableTelePhoneNum:contactValue];
            }
            
            callSomeone(availablePhoneNum,contactValue);
        }
    }
}

-(void)SendEmail:(YYTypeButton *)typeButton
{
    NSString *contactValue = nil;
    if([typeButton.value isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *tempdict = (NSDictionary *)typeButton.value;
        contactValue = [tempdict objectForKey:@"contactValue"];
    }else if([typeButton.value isKindOfClass:[YYBuyerContactInfoModel class]])
    {
        YYBuyerContactInfoModel *tempmodel = (YYBuyerContactInfoModel *)typeButton.value;
        contactValue = tempmodel.contactValue;
    }
    
    sendEmail(contactValue);

}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send cancelled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//-(void)updateEditReadView
//{
//    NSString *CFBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    if([CFBundleVersion integerValue] == 17)
//    {
//        _editReadView.hidden = [YYUser getNewsReadStateWithType:2];
//    }else
//    {
//        _editReadView.hidden = YES;
//    }
//}
//#pragma mark - 新手引导页／new相关
//-(void)showNewTechView
//{
//    if(_isHomePage)
//    {
//        NSString *CFBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//        if([CFBundleVersion integerValue] == 17)
//        {
//            if(![YYUser getNewsReadStateWithType:1])
//            {
//                NSString *imageStr = [LanguageManager isEnglishLanguage]?@"new_edit_mengban_brand_en":@"new_edit_mengban_brand";
//                _editTechImg = [UIImageView getImgWithImageStr:imageStr];
//                _editTechImg.contentMode = UIViewContentModeScaleAspectFill;
//                [self.view.window addSubview:_editTechImg];
//                _editTechImg.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//                [_editTechImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeEditTechImgAction)]];
//                [YYUser saveNewsReadStateWithType:1];
//                
//            }
//        }
//    }
//}
//-(void)closeEditTechImgAction
//{
//    [_editTechImg removeFromSuperview];
//    _editTechImg = nil;
//}
@end
