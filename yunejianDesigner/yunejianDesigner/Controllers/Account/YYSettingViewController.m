//
//  YYSettingViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/12.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYSettingViewController.h"
#import "YYHelpViewController.h"
#import "YYFeedbackViewController.h"
#import "YYAboutUsViewController.h"
#import "UserDefaultsMacro.h"
#import "AppDelegate.h"
#import "YYNavigationBarViewController.h"
#import "YYUser.h"
#import "JpushHandler.h"
#import "YYActionSheet.h"
#import "YYGuideHandler.h"
#import <SDImageCache.h>

@interface YYSettingViewController ()

@property(nonatomic,strong) YYFeedbackViewController *feedbackViewController;
@property(nonatomic,strong) YYHelpViewController *helpViewController;
@property(nonatomic,strong) YYAboutUsViewController *aboutUsViewController;

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,assign) long cachedSize;

@end

@implementation YYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    //self.navigationBarViewController = navigationBarViewController;
    navigationBarViewController.nowTitle = NSLocalizedString(@"设置",nil);
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
            [ws cancelClicked:nil];
            blockVc = nil;
        }
    }];

    //popWindowAddBgView(self.view);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageSetting];
}
- (void)viewDidAppear:(BOOL)animated {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    if(cell){
        UIView *targetView = [cell viewWithTag:20001];
        [YYGuideHandler showGuideView:GuideTypeHelpNewFlag parentView:self.view targetView:targetView];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageSetting];
}

- (IBAction)cancelClicked:(id)sender{
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}

- (IBAction)testButtonAction:(id)sender{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYHelpViewController *helpViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYHelpViewController"];
    [self.navigationController pushViewController:helpViewController animated:YES];
    
}

//计算缓存大小
- (float)calculateCacheSize{
    self.cachedSize = 0;
    NSString *cacheDir = yyjDocumentsDirectory();
    float nowSize = [self fileSizeForDir:cacheDir];
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
    float MBCache = bytesCache/1000/1000;
    NSLog(@"nowSize: %f",nowSize+MBCache);
    return nowSize+MBCache;
}

- (IBAction)logout:(id)sender{
    WeakSelf(ws);
    CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确定退出登录？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"退出登录",nil)]];
    //__weak CMAlertView *_weakAlertView = alertView;
    alertView.specialParentView = self.view;
    [alertView setAlertViewBlock:^(NSInteger selectedIndex){
        if (selectedIndex == 1) {

            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

            //jpush登出
            [JpushHandler sendEmptyAlias];

            //清除用户相关的搜索数据
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *searchNoteListFile = getOrderSearchNoteStorePath();
            [fileManager removeItemAtPath:searchNoteListFile error:nil];
            NSString *documents = yyjDocumentsDirectory();
            [fileManager removeItemAtPath:documents error:nil];

            //清除保存的用户信息
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:kUserInfoKey];
            [userDefaults synchronize];

            //清除购物车
            [appDelegate clearBuyCar];

            //清空delegate下的临时数据
            [appDelegate delegateTempDataClear];

            //跳转回主页
            [ws cancelClicked:nil];

            //重新登录通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kNeedLoginNotification object:nil];
        }
        
    }];
    [alertView show];
}

//显示反馈界面
- (void)showFeedBack{
    
    WeakSelf(ws);

    UIView *superView = self.view;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYFeedbackViewController *feedbackViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYFeedbackViewController"];
    self.feedbackViewController = feedbackViewController;
    
    __weak UIView *weakSuperView = superView;
    UIView *showView = feedbackViewController.view;
    __weak UIView *weakShowView = showView;
    [feedbackViewController setCancelButtonClicked:^(){
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.feedbackViewController);
    }];
    
    [feedbackViewController setModifySuccess:^(){
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.feedbackViewController);
    }];
    
    
    [superView addSubview:showView];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSuperView.mas_top);
        make.left.equalTo(weakSuperView.mas_left);
        make.bottom.equalTo(weakSuperView.mas_bottom);
        make.right.equalTo(weakSuperView.mas_right);
        
    }];
    
    addAnimateWhenAddSubview(showView);
}


- (void)showHelpView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYHelpViewController *helpViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYHelpViewController"];
    self.helpViewController = helpViewController;
    
    UIView *superView = self.view;
    
    WeakSelf(ws);
    __weak UIView *weakSuperView = superView;
    UIView *showView = helpViewController.view;
    __weak UIView *weakShowView = showView;
    [helpViewController setCancelButtonClicked:^(){
        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,ws.helpViewController);
    }];
    
    
    
    
    [superView addSubview:showView];
    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSuperView.mas_top);
        make.left.equalTo(weakSuperView.mas_left);
        make.bottom.equalTo(weakSuperView.mas_bottom);
        make.right.equalTo(weakSuperView.mas_right);
        
    }];
    
    addAnimateWhenAddSubview(showView);
    
    [YYGuideHandler markGuide:GuideTypeHelpNewFlag];
}

