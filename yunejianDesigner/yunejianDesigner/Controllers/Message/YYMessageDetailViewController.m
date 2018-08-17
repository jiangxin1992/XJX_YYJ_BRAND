//
//  YYMessageDetailViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYMessageDetailViewController.h"
#import "YYNavigationBarViewController.h"
#import <MJRefresh.h>
#import "YYMessageChatCell.h"
#import "YYMessageChatModel.h"
#import "YYUser.h"
#import "YYMessageApi.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JPUSHService.h"
#import "NSTimer+eocBlockSupports.h"
#import "YYBuyerHomePageViewController.h"
#import "YYUserApi.h"
#import "YYOrderApi.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "YYShowImageViewController.h"
#import "YYShowMessageUrlViewController.h"

#import "UIActionSheet+JRPhoto.h"

@interface YYMessageDetailViewController ()<UIGestureRecognizerDelegate,YYMessageChatCellDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate, JRPhotoImageDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIView *toolbar;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarBottom;
- (IBAction)sendBtnClicked:(UIButton *)btn;
/**
 *  数据源
 */
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic,strong)YYPageInfoModel *currentPageInfo;
@property (strong, nonatomic) NSMutableArray *pushDataArray;


@property (nonatomic,assign) CGFloat keyBoardHeight;
@property (nonatomic,assign) NSInteger animationCurve;
@property (nonatomic,assign) CGFloat animationDuration;

@property (nonatomic, retain) NSTimer* timer;


@end

@implementation YYMessageDetailViewController
static NSNumber * tempUserId;
static NSInteger toolbarDefautlHeight;
static NSInteger textFieldDefautlHeight;


#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    //self.navigationBarViewController = navigationBarViewController;
    navigationBarViewController.nowTitle = _buyerName;
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
            [ws resetTimer];
            [ws.textField resignFirstResponder];
            if(ws.cancelButtonClicked){
                ws.cancelButtonClicked();
            }
            blockVc = nil;
        }
    }];

    [self addHeader];
    //    [self addFooter];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self setupUI];
    UIGestureRecognizer *aGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabPiece:)];
    aGesture.delegate = self;
    [self.view addGestureRecognizer:aGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [self setInsertTimer];

    tempUserId =_userId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadListFromServerByPageIndex:1 endRefreshing:NO];
}

#pragma mark - --------------SomePrepare--------------



#pragma mark - --------------系统代理----------------------
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYMessageChatModel *model = self.dataArray[indexPath.row];
    YYMessageChatCell *cell = nil;
    if (model.type == ChatTypeOther) {
        cell = [YYMessageChatCell cellWithTableView:tableView chatCellType:ChatCellTypeOther];
        model.icon= _userlogo;
    }else if (model.type == ChatTypeSelf) {
        cell = [YYMessageChatCell cellWithTableView:tableView chatCellType:ChatCellTypeSelf];
        YYUser *user = [YYUser currentUser];
        model.icon= user.logo;
    }
    cell.model = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"+++++");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.textField.isFocused) {
        [self.view endEditing:YES];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return  YES;
}

- (void)tabPiece:(UIPanGestureRecognizer *)gestureRecognizer{
    [self.textField resignFirstResponder];
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UITextView *textField =textView;
    //self.sendBtn.enabled = textField.text.length ? YES : NO;

    NSString *toBeString = textField.text;
    NSInteger maxLength = 600;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLength) {
                textField.text = [toBeString substringToIndex:maxLength];
            }
        }
    }
    else{
        if (toBeString.length > maxLength) {
            textField.text = [toBeString substringToIndex:maxLength];
        }
    }

    static CGFloat maxHeight =80.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
//    if(false && size.height<=frame.size.height) {
//        size.height=frame.size.height;
//    }else{
        if (size.height >= maxHeight)
        {
            size.height = maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    [textView setConstraintConstant:size.height forAttribute:NSLayoutAttributeHeight];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) //获取键盘中发送事件（回车事件）
    {
        [self sendBtnClicked:nil];;  //处理键盘的发送事件
        return NO;
    }
    return YES;
}


#pragma mark - --------------自定义代理/block----------------------
#pragma YYTableCellDelegate
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = [parmas objectAtIndex:0];
    if([type isEqualToString:@"buyerInfo"]){

        WeakSelf(ws);
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appdelegate showBuyerInfoViewController:self.userId WithBuyerName:self.buyerName parentViewController:self WithReqSuccessBlock:nil WithHomePageCancelBlock:^{
            [ws.navigationController popViewControllerAnimated:YES];
        } WithModifySuccessBlock:nil];

    }
}

