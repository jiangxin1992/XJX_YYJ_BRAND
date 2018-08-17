//
//  YYGroupModuleViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYGroupMessageViewController.h"
#import "YYInventoryViewController.h"
#import "YYNavigationBarViewController.h"
#import "YYOrderMessageViewController.h"
#import "YYConnMsgListController.h"
#import "AppDelegate.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "YYNewsViewController.h"
#import "YYMessagePersonalCell.h"
#import "YYMessageDetailViewController.h"
#import "YYStockMessageListViewController.h"
#import <MJRefresh.h>
#import "YYPageInfoModel.h"
#import "YYMessageApi.h"
#import "MBProgressHUD.h"
#import "YYUser.h"
#import "YYMessageUnreadModel.h"

@interface YYGroupMessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic)NSMutableArray *personalMessageList;
@property (nonatomic,strong)YYPageInfoModel *currentPageInfo;

@property (nonatomic,strong) UIView *noDataView;
@end

@implementation YYGroupMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    //self.navigationBarViewController = navigationBarViewController;
    navigationBarViewController.nowTitle = NSLocalizedString(@"消息中心",nil);
    //[_containerView insertSubview:navigationBarViewController.view atIndex:0];
    [_containerView addSubview:navigationBarViewController.view];
    __weak UIView *_weakContainerView = _containerView;
    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakContainerView.mas_top);
        make.left.equalTo(_weakContainerView.mas_left);
        make.bottom.equalTo(_weakContainerView.mas_bottom);
        make.right.equalTo(_weakContainerView.mas_right);
    }];
    //
    WeakSelf(ws);
    __block YYNavigationBarViewController *blockVc = navigationBarViewController;
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            if(_cancelButtonClicked){
                [blockVc.view removeFromSuperview];
                blockVc = nil;
                ws.cancelButtonClicked();
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addHeader];
    [self addFooter];

    _personalMessageList = [[NSMutableArray alloc] initWithCapacity:3];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadListFromServerByPageIndex:1 endRefreshing:NO];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageGroupMessage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageGroupMessage];
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
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([YYUser isShowroomToBrand]){
        return 1;
    }else{
        return 2;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([YYUser isShowroomToBrand]){
        return 4;
    }else{
        if(section == 0){
            return [self StockEnable] ? 5 : 4;
        }else{
            return MAX(1,[_personalMessageList count]);
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NSInteger sectionDownCell = 0;
        if([YYUser isShowroomToBrand]){
            sectionDownCell = 3;
        }else{
            sectionDownCell = [self StockEnable] ? 4 : 3;
        }
        if(indexPath.row == sectionDownCell){
            static NSString *CellIdentifier = @"YYMessageSpaceCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            return  cell;
        }

        static NSString *CellIdentifier = @"YYMessageInfoCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *textLabel = [cell viewWithTag:10001];
        UIImageView *iconImg = [cell viewWithTag:10004];
        UILabel *numLabel = [cell viewWithTag:10003];
        UIView *downLine = [cell viewWithTag:10010];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //        NSInteger msgAmount = appDelegate.unreadOrderNotifyMsgAmount + appDelegate.unreadConnNotifyMsgAmount;
        iconImg.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
        iconImg.layer.borderWidth = 1;
        iconImg.layer.masksToBounds = YES;
        iconImg.layer.cornerRadius = 22.5;
        downLine.hidden = NO;
        if(indexPath.row == 0){
            iconImg.image = [UIImage imageNamed:@"inventoryconn_icon"];
            textLabel.text = NSLocalizedString(@"合作消息",nil);
            if([appDelegate.messageUnreadModel.connAmount integerValue] > 0){
                numLabel.hidden = NO;
                [self updateLabelNumber:numLabel nowNumber:[appDelegate.messageUnreadModel.connAmount integerValue]];
            }else{
                numLabel.hidden = YES;
            }
        }else if(indexPath.row == 1){
            iconImg.image = [UIImage imageNamed:@"inventoryorder_icon"];
            textLabel.text = NSLocalizedString(@"订单消息",nil);
            if([appDelegate.messageUnreadModel.orderAmount integerValue] > 0){
                numLabel.hidden = NO;
                [self updateLabelNumber:numLabel nowNumber:[appDelegate.messageUnreadModel.orderAmount integerValue]];
            }else{
                numLabel.hidden = YES;
            }
        } else if (indexPath.row == 2) {
            if ([self StockEnable]) {
                iconImg.image = [UIImage imageNamed:@"stock_message"];
                textLabel.text = NSLocalizedString(@"库存消息",nil);
                if([appDelegate.messageUnreadModel.skuAmount integerValue] > 0){
                    numLabel.hidden = NO;
                    [self updateLabelNumber:numLabel nowNumber:[appDelegate.messageUnreadModel.skuAmount integerValue]];
                }else{
                    numLabel.hidden = YES;
                }
            } else {
                iconImg.image = [UIImage imageNamed:@"inventorynews_icon"];
                textLabel.text = NSLocalizedString(@"YCO新闻",nil);
                if([appDelegate.messageUnreadModel.newsAmount integerValue] > 0 ){
                    [self updateLabelNumber:numLabel nowNumber:0];
                }else{
                    numLabel.hidden = YES;
                }
                downLine.hidden = YES;
            }
        }else if(indexPath.row == 3 && [self StockEnable]){
            iconImg.image = [UIImage imageNamed:@"inventorynews_icon"];
            textLabel.text = NSLocalizedString(@"YCO新闻",nil);
            if([appDelegate.messageUnreadModel.newsAmount integerValue] > 0 ){
                [self updateLabelNumber:numLabel nowNumber:0];
            }else{
                numLabel.hidden = YES;
            }
            downLine.hidden = YES;
        }
        return  cell;
    }else{
        if([_personalMessageList count]){
            static NSString *CellIdentifier = @"YYMessagePersonalCell";
            YYMessagePersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            YYMessageUserChatModel *chatModel = [self.personalMessageList objectAtIndex:indexPath.row];
            cell.chatModel = chatModel;
            [cell updateUI];
            if([chatModel.unreadCount integerValue] > 0){
                cell.newsNumLabel.hidden = NO;
                [self updateLabelNumber:cell.newsNumLabel nowNumber:[chatModel.unreadCount integerValue]];
            }else{
                cell.newsNumLabel.hidden = YES;
            }
            return  cell;
        }else{
            static NSString* reuseIdentifier = @"YYMessagePersonalNullCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
            if(self.noDataView == nil){
                self.noDataView = addNoDataView_phone(cell.contentView,[NSString stringWithFormat:@"%@|icon:nomsg_icon|65",NSLocalizedString(@"还没有私信记录",nil)],nil,nil);
            }
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

    }
}

- (void)updateLabelNumber:(UILabel *)numLabel nowNumber:(NSInteger)value{
    //nowNumber = @"99";
    numLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
    float numFontSize = 15;
    NSString *nowNumber = [NSString stringWithFormat:@"%ld",(long)value];
    if (value > 0) {
        numLabel.layer.cornerRadius = numFontSize/2;
        numLabel.layer.masksToBounds = YES;
        CGSize numTxtSize = [nowNumber sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11]}];
        NSInteger numTxtWidth = numTxtSize.width;
        if ([nowNumber length] >= 3) {
            numLabel.text = @"···";//[NSString stringWithFormat:@"%@",nowNumber];
        }else{
            numTxtWidth += numFontSize/2;
            numLabel.text = nowNumber;
        }
        numLabel.hidden = NO;
        numTxtWidth = MAX(numTxtWidth, numFontSize);
        [numLabel setConstraintConstant:numTxtWidth forAttribute:NSLayoutAttributeWidth];
        [numLabel setConstraintConstant:numFontSize forAttribute:NSLayoutAttributeHeight];

    }else{
        numLabel.hidden = NO;
        float dotSize = 7;
        numLabel.layer.cornerRadius = dotSize/2;
        numLabel.layer.masksToBounds = YES;
        [numLabel setConstraintConstant:dotSize forAttribute:NSLayoutAttributeWidth];
        [numLabel setConstraintConstant:dotSize forAttribute:NSLayoutAttributeHeight];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if([YYUser isShowroomToBrand]){
            if(indexPath.row == 3){
                return 10;
            }
        }else{
            if ([self StockEnable]) {
                if(indexPath.row == 4){
                    return 10;
                }
            } else {
                if (indexPath.row == 3) {
                    return 10;
                }
            }
        }
        return 60;
    }
    if([_personalMessageList count]){
        return 62;
    }else{
        return SCREEN_HEIGHT - 65 - (60*3+10);
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(ws);
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
            YYConnMsgListController *messageViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYConnMsgListController"];
            [messageViewController setMarkAsReadHandler:^(void){
                [YYConnMsgListController markAsRead];
                [ws.tableView reloadData];
            }];
            [self.navigationController pushViewController:messageViewController animated:YES];
        }else if(indexPath.row == 1){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"OrderDetail" bundle:[NSBundle mainBundle]];
            YYOrderMessageViewController *orderMessageViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYOrderMessageViewController"];
            [orderMessageViewController setMarkAsReadHandler:^(void){
                [YYOrderMessageViewController markAsRead];
                [ws.tableView reloadData];
            }];
            [self.navigationController pushViewController:orderMessageViewController animated:YES];
        }else if (indexPath.row == 2) {
            if ([self StockEnable]) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UILabel *numLabel = [cell viewWithTag:10003];
                
                YYStockMessageListViewController *viewController = [[YYStockMessageListViewController alloc] init];
                viewController.willDisappearBlock = ^{
                    [self updateLabelNumber:numLabel nowNumber:0];
                    numLabel.hidden = YES;
                };
                [self.navigationController pushViewController:viewController animated:YES];
            } else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"News" bundle:[NSBundle mainBundle]];
                YYNewsViewController *messageViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNewsViewController"];
                [messageViewController setCancelButtonClicked:^(void){
                    [ws.navigationController popViewControllerAnimated:YES];
                    [YYNewsViewController markAsRead];
                    [ws.tableView reloadData];
                }];
                [self.navigationController pushViewController:messageViewController animated:YES];
            }
        }else if(indexPath.row == 3 && [self StockEnable]){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"News" bundle:[NSBundle mainBundle]];
            YYNewsViewController *messageViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNewsViewController"];
            [messageViewController setCancelButtonClicked:^(void){
                [ws.navigationController popViewControllerAnimated:YES];
                [YYNewsViewController markAsRead];
                [ws.tableView reloadData];
            }];
            [self.navigationController pushViewController:messageViewController animated:YES];
        }
    }else{
            if(self.personalMessageList == nil || [self.personalMessageList count] == 0){
                return;
            }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Message" bundle:[NSBundle mainBundle]];
            YYMessageDetailViewController *messageViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYMessageDetailViewController"];
            YYMessageUserChatModel *chatModel = [self.personalMessageList objectAtIndex:indexPath.row];
            messageViewController.userEmail = chatModel.oppositeEmail;
            messageViewController.userlogo = chatModel.oppositeURL;
            messageViewController.userId = chatModel.oppositeId;
            messageViewController.buyerName = chatModel.oppositeName;
            YYMessageUserChatModel *blockchatModel = chatModel;
            [messageViewController setCancelButtonClicked:^(void){
                [ws.navigationController popViewControllerAnimated:YES];
                [YYMessageDetailViewController markAsRead];
                blockchatModel.unreadCount = [NSNumber numberWithInteger:0];
                [ws loadListFromServerByPageIndex:1 endRefreshing:YES];
            }];
            [self.navigationController pushViewController:messageViewController animated:YES];


        }
}

