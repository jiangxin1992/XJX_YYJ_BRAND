//
//  YYBuyerInfoViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerInfoViewController.h"
#import "YYNavigationBarViewController.h"
#import "SCLoopScrollView.h"
#import "YYUserApi.h"
#import "YYConnApi.h"
#import "MBProgressHUD.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
#import "UIImage+Tint.h"
#import "YYMessageDetailViewController.h"
#import "YYGuideHandler.h"
#import "SCGIFImageView.h"
@interface YYBuyerInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneTitle;
@property (weak, nonatomic) IBOutlet SCLoopScrollView *loopView;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *connLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introLayoutHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connLayoutHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *oprateBtn;
@property (weak, nonatomic) IBOutlet UIView *infoContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoContentHeightLayoutConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weixinLabelTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oprateBtnLayoutLeftConstraint;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

//@property (strong,nonatomic) SCLoopScrollView *imageScrollView;
@property (nonatomic,strong) YYBuyerDetailModel *buyerModel;
@property (nonatomic,strong) UIPageControl *pageControl;
@end

@implementation YYBuyerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    //navigationBarViewController.previousTitle = _previousTitle;
    
    NSString *title = _previousTitle;
    navigationBarViewController.nowTitle = title;
    
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
            [ws.navigationController popViewControllerAnimated:YES];
            blockVc = nil;
        }
    }];
    
    self.pageControl = [[UIPageControl alloc] init];
    __weak SCLoopScrollView *weakScrollView = _loopView;
    __weak UIView *weakView = self.view;
    
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    [weakView addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakScrollView.mas_bottom).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(300, 20));
        make.centerX.equalTo(weakScrollView.mas_centerX);
    }];
    _pageControl.hidden = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadInfoData];
}