#pragma mark - cell回调
- (void)YYMessageChatCellDelegate:(YYMessageChatCell *)cell{
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        NSLog(@"真·刷新之术");
//    });
}

// 重新上传
- (void)YYMessageChatCellDelegateUploadAgain:(YYMessageChatCell *)cell{
    [self.dataArray removeObject:cell.model];
    [self uploadImage:cell.model.locationImage];
}

// 放大
- (void)YYMessageChatCellDelegateShowBigImage:(YYMessageChatCell *)cell{
    YYShowImageViewController *imageC = [[YYShowImageViewController alloc] init];
    if (cell.model.locationImage) {
        imageC.imageImage = cell.model.locationImage;
    }else{
        imageC.imageUrl = cell.model.message;
    }

    [self presentViewController:imageC animated:YES completion:nil];

}

// 点击url
- (void)YYMessageChatCellDelegateTapUrl:(YYMessageChatCell *)cell URL:(NSString *)url{
    YYShowMessageUrlViewController *urlController = [[YYShowMessageUrlViewController alloc] init];
    urlController.message = url;

    [urlController setOkClick:^(NSString *jumpUrl) {
        NSString *tempJumpUrl = [jumpUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([[tempJumpUrl lowercaseString] hasPrefix:@"http"]){
                //以http开头
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempJumpUrl]];
        }else{
            if([[tempJumpUrl lowercaseString] hasPrefix:@"ftp"]){
                //以ftp开头
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempJumpUrl]];
            }else{
                //啥都没有
                NSString *tempEndJumpUrl = [[NSString alloc] initWithFormat:@"http://%@",tempJumpUrl];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempEndJumpUrl]];
            }
        }
    }];
    [self presentViewController:urlController animated:YES completion:nil];
}

#pragma mark - 图片选择完毕准备上传
- (void)JRPhotoData:(NSData *)data sign:(NSString *)sign{
    if(_userId == nil){
        return;
    }
    UIImage *image = [UIImage imageWithData:data];

    [self uploadImage:image];
}