//// 指定哪一行可以编辑 哪行不能编辑
//- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

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
    return NSLocalizedString(@"删除",nil);
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        WeakSelf(ws);

        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确认删除此对话吗？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"删除",nil)]];
        alertView.specialParentView = self.view;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                YYMessageUserChatModel *chatModel = [ws.personalMessageList objectAtIndex:indexPath.row];
                __block NSInteger row = indexPath.row;
                [YYMessageApi deleteMessageUserChat:chatModel.oppositeEmail andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                    if(rspStatusAndMessage.status == kCode100){
                        [ws.personalMessageList removeObjectAtIndex:row];  //删除数组里的数据
                        [ws.tableView reloadData];
                        //[weakself.tableView deselectRowAtIndexPath:indexPath animated:YES];
                        //[weakself.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
                    }else{
                        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                    }
                }];
            }
        }];
        [alertView show];

    }
}

#pragma loadRemotData
-(void)reloadTableData{
    [self.tableView reloadData];
}


- (void)addHeader
{
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

- (void)addFooter{
    WeakSelf(ws);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.tableView.mj_footer endRefreshing];
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

- (void)loadListFromServerByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    if(![YYUser isShowroomToBrand]){
        WeakSelf(ws);

        __block BOOL blockEndrefreshing = endrefreshing;
        [YYMessageApi getUserChatListPageIndex:pageIndex pageSize:kMaxPageSize andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYMessageUserChatListModel *chatListModel, NSError *error) {
            if (rspStatusAndMessage.status == kCode100) {
                if (pageIndex == 1) {
                    [ws.personalMessageList removeAllObjects];
                }
                ws.currentPageInfo = chatListModel.pageInfo;

                if (chatListModel && chatListModel.result && [chatListModel.result count] > 0){

                    for (YYMessageUserChatModel *model in chatListModel.result) {
                        if ([model.chatType isEqualToString:@"IMAGE"]) {
                            model.content = NSLocalizedString(@"[图片]", nil);
                        }
                    }
                    [ws.personalMessageList addObjectsFromArray:chatListModel.result];
                }
            }

            if(blockEndrefreshing){
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            [ws reloadTableData];
            
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
            
        }];
    }else{
        if(endrefreshing){
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
}

#pragma mark - 自定义方法
- (BOOL)StockEnable {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.messageUnreadModel.stockStatus isEqualToString:StockStatusNormal] ? YES : NO;
}

@end
