//
//  YYOrderAddressListController.m
//  Yunejian
//
//  Created by Apple on 15/10/26.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYOrderAddressListController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYNavigationBarViewController.h"

// 自定义视图
#import "YYOrderAddressListCell.h"

// 接口
#import "YYUserApi.h"

// 分类

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYBuyerModel.h"
#import "YYBuyerListModel.h"

@interface YYOrderAddressListController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation YYOrderAddressListController

-(void)viewDidLoad{
    _textNameInput.delegate = self;
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = NSLocalizedString(@"买手店",nil);
    [_containerView insertSubview:navigationBarViewController.view atIndex:0];
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
            [ws closeHandler:nil];
            blockVc = nil;
        }
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textNameInput];
    [self addObserverForKeyboard];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageOrderAddressList];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageOrderAddressList];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:_textNameInput];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

-(void)loadBuyerList:(NSString *)queryStr{
    WeakSelf(ws);
    [YYUserApi queryBuyer:queryStr andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYBuyerListModel *buyerList, NSError *error) {
        if (rspStatusAndMessage.status == YYReqStatusCode100) {
            ws.buyerList = buyerList;
            if(_needUnDefineBuyer){
            self.buyerModel = [self getBuyerModel:_textNameInput.text];
            if(self.buyerModel == nil){
                self.buyerModel = [[YYBuyerModel alloc] init];
                self.buyerModel.contactName = _textNameInput.text;
                self.buyerModel.name = _textNameInput.text;
                self.buyerModel.contactEmail = nil;
                NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
                [tmpArray addObject:self.buyerModel];
                [tmpArray addObjectsFromArray:buyerList.result];
                ws.buyerList.result = tmpArray;
            }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                //[ws.myTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                [ws.myTableView reloadData];
                //[ws.myTableView deselectRowAtIndexPath:indexPath animated:YES];

            });
        }
    }];
}

- (IBAction)closeHandler:(id)sender {
    if(self.cancelButtonClicked){
        self.cancelButtonClicked();
    }
}

- (IBAction)makeSureHandler:(id)sender {
    if (self.makeSureButtonClicked && ![_textNameInput.text isEqualToString:@""]) {
       // YYBuyerModel *infoModel =[self getBuyerModel:_textNameInput.text];
        self.makeSureButtonClicked(_textNameInput.text,self.buyerModel);
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

//    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    self.currentYYOrderInfoModel.buyerName = str;

    return YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *str =textField.text;
    if(![str isEqualToString:@""]){
        [self loadBuyerList:str];
    }else{
        self.buyerList = nil;
        self.buyerModel = nil;
        [self.myTableView reloadData];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text
        && [textField.text length] > 0) {
        
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField{
    //self.layoutTopConstraints.constant = 63;
}

- (void)addObserverForKeyboard{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)keyboardWillHide:(NSNotification *)note
{
    //134
    //self.layoutTopConstraints.constant = 163;
}

-(YYBuyerModel * )getBuyerModel:(NSString *)str{
    NSArray *txtArr = [str componentsSeparatedByString:@"|"];
    if (_buyerList && _buyerList.result && [_buyerList.result count] >0) {
        for (YYBuyerModel *infoModel in _buyerList.result) {
            for (NSString *txt in txtArr) {
                if([infoModel.contactName isEqualToString:txt] || [infoModel.contactEmail isEqualToString:txt]){
                    return infoModel;
                }
            }
        }
    }
    return nil;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_buyerList
        && _buyerList.result) {
        return [_buyerList.result count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString* reuseIdentifier = @"YYOrderAddressListCell";
    YYOrderAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    YYBuyerModel *infoModel = [self.buyerList.result objectAtIndex:indexPath.section];
    cell.curModel = _buyerModel;
    cell.infoModel = infoModel;
    [cell updateUI];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_textNameInput resignFirstResponder];
    YYBuyerModel *infoModel = [self.buyerList.result objectAtIndex:indexPath.section];
    self.buyerModel = infoModel;
    
    [self.myTableView reloadData];
    [self makeSureHandler:nil];
}

@end
