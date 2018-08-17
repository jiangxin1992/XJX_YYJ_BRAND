//
//  YYInventoryViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYInventoryViewController.h"
#import "UIImage+Tint.h"
#import "TitlePagerView.h"
#import "YYMessageButton.h"
#import "YYInventoryApi.h"
#import "AppDelegate.h"
#import "YYUser.h"
#import "MBProgressHUD.h"
#import "YYPageInfoModel.h"
#import "YYInventoryNewTipViewCell.h"
#import <MJRefresh.h>
#import "YYInventoryTableViewCell.h"
#import "YYInventoryDetailViewController.h"
#import "YYOrderHelpViewController.h"
#import "UserDefaultsMacro.h"
#import "YYMessageUnreadModel.h"

@interface YYInventoryViewController ()<UITableViewDataSource,UITableViewDelegate,YYTableCellDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic,assign)BOOL isSearchView;
@property (nonatomic,copy) NSString *searchFieldStr;

@property (weak, nonatomic) IBOutlet UIView *tabBarView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopLayoutConstraint;

@property (weak, nonatomic) IBOutlet YYMessageButton *messageButton;

@property (nonatomic,strong)YYPageInfoModel *currentPageInfo;
@property (strong, nonatomic)NSMutableArray *listArray;
@property (strong, nonatomic)NSMutableArray *localNoteArray;
@property (strong, nonatomic)NSMutableArray *searchNoteArray;//搜索历史记录

@property (nonatomic,strong) UIView *noDataView;
@property(nonatomic,assign) NSInteger currentType;
@end

@implementation YYInventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _searchField.delegate = self;
    _searchFieldStr = @"";
    self.listArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [_messageButton initButton:@""];
    [self messageCountChanged:nil];
    [_messageButton addTarget:self action:@selector(messageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCountChanged:) name:UnreadMsgAmountChangeNotification object:nil];
    
    
//    self.noDataView = addNoDataView_phone(self.view,@"暂无相关数据哦~|icon|noorder_icon|166|135",nil,nil);
//    _noDataView.hidden = YES;
//    _tableView.hidden = YES;
    [self addHeader];
    [self addFooter];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate checkNoticeCount];
    [self loadListFromServerByPageIndex:1 endRefreshing:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveAction) name:kApplicationDidBecomeActive object:nil];
}
-(void)applicationDidBecomeActiveAction{
    if(!self.noDataView.hidden){
        YYUser *user = [YYUser currentUser];

        if(!((user.userType == 5 || user.userType ==6)&&![YYUser isShowroomToBrand])){
            [self headerWithRefreshingAction];
        }else{
            NSLog(@"showroom主页");
        }
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageInventory];
    
    if(!self.noDataView.hidden){
        [self headerWithRefreshingAction];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageInventory];
}