- (void)viewDidAppear:(BOOL)animated {
    if(self.chatBtn.hidden == NO)
    [YYGuideHandler showGuideView:GuideTypePersonalChat parentView:self.view targetView:self.chatBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadInfoData{
    WeakSelf(ws);
    [YYUserApi getBuyerDetailInfoWithID:_buyerId andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYBuyerDetailModel *buyerModel, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            ws.buyerModel = buyerModel;
            if([buyerModel.connectStatus integerValue] == kOrderStatus1){
                ws.isConned = YES;
            }else{
                ws.isConned = NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws updateUI];
            });
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


-(void)updateUI{
    if(_buyerModel.logoPath && ![_buyerModel.logoPath isEqualToString:@""]){
        sd_downloadWebImageWithRelativePath(NO, _buyerModel.logoPath, _logoImageView, kLogoCover, 0);
    }else{
        // sd_downloadWebImageWithRelativePath(NO, @"", _logoImageView, kLogoCover, 0);
        _logoImageView.image = [UIImage imageNamed:@"default_icon"];
    }
    _logoImageView.layer.borderColor = [UIColor colorWithHex:kDefaultImageColor].CGColor;
    _logoImageView.layer.borderWidth = 2;
    _logoImageView.layer.cornerRadius = 25;
    _logoImageView.layer.masksToBounds = YES;
    _nameLabel.text = _buyerModel.name;
    
    NSString *_nation = [LanguageManager isEnglishLanguage]?_buyerModel.nationEn:_buyerModel.nation;
    NSString *_province = [LanguageManager isEnglishLanguage]?_buyerModel.provinceEn:_buyerModel.province;
    NSString *_city = [LanguageManager isEnglishLanguage]?_buyerModel.cityEn:_buyerModel.city;
    
    _cityLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ %@%@",nil),_nation,_province,_city];
    
    float loopViewHeight = (float)SCREEN_WIDTH/370*260;
    [_loopView setConstraintConstant:loopViewHeight forAttribute:NSLayoutAttributeHeight];
    //[_loopView layoutSubviews];
    _loopView.frame = CGRectMake(CGRectGetMinX(_loopView.frame), CGRectGetMinY(_loopView.frame), CGRectGetWidth(_loopView.frame), loopViewHeight);
    NSInteger imageCount = [_buyerModel.storeFiles count];
    NSMutableArray *tmpIamgeArr = [[NSMutableArray alloc] initWithCapacity:imageCount];
    if(imageCount > 0){
        for(int i = 0 ; i < imageCount; i++){
            NSString *imageName =[NSString stringWithFormat:@"%@",[_buyerModel.storeFiles objectAtIndex:i]];
            if([imageName isEqualToString:@""]){
                break;
            }
            NSString *_imageRelativePath = imageName;
            NSString *imgInfo = [NSString stringWithFormat:@"%@%@|%@",_imageRelativePath,kLookBookImage,@""];
            [tmpIamgeArr addObject:imgInfo];
        }
        _pageControl.numberOfPages = imageCount;
        _pageControl.currentPage = 0;
        _pageControl.hidden = NO;
        
    }
    _loopView.images = tmpIamgeArr;
    [_loopView show:^(NSInteger index) {
    } finished:^(NSInteger index) {
        _pageControl.currentPage = index;
    }];
    
    
    _weixinLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@",nil),_buyerModel.wechatNumber];
    _webLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@",nil),_buyerModel.webUrl];
    _priceLabel.text = [NSString stringWithFormat:replaceMoneyFlag(NSLocalizedString(@"￥%@ -￥%@",nil),0),_buyerModel.priceMin,_buyerModel.priceMax];
    if(_isConned){
        //[_phoneLabel hideByHeight:NO];
        _phoneLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@",nil),_buyerModel.contactEmail];
        _phoneTitle.hidden = NO;
        _phoneLabel.hidden = NO;
        _weixinLabelTopLayoutConstraint.constant = 49;
        _chatBtn.hidden = NO;
        _oprateBtnLayoutLeftConstraint.constant = 55;
    }else{
        //[_phoneLabel hideByHeight:YES];
        _phoneTitle.hidden = YES;
        _phoneLabel.hidden = YES;
        _weixinLabelTopLayoutConstraint.constant = 22;
        _chatBtn.hidden = YES;
        _oprateBtnLayoutLeftConstraint.constant = 17;
    }
    [self viewDidAppear:YES];
    NSString *brandsStr = [NSString stringWithFormat:NSLocalizedString(@"%@",nil),[_buyerModel.businessBrands componentsJoinedByString:@"，"]];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 5;
    NSDictionary *attDic = @{NSParagraphStyleAttributeName: paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:13]};
    //_connLabel.text = brandsStr;
    //_connLabel.backgroundColor = [UIColor redColor];
   // NSInteger totalHeight = 420 -32;
    NSInteger hasHeight = getTxtHeight(CGRectGetWidth(_connLabel.frame), brandsStr, attDic);
    //hasHeight = MIN(hasHeight, totalHeight);
    CGSize connLabelSize = [brandsStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    if(connLabelSize.width > CGRectGetWidth(_connLabel.frame)){
        _connLayoutHeightConstraint.constant = hasHeight;
        _connLabel.attributedText = [[NSAttributedString alloc] initWithString:brandsStr attributes:attDic];

    }else{
        _connLayoutHeightConstraint.constant = connLabelSize.height;
        _connLabel.attributedText = [[NSAttributedString alloc] initWithString:brandsStr attributes:nil];

    }
    
    //totalHeight = MAX(totalHeight - hasHeight,13);
    NSDictionary *attDic1 = @{NSParagraphStyleAttributeName: paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:12]};

    NSString *introductionStr = [NSString stringWithFormat:NSLocalizedString(@"%@",nil),_buyerModel.introduction];
    //_introLabel.text = introductionStr;
    _introLabel.attributedText = [[NSAttributedString alloc] initWithString:introductionStr attributes:attDic1];
    hasHeight = getTxtHeight(CGRectGetWidth(_introLabel.frame), introductionStr,attDic1);
    //hasHeight = MIN(hasHeight, totalHeight);
    _introLayoutHeightConstraint.constant = hasHeight;
    //_introLabel.backgroundColor = [UIColor grayColor];
    //_connLabel.backgroundColor = [UIColor grayColor];

    _oprateBtn.layer.cornerRadius = 2.5;
    _oprateBtn.layer.masksToBounds = YES;
    _oprateBtn.layer.borderWidth = 1;
    if([_buyerModel.connectStatus integerValue] == kConnStatus){
        _oprateBtn.backgroundColor =[UIColor clearColor];
        [_oprateBtn setImage:[UIImage imageNamed:@"conn_invite1_icon"] forState:UIControlStateNormal];
        [_oprateBtn setTitle:NSLocalizedString(@"邀请合作",nil) forState:UIControlStateNormal];
        [_oprateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _oprateBtn.layer.borderColor = [UIColor blackColor].CGColor;
        [_oprateBtn setConstraintConstant:100 forAttribute:NSLayoutAttributeWidth];
    }else if([_buyerModel.connectStatus integerValue] == kConnStatus0){
        _oprateBtn.backgroundColor =[UIColor clearColor];
        [_oprateBtn setImage:[UIImage imageNamed:@"conn_inviteing1_icon"] forState:UIControlStateNormal];
        [_oprateBtn setTitle:NSLocalizedString(@"已经邀请",nil) forState:UIControlStateNormal];
        [_oprateBtn setTitleColor:[UIColor colorWithHex:@"58c77d"] forState:UIControlStateNormal];
        _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"58c77d"].CGColor;
        [_oprateBtn setConstraintConstant:84 forAttribute:NSLayoutAttributeWidth];
    }else if([_buyerModel.connectStatus integerValue] == kConnStatus1){
        _oprateBtn.backgroundColor =[UIColor colorWithHex:@"58c77d"];
        [_oprateBtn setImage:[UIImage imageNamed:@"conn_cancel_icon"] forState:UIControlStateNormal];
        [_oprateBtn setTitle:NSLocalizedString(@"已经合作",nil) forState:UIControlStateNormal];
        [_oprateBtn setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"58c77d"].CGColor;
        [_oprateBtn setConstraintConstant:84 forAttribute:NSLayoutAttributeWidth];
    }else if([_buyerModel.connectStatus integerValue] == kConnStatus2){
        _oprateBtn.backgroundColor =[UIColor clearColor];
        //_oprateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_oprateBtn setImage:[UIImage imageNamed:@"conn_inviteing1_icon"] forState:UIControlStateNormal];
        [_oprateBtn setTitle:NSLocalizedString(@"已经邀请",nil) forState:UIControlStateNormal];
        [_oprateBtn setTitleColor:[UIColor colorWithHex:@"58c77d"] forState:UIControlStateNormal];
        _oprateBtn.layer.borderColor = [UIColor colorWithHex:@"58c77d"].CGColor;
        [_oprateBtn setConstraintConstant:84 forAttribute:NSLayoutAttributeWidth];
    }
    [_infoContentView layoutSubviews];
    _infoContentHeightLayoutConstriant.constant = CGRectGetMaxY(_introLabel.frame) + 40;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)oprateBtnHandler:(id)sender {
    WeakSelf(ws);
    if(_buyerModel == nil){
        return;
    }
    if([_buyerModel.connectStatus integerValue] == kConnStatus1){
        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"解除合作后，买手店将不能浏览本品牌作品。确认解除合作吗？",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"继续合作_no",nil) otherButtonTitles:@[NSLocalizedString(@"解除合作_yes",nil)]];
        alertView.specialParentView = self.view;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                [ws oprateConnWithBuyer:[_buyerModel.buyerId integerValue] status:3];
            }
        }];
        
        [alertView show];
    }else if([_buyerModel.connectStatus integerValue] == kConnStatus0){
        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"取消邀请吗？",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"继续邀请_no",nil) otherButtonTitles:@[NSLocalizedString(@"取消邀请_yes",nil)]];
        alertView.specialParentView = self.view;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                [ws oprateConnWithBuyer:[_buyerModel.buyerId integerValue] status:4];
            }
        }];
        
        [alertView show];
    }else if([_buyerModel.connectStatus integerValue] == kConnStatus2){
        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"确定接受邀请吗？",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"拒绝邀请",nil) otherButtonTitles:@[NSLocalizedString(@"同意邀请|00000",nil)]];
        alertView.specialParentView = self.view;
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                [ws oprateConnWithBuyer:[_buyerModel.buyerId integerValue] status:1];
            }else{
                [ws oprateConnWithBuyer:[_buyerModel.buyerId integerValue] status:2];
            }
        }];
        
        [alertView show];
    }else if([_buyerModel.connectStatus integerValue] == kConnStatus){//
        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"确定邀请吗？",nil) needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消邀请",nil) otherButtonTitles:@[NSLocalizedString(@"继续邀请",nil)]];
        alertView.specialParentView = self.view;
        __block YYBuyerDetailModel *blockBuyerModel = _buyerModel;
        
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                [YYConnApi invite:[blockBuyerModel.buyerId integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                    if(rspStatusAndMessage.status == kCode100){
                        blockBuyerModel.connectStatus = 0;
                        [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                        //[ws updateUI];
                        if(ws.modifySuccess){
                            ws.modifySuccess();
                        }
                        [ws.navigationController popViewControllerAnimated:YES];
                        
                    }
                }];
            }
        }];
        
        [alertView show];
    }
}
- (IBAction)chatBtnHandler:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Message" bundle:[NSBundle mainBundle]];
    YYMessageDetailViewController *messageViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYMessageDetailViewController"];
    messageViewController.userlogo = _buyerModel.logoPath;
    messageViewController.userEmail = _buyerModel.contactEmail;
    messageViewController.userId = _buyerModel.buyerId;
    messageViewController.buyerName = _buyerModel.name;
    WeakSelf(ws);
    [messageViewController setCancelButtonClicked:^(void){
        [ws.navigationController popViewControllerAnimated:YES];
        [YYMessageDetailViewController markAsRead];
    }];
    [self.navigationController pushViewController:messageViewController animated:YES];

}

// 1->同意邀请	2->拒绝邀请	3->移除合作 4取消邀请
- (void)oprateConnWithBuyer:(NSInteger)buyerId status:(NSInteger)status{
    WeakSelf(ws);
    [YYConnApi OprateConnWithBuyer:buyerId status:status andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if(rspStatusAndMessage.status == kCode100){
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            if(ws.cancelButtonClicked){
                ws.cancelButtonClicked();
            }
            [ws.navigationController popViewControllerAnimated:YES];
        }
    }];
}


@end