#pragma mark - --------------自定义响应----------------------
#pragma mark - Action
- (IBAction)sendBtnClicked:(UIButton *)btn
{
    if([NSString isNilOrEmpty:self.textField.text]){
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time             = [formatter stringFromDate:[NSDate date]];
    YYMessageChatModel *selfModel = [YYMessageChatModel modelWithIcon:nil time:time message:self.textField.text type:ChatTypeSelf charType:@"PLAIN_TEXT"];
    self.textField.text = nil;
    [self.textField setConstraintConstant:textFieldDefautlHeight forAttribute:NSLayoutAttributeHeight];

    [self sendTalk:selfModel];
}

// 弹出图片选择器
- (IBAction)ejectPhotoSheet:(UIButton *)sender {
    [self.view endEditing:YES];
    [UIActionSheet SheetPhotoControl:self WithDelegate:self photoType:(photoTypeAlbum|photoTypeCamera) isEditing:NO sign:@"1"];
}


#pragma mark - --------------自定义方法----------------------
#pragma mark - 键盘隐藏与消失

- (void)keyboardWillShow:(NSNotification *)note
{
    //获取键盘高度
    if(self.keyBoardHeight > 0){
        return;
    }

    NSDictionary *info = [note userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;

    self.keyBoardHeight = keyboardSize.height;

    _animationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    _animationCurve = _animationCurve<<16;
    _animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.tableViewBottom.constant = self.keyBoardHeight+toolbarDefautlHeight;
        self.toolbarBottom.constant= self.keyBoardHeight+0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:NULL];
}

- (void)keyboardDidShow:(NSNotification *)note
{
    //获取键盘高度
    if(self.keyBoardHeight > 0){
        NSDictionary *info = [note userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGSize keyboardSize = [value CGRectValue].size;

        self.keyBoardHeight = keyboardSize.height;
        self.tableViewBottom.constant = self.keyBoardHeight+toolbarDefautlHeight;
        self.toolbarBottom.constant= self.keyBoardHeight+0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }
}

- (void)keyboardWillHide:(NSNotification *)note
{
    if(self.keyBoardHeight < 0){
        return;
    }
    self.keyBoardHeight = 0;

    [UIView animateWithDuration:_animationDuration delay:0 options:(_animationCurve|UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.tableViewBottom.constant = self.keyBoardHeight+toolbarDefautlHeight;
        self.toolbarBottom.constant= self.keyBoardHeight+0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:NULL];
}

//缓存显示数据
-(void)insertPushData{
    NSInteger pushDataCount =  [_pushDataArray count];
    NSInteger sendCount = MIN(pushDataCount, 5);
    for(NSInteger i=0;i<sendCount;i++){
        YYMessageChatModel *model = [_pushDataArray objectAtIndex:0];
        [_pushDataArray removeObjectAtIndex:0];
        [self insertMessage:model];
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDictionary *extra = [userInfo valueForKey:@"extras"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

    NSString *currentContent = [NSString
                                stringWithFormat:
                                @"收到自定义消息:%@\ntitle:%@\ncontent:%@\nextra:%@\n",
                                [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                               dateStyle:NSDateFormatterNoStyle
                                                               timeStyle:NSDateFormatterMediumStyle],
                                title, content, extra.description];
    NSLog(@"%@", currentContent);

    NSInteger msgType = [[extra objectForKey:@"msgType"] integerValue];
    NSInteger isowner = [[extra objectForKey:@"isowner"] integerValue];
    NSString *time = [extra objectForKey:@"time"];
    NSString *email = [extra objectForKey:@"email"];
    NSString *chatType = [extra objectForKey:@"chatType"];

    if (msgType == 4 && isowner == 0 && (![NSString isNilOrEmpty:_userEmail] && [_userEmail isEqualToString:email])) {//私信
        NSString *timeFormatStr = getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd HH:mm",time);

        YYMessageChatModel *otherModel = [YYMessageChatModel modelWithIcon:nil time:timeFormatStr message:content type:ChatTypeOther charType:chatType];

        [self.pushDataArray addObject:otherModel];
        [self.tableView reloadData];
    }
}

//插入一条消息
- (void)insertMessage:(YYMessageChatModel *)model{
    //将新的消息插入到最后
    [self.dataArray addObject:model];
    NSIndexPath *index = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationBottom];

    //让tableView滚动到最低部
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

// 上传图片，刷新label
- (void)uploadImage:(UIImage *)image{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *time  = [formatter stringFromDate:[NSDate date]];


    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];

    // IMAGE-location 为临时存储方案。
    YYMessageChatModel *model = [YYMessageChatModel modelWithIcon:nil time:time message:@"" type:ChatTypeSelf charType:@"IMAGE-location"];
    model.locationImage = image;
    model.sign = timeString;

    [self.dataArray addObject:model];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0];

     [self.tableView reloadData];

    //让tableView滚动到最低部
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];

    [YYOrderApi uploadImage:image size:3.0f sign:timeString indexpath:indexPath uploadProgress:^(float uploadProgress, NSIndexPath *indexPath) {
        // 如果是子类的话
        for (NSInteger x = self.dataArray.count-1; x >= 0; x--) {
            YYMessageChatModel *selfModel = self.dataArray[x];
            if ([selfModel.sign isEqualToString:timeString]) {
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:x inSection:0];
                if ([[self.tableView cellForRowAtIndexPath:index] isMemberOfClass:[ChatCellSelf class]]) {
                    ChatCellSelf *changeCell = [self.tableView cellForRowAtIndexPath:index];
                    changeCell.progress = uploadProgress-0.01;
                }
            }
        }
    } andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSString *sign, NSIndexPath *indexpath, NSString *imageUrl, NSError *error) {
        
        if (imageUrl && [imageUrl length] > 0) {
            self.textField.text = nil;
            for (NSInteger x = self.dataArray.count-1; x >= 0; x--) {
                YYMessageChatModel *selfModel = self.dataArray[x];
                if ([selfModel.sign isEqualToString:sign]) {
                    [YYMessageApi sendTalkWithOppositeId:_userId content:imageUrl charType:@"IMAGE" andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                        
                        YYMessageChatModel *model = self.dataArray[x];
                        model.isUploadSuccess = YES;
                        
                        NSIndexPath *index = [NSIndexPath indexPathForRow:x inSection:0];
                        
                        ChatCellSelf *changeCell = [self.tableView cellForRowAtIndexPath:index];
                        
                        [changeCell setIsHiddenProgress:YES];
                        
                        if(rspStatusAndMessage.status == kCode100){
                            // 处理图片
                        }else{
                            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                        }
                    }];
                    break;
                }
            }
            
            [self.textField setConstraintConstant:textFieldDefautlHeight forAttribute:NSLayoutAttributeHeight];
        }else{
            // 上传失败
            NSLog(@"上传失败啊。 ");
            if ([[self.tableView cellForRowAtIndexPath:indexPath] isMemberOfClass:[ChatCellSelf class]]) {
                ChatCellSelf *changeCell = [self.tableView cellForRowAtIndexPath:indexPath];
                changeCell.isShowError = YES;
            }
        }
    }];
}

