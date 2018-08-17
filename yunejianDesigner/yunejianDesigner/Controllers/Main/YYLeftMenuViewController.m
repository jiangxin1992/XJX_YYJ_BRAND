//
//  YYLeftMenuViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/8.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYLeftMenuViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类
#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "YYUser.h"

#import "AppDelegate.h"
#import "YYGuideHandler.h"

static const NSInteger buttonTagOffset = 50000;
static NSInteger numFontSize = 15;

#define kNormalImageByIndex @"leftMenuButtonIndex_%ld_normal.png"
#define kSelectedImageByIndex @"leftMenuButtonIndex_%ld_selected.png"

#define kBrandNormaolImageName @"leftMenuButtonBrand_normal.png"
#define kBrandSelectedImageName @"leftMenuButtonBrand_selected.png"

@interface YYLeftMenuViewController ()

@property(nonatomic,strong) UIButton *currentSelectedButton;

@property (weak, nonatomic) IBOutlet UIButton *leftMenuButton_0;
@property (weak, nonatomic) IBOutlet UIButton *leftMenuButton_1;
@property (weak, nonatomic) IBOutlet UIButton *leftMenuButton_2;
@property (weak, nonatomic) IBOutlet UIButton *leftMenuButton_3;
@property (weak, nonatomic) IBOutlet UIButton *leftMenuButton_4;
@property (weak, nonatomic) IBOutlet UIImageView *leftMenuNewTag_4;
@property (weak, nonatomic) IBOutlet UIButton *leftMenuButton_5;

@end

@implementation YYLeftMenuViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    self.currentSelectedButton = _leftMenuButton_0;
    [self updateSelectedButton:_currentSelectedButton];
}

- (void)viewDidAppear:(BOOL)animated {
    UIView *targetView = self.leftMenuButton_3;
    YYUser *user = [YYUser currentUser];
    if(user.userType == YYUserTypeDesigner){
        targetView = self.leftMenuButton_4;
    }
    [YYGuideHandler showGuideView:GuideTypeTabMe parentView:self.view targetView:targetView];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateReadState) name:@"UpdateReadState" object:nil];
}
- (void)updateReadState{
    NSString *CFBundleVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if([CFBundleVersion integerValue] == 17)
    {
        _leftMenuNewTag_4.hidden = [YYUser getNewsReadStateWithType:2];
    }else
    {
        _leftMenuNewTag_4.hidden = YES;
    }
}
- (void)PrepareUI{
    [self initAndHiddenSomeButton];
    [self updateReadState];
}