- (void)showAboutView{
    WeakSelf(ws);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Account" bundle:[NSBundle mainBundle]];
    YYAboutUsViewController *aboutUsViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYAboutUsViewController"];
    self.aboutUsViewController = aboutUsViewController;
    [self.navigationController pushViewController:aboutUsViewController animated:YES];
    [aboutUsViewController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
        ws.aboutUsViewController = nil;
    }];
//    UIView *superView = self.view;
//    
//    WeakSelf(weakSelf);
//    __weak UIView *weakSuperView = superView;
//    UIView *showView = aboutUsViewController.view;
//    __weak UIView *weakShowView = showView;
//    [aboutUsViewController setCancelButtonClicked:^(){
//        removeFromSuperviewUseUseAnimateAndDeallocViewController(weakShowView,weakSelf.aboutUsViewController);
//    }];
//    
//
//    
//    
//    [superView addSubview:showView];
//    [showView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(weakSuperView.mas_top);
//        make.left.equalTo(weakSuperView.mas_left);
//        make.bottom.equalTo(weakSuperView.mas_bottom);
//        make.right.equalTo(weakSuperView.mas_right);
//        
//    }];
//    
//    addAnimateWhenAddSubview(showView);

    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 11;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSString *CellIdentifier = @"MyCell0";
    if(indexPath.row ==0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 8|| indexPath.row == 10){
        CellIdentifier = @"MyCell0";
    }else if(indexPath.row == 1){
        CellIdentifier = @"MyCell3";
    }else if(indexPath.row == 6){
        CellIdentifier = @"MyCell2";
    }else if(indexPath.row == 7){
        CellIdentifier = @"MyCell1";
    }else if(indexPath.row == 9){
        CellIdentifier = @"MyCell4";
    }else if(indexPath.row == 3){
        CellIdentifier = @"MyCell6";
    }else if(indexPath.row == 5){
        CellIdentifier = @"MyCell5";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(indexPath.row ==0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 8|| indexPath.row == 10){
        UILabel *lable1 = (UILabel *)[cell viewWithTag:10001];
        UILabel *lable2 = (UILabel *)[cell viewWithTag:10002];
        if(indexPath.row ==0 || indexPath.row ==10){
            lable1.hidden = YES;
            lable2.hidden = YES;
        }else{
            lable1.hidden = NO;
            lable2.hidden = NO;
        }
    }
    
    if (indexPath.row == 1) {
        UILabel *lable = (UILabel *)[cell viewWithTag:89990];
        if (lable) {
           float nowSize = [self calculateCacheSize];
            NSString *showValue = @"";
            if (nowSize < 1) {
                showValue = @"0M";
            }else{
                showValue = [NSString stringWithFormat:@"%iM",(int)nowSize];
            }
            
            lable.text = showValue;
        }
        
    }else if(indexPath.row == 3){
        UILabel *lable = (UILabel *)[cell viewWithTag:89990];
        if (lable) {
            lable.text = [LanguageManager currentLanguageString];
        }
    }
    
    if (cell == nil){
        [NSException raise:@"DetailCell == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==0 || indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 8|| indexPath.row == 10){
        return 10;
    }else{
        return 54;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        [self showHelpView];
    }else if (indexPath.row == 7) {
        [self  showAboutView];
    }else if (indexPath.row == 6) {
        [self showFeedBack];
    }else if (indexPath.row == 1){
        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:NSLocalizedString(@"确定清理？",nil) message:nil needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"否",nil) otherButtonTitles:@[NSLocalizedString(@"是",nil)]];
        alertView.specialParentView = self.view;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                
                NSString *cacheDir = yyjDocumentsDirectory();
                NSString *usersListFile = getUsersStorePath();
                NSString *searchNoteListFile = getOrderSearchNoteStorePath();
                NSFileManager *fileManager = [NSFileManager defaultManager];
                [fileManager removeItemAtPath:usersListFile error:nil];
                [fileManager removeItemAtPath:searchNoteListFile error:nil];
                [fileManager removeItemAtPath:cacheDir error:nil];

                [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
                [[SDImageCache sharedImageCache] clearMemory];//可有可无

                //清除购物车
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate clearBuyCar];
                [self.tableView reloadData];
            }
            
        }];
        [alertView show];
    }else if (indexPath.row == 3){
        YYActionSheet *sheet = [[YYActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@"中文", @"English", nil];
        [sheet show];
    }
}


- (void)actionSheet:(YYActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self changeLaunguage:1];
    }else{
        [self changeLaunguage:0];
    }
}


- (void)changeLaunguage:(NSInteger)index
{
    [LanguageManager saveLanguageByIndex:index];
    [self.tableView reloadData];
    [self reloadRootViewController];
    [LanguageManager setLanguageToServer];
}

- (void)reloadRootViewController
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate reloadRootViewController:appDelegate.leftMenuIndex];
}

-(float)fileSizeForDir:(NSString*)path//计算文件夹下文件的总大小
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            _cachedSize += fileAttributeDic.fileSize;
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }
    return _cachedSize/(1024.0*1024.0);
    
}


@end