#pragma mark - --------------UI----------------------
//初始化UI
- (void)setupUI{
    self.textField.returnKeyType = UIReturnKeySend;
    self.textField.enablesReturnKeyAutomatically = YES;
    self.textField.layer.cornerRadius = 4;
    self.textField.layer.masksToBounds = YES;
    self.textField.delegate = self;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    [self.textField setFont:[UIFont systemFontOfSize:15]];
    
    // 设置自动计算
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
    
    if (@available(iOS 11.0, *)){
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    toolbarDefautlHeight = 54;
    textFieldDefautlHeight = 34;
    [self.textField setConstraintConstant:textFieldDefautlHeight forAttribute:NSLayoutAttributeHeight];
}


#pragma mark - --------------other----------------------
- (void)dealloc
{
    [self resetTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)resetTimer {
    if (_timer && _timer.isValid) {
        [_timer invalidate];
    }
    
    self.timer = nil;
}

- (void)setInsertTimer {
    WeakSelf(ws);
    self.timer = [NSTimer eocScheduledTimerWithTimeInterval:2 block:^{
        [ws insertPushData];
    } repeats:YES];
}

#pragma mark - Setter/Getter

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)pushDataArray
{
    if(!_pushDataArray){
        _pushDataArray = [NSMutableArray array];
    }
    return _pushDataArray;
}

#pragma mark - load/remot
-(void)sendTalk:(YYMessageChatModel *)chatModel{
    if(_userId == nil){
        return;
    }
    WeakSelf(ws);
    __block YYMessageChatModel *blockchatModel = chatModel;
    [YYMessageApi sendTalkWithOppositeId:_userId content:chatModel.message charType:chatModel.chatType andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            [ws insertMessage:blockchatModel];
        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}

-(void)reloadTableData{
    if(self.currentPageInfo && self.currentPageInfo.isFirstPage){
        [self.tableView reloadData];
        if(self.dataArray.count){
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(self.dataArray.count - 1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }else{
        [self.tableView reloadData];
    }
}
- (void)addHeader{
    WeakSelf(ws);
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithTitle:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
            [ws.tableView.mj_header endRefreshing];
            return;
        }
        if (!ws.currentPageInfo.isLastPage) {
            [ws loadListFromServerByPageIndex:[ws.currentPageInfo.pageIndex intValue]+1 endRefreshing:YES];
        }else{
            //弹出提示
            [ws.tableView.mj_header endRefreshing];
        }
    }];
    self.tableView.mj_header = header;
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
}

- (void)loadListFromServerByPageIndex:(int)pageIndex endRefreshing:(BOOL)endrefreshing{
    WeakSelf(ws);
    
    __block BOOL blockEndrefreshing = endrefreshing;
    [YYMessageApi getMessageTalkHistoryWithOppositeId:_userId pageIndex:pageIndex pageSize:kPageSize andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYMessageTalkListModel *talkListModel, NSError *error) {
        if (rspStatusAndMessage.status == kCode100) {
            if (pageIndex == 1) {
                [ws.dataArray removeAllObjects];
            }
            ws.currentPageInfo = talkListModel.pageInfo;
            
            if (talkListModel && talkListModel.result
                && [talkListModel.result count] > 0){
                NSInteger len = [talkListModel.result count];
                for(NSInteger i=0;i<len;i++) {
                    YYMessageTalkModel *talkModel = [talkListModel.result objectAtIndex:i];
                    NSString *time = getShowDateByFormatAndTimeInterval(@"yyyy-MM-dd HH:mm",[talkModel.createTime stringValue]);
                    YYMessageChatModel *model = nil;
                    if([talkModel.isOwner integerValue] == 1){
                        model = [YYMessageChatModel modelWithIcon:nil time:time message:talkModel.content type:ChatTypeSelf charType:talkModel.chatType];
                    }else{
                        model = [YYMessageChatModel modelWithIcon:nil time:time message:talkModel.content type:ChatTypeOther charType:talkModel.chatType];
                    }
                    [ws.dataArray insertObject:model atIndex:0];
                }
            }
        }
        
        if(blockEndrefreshing){
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [ws reloadTableData];
        
        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
    }];
}


+(void)markAsRead{
    [YYMessageApi markAsReadMessageUserChatWithOppositeId:tempUserId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage,NSInteger num, NSError *error) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.messageUnreadModel.personalMessageAmount = @(MAX(0,[appDelegate.messageUnreadModel.personalMessageAmount integerValue] - num));
        [[NSNotificationCenter defaultCenter] postNotificationName:UnreadMsgAmountChangeNotification object:nil userInfo:nil];
    }];
}
@end