#pragma mark - --------------UIConfig----------------------
-(void)initMessageLabel:(UILabel *)numberLabel parentButton:(UIButton*)btn{
    numberLabel.backgroundColor = [UIColor colorWithHex:@"ef4e31"];
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont boldSystemFontOfSize:11];
    numberLabel.numberOfLines = 1;
    numberLabel.textAlignment = NSTextAlignmentCenter;
    numberLabel.layer.cornerRadius = numFontSize/2;
    numberLabel.layer.masksToBounds = YES;
    __weak UIButton *_weakMenuButton = btn;

    [self.view addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakMenuButton.mas_centerY).with.offset(-numFontSize/2-20);
        make.width.equalTo(@(numFontSize));
        make.height.equalTo(@(numFontSize));
        make.right.equalTo(_weakMenuButton.mas_centerX).with.offset(numFontSize/2+15);
    }];
}
- (void)initAndHiddenSomeButton{
    NSInteger btnsCount = 0;
    NSInteger btnWidth = 0;

    YYUser *user = [YYUser currentUser];
    if(user.userType == YYUserTypeDesigner){
        btnsCount = 4;
        btnWidth = SCREEN_WIDTH/btnsCount;
        [self.leftMenuButton_0 setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
        [self.leftMenuButton_1 setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
        [self.leftMenuButton_2 setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
        [self.leftMenuButton_3 setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
        [self.leftMenuButton_4 hideByWidth:YES];
        [self.leftMenuButton_5 hideByWidth:YES];

        [self initButtonIcon:self.leftMenuButton_0 tag:LeftMenuButtonTypeOpus btnWidth:btnWidth];
        [self initButtonIcon:self.leftMenuButton_1 tag:LeftMenuButtonTypeOrder btnWidth:btnWidth];
        [self initButtonIcon:self.leftMenuButton_2 tag:LeftMenuButtonTypeBuyer btnWidth:btnWidth];
        [self initButtonIcon:self.leftMenuButton_3 tag:LeftMenuButtonTypeAccount btnWidth:btnWidth];

    }else{
        btnsCount = 3;
        btnWidth = SCREEN_WIDTH/btnsCount;
        [self.leftMenuButton_0 setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
        [self.leftMenuButton_1 setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
        [self.leftMenuButton_2 setConstraintConstant:btnWidth forAttribute:NSLayoutAttributeWidth];
        [self.leftMenuButton_3 hideByWidth:YES];
        [self.leftMenuButton_4 hideByWidth:YES];
        [self.leftMenuButton_5 hideByWidth:YES];

        [self initButtonIcon:self.leftMenuButton_0 tag:LeftMenuButtonTypeOpus btnWidth:btnWidth];
        [self initButtonIcon:self.leftMenuButton_1 tag:LeftMenuButtonTypeOrder btnWidth:btnWidth];
        [self initButtonIcon:self.leftMenuButton_2 tag:LeftMenuButtonTypeAccount btnWidth:btnWidth];

    }
    [self.view updateSizes];
}

-(void)initButtonIcon:(UIButton *)button tag:(NSInteger)tag btnWidth:(NSInteger)btnWidth{
    button.tag = tag;
    NSString *btnStr = [self getPageName:tag];
    NSString *normal_image_name = [NSString stringWithFormat:kNormalImageByIndex,button.tag-buttonTagOffset];
    NSString *selected_image_name = [NSString stringWithFormat:kSelectedImageByIndex,button.tag-buttonTagOffset];
    UIImage *btnImage = [UIImage imageNamed:normal_image_name];
    [button setImage:btnImage forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selected_image_name] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithHex:@"7d7d7d"] forState:UIControlStateNormal];
    [button setTitle:btnStr forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
    CGSize txtSize= [btnStr sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font} ];
    float imageWith = button.imageView.image.size.width;
    float imageHeight = button.imageView.image.size.height;
    float labelWidth = txtSize.width;
    float labelHeight =txtSize.height;
    CGFloat imageOffsetX = (imageWith + labelWidth) / 2 - imageWith / 2;
    CGFloat imageOffsetY = imageHeight / 2;
    button.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
    CGFloat labelOffsetX = (imageWith + labelWidth / 2) - (imageWith + labelWidth) / 2;
    CGFloat labelOffsetY = labelHeight / 2;
    button.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
    button.contentEdgeInsets = UIEdgeInsetsMake(10,-20,-10,-20);
}

//#pragma mark - --------------请求数据----------------------
//-(void)RequestData{}

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (IBAction)buttonAction:(id)sender{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate checkNoticeCount];

    UIButton *button = (UIButton *)sender;

    if (button == _leftMenuButton_5) {
        if (self.leftMenuButtonClicked) {
            self.leftMenuButtonClicked(button.tag);
        }
    }else{
        if (button != _currentSelectedButton) {
            [self updateSelectedButton:button];
        }
    }
}

#pragma mark - --------------自定义方法----------------------
-(NSString *)getPageName:(NSInteger)tag{
    if(tag ==LeftMenuButtonTypeIndex){
        return NSLocalizedString(@"首页",nil);
    }else if(tag == LeftMenuButtonTypeOpus){
        return NSLocalizedString(@"作品",nil);
    }else if(tag == LeftMenuButtonTypeOrder){
        return NSLocalizedString(@"订单",nil);
    }else if(tag == LeftMenuButtonTypeAccount){
        return NSLocalizedString(@"我的",nil);
    }else if (tag == LeftMenuButtonTypeBrand){
        return NSLocalizedString(@"品牌",nil);
    }else if(tag == LeftMenuButtonTypeSetting){
        return NSLocalizedString(@"设置",nil);
    }else if(tag == LeftMenuButtonTypeBuyer){
        return NSLocalizedString(@"买手店",nil);
    }
    return @"";
}
- (void)updateButtonNumber:(UILabel *)numberLabel num:(NSString *)nowNumber{
    if(!numberLabel){
        return;
    }
    if (nowNumber && ![nowNumber isEqualToString:@""]) {
        CGSize numTxtSize = [nowNumber sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:6]}];
        NSInteger numTxtWidth = numTxtSize.width;
        if ([nowNumber length] >= 3) {
            numberLabel.text = @"···";//[NSString stringWithFormat:@"%@",nowNumber];
        }else{
            numTxtWidth += numFontSize/2;
            numberLabel.text = nowNumber;
        }
        numberLabel.hidden = NO;
        numTxtWidth = MAX(numTxtWidth, numFontSize);
        [numberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(numTxtWidth));
        }];
    }else{
        numberLabel.hidden = YES;
    }
}

- (void)setButtonSelectedByButtonIndex:(LeftMenuButtonType)leftMenuButtonIndex{
    UIButton *button = (UIButton *)[self.view viewWithTag:leftMenuButtonIndex];
    if (button) {
        [self updateSelectedButton:button];
    }
}

- (void)updateSelectedButton:(UIButton *)button{

    if (_currentSelectedButton != button) {
        UIButton *oldButton = _currentSelectedButton;
        if (oldButton) {

            NSString *normal_image_name = [NSString stringWithFormat:kNormalImageByIndex,_currentSelectedButton.tag-buttonTagOffset];
            NSString *selected_image_name = [NSString stringWithFormat:kSelectedImageByIndex,_currentSelectedButton.tag-buttonTagOffset];

            [oldButton setImage:[UIImage imageNamed:normal_image_name] forState:UIControlStateNormal];
            [oldButton setImage:[UIImage imageNamed:selected_image_name] forState:UIControlStateHighlighted];
            [oldButton setTitleColor:[UIColor colorWithHex:@"7d7d7d"] forState:UIControlStateNormal];
        }

        UIButton *nowButton = button;
        if (nowButton) {

            NSString *selected_image_name = [NSString stringWithFormat:kSelectedImageByIndex,button.tag-buttonTagOffset];

            [nowButton setImage:[UIImage imageNamed:selected_image_name] forState:UIControlStateNormal];
            [nowButton setImage:[UIImage imageNamed:selected_image_name] forState:UIControlStateHighlighted];
            [nowButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];

        }

        _currentSelectedButton = button;

    }else{
        UIButton *nowButton = button;
        if (nowButton) {
            NSInteger index = button.tag-buttonTagOffset;
            NSString *selected_image_name = [NSString stringWithFormat:kSelectedImageByIndex,(long)index];

            [nowButton setImage:[UIImage imageNamed:selected_image_name] forState:UIControlStateNormal];
            [nowButton setImage:[UIImage imageNamed:selected_image_name] forState:UIControlStateHighlighted];
            [nowButton setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];

        }

    }
    if (self.leftMenuButtonClicked) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.leftMenuIndex = _currentSelectedButton.tag;
        self.leftMenuButtonClicked(_currentSelectedButton.tag);
    }
}

#pragma mark - --------------other----------------------

@end