#pragma msseage
- (void)messageButtonClicked:(id)sender {
    [YYInventoryApi markAsReadOnMsg:nil adnBlock:nil];

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate showMessageView:nil parentViewController:self];
}
- (void)messageCountChanged:(NSNotification *)notification{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([YYUser isShowroomToBrand])
    {
        NSInteger msgAmount = [appDelegate.messageUnreadModel.orderAmount integerValue] + [appDelegate.messageUnreadModel.connAmount integerValue];
        if(msgAmount > 0){
            [_messageButton updateButtonNumber:[NSString stringWithFormat:@"%ld",msgAmount]];
        }else{
            [_messageButton updateButtonNumber:@""];
        }
    }else
    {
        NSInteger msgAmount = [appDelegate.messageUnreadModel.orderAmount integerValue] + [appDelegate.messageUnreadModel.connAmount integerValue] + [appDelegate.messageUnreadModel.personalMessageAmount integerValue];
        if(msgAmount > 0 || [appDelegate.messageUnreadModel.newsAmount integerValue] >0){
            if(msgAmount > 0 ){
                [_messageButton updateButtonNumber:[NSString stringWithFormat:@"%ld",(long)msgAmount]];
            }else{
                [_messageButton updateButtonNumber:@"dot"];
            }
        }else{
            [_messageButton updateButtonNumber:@""];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadListFromServerByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    WeakSelf(ws);

    __block BOOL blockEndrefreshing = endrefreshing;
    [YYInventoryApi getAllottingList:nil month:0 status:-1 pageIndex:pageIndex pageSize:8 queryStr:self.searchFieldStr andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYInventoryAllottingListModel *listModel, NSError *error) {
          if (rspStatusAndMessage.status == kCode100) {
                if (pageIndex == 1) {
                    [ws.listArray removeAllObjects];
                }
                ws.currentPageInfo = listModel.pageInfo;
        
                if (listModel && listModel.result
                        && [listModel.result count] > 0){
                    [ws.listArray addObjectsFromArray:listModel.result];
        
                }
            }
        
            [ws addSearchNote];
            if(blockEndrefreshing){
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            [ws reloadTableData];
        
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
    if(self.isSearchView){
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isSearchView){
        return [_searchNoteArray count];
    }else{
        if(section == 0){
            return 1;
        }
        if([_listArray count] > 0){
            return [_listArray count];
        }else{
            return 1;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if(self.isSearchView){
        static NSString *CellIdentifier = @"YYListSearchNoteCell";
        UITableViewCell *noteCell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(noteCell == nil){
            noteCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView *flagImg = [noteCell.contentView viewWithTag:10002];
        UIImage *img = [[UIImage imageNamed:@"searchflag_img"] imageWithTintColor:[UIColor colorWithHex:@"919191"] ];
        flagImg.image = img;
        NSArray *obj = [_searchNoteArray objectAtIndex:indexPath.row];
        UILabel *titleLabel = [noteCell.contentView viewWithTag:10001];
        titleLabel.text = [obj objectAtIndex:0];
        if(indexPath.row % 2 == 0){
            noteCell.contentView.backgroundColor = [UIColor whiteColor];
        }else{
            noteCell.contentView.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
        }
        UIButton *deleteBtn = [noteCell.contentView viewWithTag:10003];
        deleteBtn.alpha = 1000+indexPath.row;
        [deleteBtn addTarget:self action:@selector(deleteSearchNote:) forControlEvents:UIControlEventTouchUpInside];
        cell = noteCell;
    }else{
        if(indexPath.section == 0){
            NSString *CellIdentifier = @"YYInventoryNewTipViewCell";
            YYInventoryNewTipViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.indexPath = indexPath;
            cell.delegate = self;
            [cell updateUI];
            return cell;
        }else{
            if([_listArray count] > 0){//
                YYInventoryAllottingModel * allottingModel = [_listArray objectAtIndex:indexPath.row];
                NSString *CellIdentifier = @"YYInventoryTableViewCell";
                YYInventoryTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
                cell.indexPath = indexPath;
                cell.delegate = self;
                cell.allottingModel = allottingModel;
                [cell updateUI];
                return cell;
            }else{
                static NSString* reuseIdentifier = @"YYInventoryViewNullCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
                if(self.noDataView == nil){
                    self.noDataView = addNoDataView_phone(cell.contentView,[NSString stringWithFormat:@"%@|icon:noinventory_icon|40",NSLocalizedString(@"暂无买手店提交库存调拨/n库存调拨可以让商品在不同的买手店之间流动起来~",nil)],nil,nil);
                }
                cell.backgroundColor = [UIColor colorWithHex:@"f8f8f8"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isSearchView){
        return 50;
    }else{
        if(indexPath.section == 0){
            return 62;
        }
        if([_listArray count] > 0){
            return 90;
        }else{
            return SCREEN_HEIGHT-65-60 -62*2;
        }
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isSearchView){
        NSArray *obj = [_searchNoteArray objectAtIndex:indexPath.row];
        self.searchFieldStr =  [obj objectAtIndex:0];
        self.searchField.text = self.searchFieldStr;
        _isSearchView = NO;
        [self loadListFromServerByPageIndex:1 endRefreshing:NO];
    }else{

        if(indexPath.section == 1 && [_listArray count] > 0){
            WeakSelf(ws);
            YYInventoryAllottingModel * allottingModel = [_listArray objectAtIndex:indexPath.row];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Inventory" bundle:[NSBundle mainBundle]];
            YYInventoryDetailViewController *inventoryDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYInventoryDetailViewController"];
            inventoryDetailViewController.allottingModel= allottingModel;
            __block YYInventoryAllottingModel * blockallottingModel = allottingModel;
            [inventoryDetailViewController setCancelButtonClicked:^(){
                [ws.navigationController popViewControllerAnimated:YES];
                blockallottingModel.hasRead = [[NSNumber alloc] initWithInt:1];
                [ws reloadTableData];
                [YYInventoryApi markAsReadOnMsg:[blockallottingModel.msgId stringValue] adnBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                    if(rspStatusAndMessage.status == kCode100){
                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        if([appDelegate.messageUnreadModel.inventoryAmount integerValue] > 0){
                            appDelegate.messageUnreadModel.inventoryAmount = @([appDelegate.messageUnreadModel.inventoryAmount integerValue] - 1);
                            [[NSNotificationCenter defaultCenter] postNotificationName:UnreadInventoryNotifyMsgAmount object:nil userInfo:nil];
                        }
                    }
                }];
            }];
            [self.navigationController pushViewController:inventoryDetailViewController animated:YES];
        }
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.isSearchView){
        return;
    }
    
}

-(void)reloadTableData{
    [self.tableView reloadData];
}

- (void)addHeader{
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws headerWithRefreshingAction];
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}
-(void)headerWithRefreshingAction{
    if (![YYCurrentNetworkSpace isNetwork]) {
        [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        [self.tableView.mj_header endRefreshing];
        return;
    }else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate checkNoticeCount];
    }
    [self loadListFromServerByPageIndex:1 endRefreshing:YES];
}
- (void)addFooter{
    WeakSelf(ws);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        if (!ws.currentPageInfo.isLastPage) {
            [ws loadListFromServerByPageIndex:[ws.currentPageInfo.pageIndex intValue]+1 endRefreshing:YES];
        }else{
            //弹出提示
            [ws.tableView.mj_footer endRefreshing];
        }
    }];
}


#pragma YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = [parmas objectAtIndex:0];
    if([type isEqualToString:@"newHelpOrAdd"]){
        [self showHelp];
    }
}

#pragma search
- (IBAction)showSearchView:(id)sender {
    if (_searchView.hidden == YES) {
        _searchView.hidden = NO;
        _searchField.text = nil;
        _searchFieldStr = @"";
        _searchView.alpha = 0.0;
        //_searchView.transform = CGAffineTransformMakeScale(1.00f, 0.01f);
        _searchViewTopLayoutConstraint.constant = -44;
        [_searchView layoutIfNeeded];
        self.tableView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _searchView.alpha = 1.0;
            //_searchView.transform = CGAffineTransformMakeScale(1.00f, 1.00f);
            _searchViewTopLayoutConstraint.constant = 0;
            [_searchView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_searchField becomeFirstResponder];
            _isSearchView = YES;
            _tableView.hidden = NO;
           // _noDataView.hidden = YES;
            _searchNoteArray = [NSKeyedUnarchiver unarchiveObjectWithFile:getInventorySearchNoteStorePath()];
            [_tableView reloadData];
            [YYInventoryApi markAsReadOnMsg:nil adnBlock:nil];
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
            //_searchView.transform = CGAffineTransformMakeScale(1.00f, 0.01f);
            _searchViewTopLayoutConstraint.constant = -44;
            _searchView.alpha = 0.0;
            [_searchView layoutIfNeeded];
        } completion:^(BOOL finished) {
            _searchView.hidden = YES;
            [_searchField resignFirstResponder];
            _isSearchView = NO;
            _searchNoteArray = nil;
            _tableView.hidden = NO;
            [_listArray removeAllObjects];
            //_noDataView.hidden = YES;
            [self loadListFromServerByPageIndex:1 endRefreshing:NO ];
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:_searchField];
    
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    _isSearchView = YES;
    [self reloadTableData];
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
    //    NSString *str = _textNameInput.text;
    //  self.currentYYOrderInfoModel.buyerName = str;
    if(![str isEqualToString:@""]){
        _searchFieldStr = str;
        _isSearchView = YES;
        
        _localNoteArray = [NSKeyedUnarchiver unarchiveObjectWithFile:getInventorySearchNoteStorePath()];
        _searchNoteArray = [[NSMutableArray alloc] init];
        for (NSArray *note in _localNoteArray) {
            if([note[0] containsString:str]){
                [_searchNoteArray addObject:note];
            }
        }
        [self reloadTableData];
        //[self loadOrderListFromServerByPageIndex:1 endRefreshing:NO ];
    }else{
        _searchFieldStr = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(![_searchFieldStr isEqualToString:@""]){
        _isSearchView = NO;
        [_searchField resignFirstResponder];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadListFromServerByPageIndex:1 endRefreshing:NO ];
        return YES;
    }
    return NO;
}

-(void)addSearchNote{
    if(![NSString isNilOrEmpty:self.searchFieldStr]){
        if(self.localNoteArray ==nil){
            self.localNoteArray = [[NSMutableArray alloc] init];
        }
        
        BOOL isContains = YES;
        for (NSArray *note in self.localNoteArray) {
            if([note[0] isEqualToString:self.searchFieldStr]){
                isContains = NO;
                break;
            }
        }
        if(isContains){
            if([self.localNoteArray count] > 20){
                [self.localNoteArray removeObjectAtIndex:0];
            }
            [self.localNoteArray addObject:@[self.searchFieldStr,@"ordercode"]];
        }
        BOOL iskeyedarchiver= [NSKeyedArchiver archiveRootObject:self.localNoteArray toFile:getInventorySearchNoteStorePath()];
        if(iskeyedarchiver){
            NSLog(@"archive success ");
        }
    }
}

-(void)deleteSearchNote:(id)sender{
    UIButton *btn = sender;
    NSInteger row = btn.alpha - 1000;
    NSString *date = [[_searchNoteArray objectAtIndex:row] objectAtIndex:0];
    for (NSArray *note in self.localNoteArray) {
        if([note[0] isEqualToString:date]){
            [self.localNoteArray removeObject:note];
            break;
        }
    }
    BOOL iskeyedarchiver= [NSKeyedArchiver archiveRootObject:self.localNoteArray toFile:getInventorySearchNoteStorePath()];
    if(iskeyedarchiver){
        NSLog(@"archive success ");
        [_searchNoteArray removeObjectAtIndex:row];
        [self.tableView reloadData];
    }
}

-(void)showHelp{
    [YYInventoryApi markAsReadOnMsg:nil adnBlock:nil];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Order" bundle:[NSBundle mainBundle]];
    YYOrderHelpViewController *orderHelpViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderHelpViewController"];
    orderHelpViewController.helpType = 1;
    [self.navigationController pushViewController:orderHelpViewController animated:YES];
    
    WeakSelf(ws);
    [orderHelpViewController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}
#pragma mark - Other
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
