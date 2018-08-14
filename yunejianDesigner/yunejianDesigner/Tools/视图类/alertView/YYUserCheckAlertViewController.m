//
//  YYUserCheckAlertViewController.m
//  Yunejian
//
//  Created by Apple on 15/12/9.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYUserCheckAlertViewController.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图

// 接口

// 分类
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

@interface YYUserCheckAlertViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIButton *doBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *helpTitleBtn1;
@property (weak, nonatomic) IBOutlet UIButton *helpTitleBtn2;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel1;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colseBtnTopLayout;

@end

@implementation YYUserCheckAlertViewController
#pragma mark - --------------生命周期--------------
- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
    [self UIConfig];
//    [self RequestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{

    _closeBtn.hidden = NO;

    _doBtn.layer.cornerRadius = 2.5;
    _doBtn.layer.masksToBounds =YES;
    
    _colseBtnTopLayout.constant = kStatusBarHeight;


    _colseBtnTopLayout.constant = kStatusBarHeight;

}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    NSArray *msgArr = [_msgStr componentsSeparatedByString:@"|"];
    NSString *newMsg = [msgArr componentsJoinedByString:@"\n"];
    NSDictionary *attrDict = @{ NSFontAttributeName: [UIFont systemFontOfSize: 14] };

    NSMutableAttributedString *attributedStr1 = [[NSMutableAttributedString alloc] initWithString: newMsg];
    NSRange range = [newMsg rangeOfString:_titelStr];
    if (range.location != NSNotFound) {
        [attributedStr1 addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHex:@"ef4e31"] range:range];
        [attributedStr1 addAttribute: NSFontAttributeName value: [UIFont boldSystemFontOfSize:16] range:range];
        attrDict = @{ NSFontAttributeName: [UIFont boldSystemFontOfSize:16] };
    }
    _descLabel.attributedText = attributedStr1;

    float needTxtHeight = getTxtHeight(SCREEN_WIDTH-34, newMsg, attrDict);
    _descLabel.textAlignment = _textAlignment;
    [_descLabel setConstraintConstant:needTxtHeight forAttribute:NSLayoutAttributeHeight];

    NSDictionary *helptxtAttrDict = @{NSFontAttributeName: _helpTitleBtn1.titleLabel.font};
    [_helpTitleBtn1 setTitle:NSLocalizedString(@"为什么要进行品牌验证？",nil) forState:UIControlStateNormal];
    NSString *helpTxt1 = NSLocalizedString(@"为保障 YCO SYSTEM 平台上的品牌是资质健全的独立设计师品牌,我们需要对品牌的营业资质进行审核。",nil);
    needTxtHeight = getTxtHeight(SCREEN_WIDTH-60, helpTxt1, helptxtAttrDict);
    _helpLabel1.text = helpTxt1;
    [_helpLabel1 setConstraintConstant:needTxtHeight forAttribute:NSLayoutAttributeHeight];

    helptxtAttrDict = @{NSFontAttributeName: _helpTitleBtn2.titleLabel.font};
    [_helpTitleBtn2 setTitle:NSLocalizedString(@"不验证品牌会有什么影响？",nil) forState:UIControlStateNormal];
    NSString *helpTxt2 = NSLocalizedString(@"在入驻 YCO SYSTEM 30天内,未验证的品牌不能查看平台上的买手店,品牌主页也无法被任何买手店访问到。验证截止日期之后,品牌将无法使用 YCO SYSTEM。",nil);
    needTxtHeight = getTxtHeight(SCREEN_WIDTH-60, helpTxt2, helptxtAttrDict);
    _helpLabel2.text = helpTxt2;
    [_helpLabel2 setConstraintConstant:needTxtHeight forAttribute:NSLayoutAttributeHeight];
    [_scrollView layoutSubviews];
}

//#pragma mark - --------------请求数据----------------------
//-(void)RequestData{}

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (IBAction)closeBtnHandler:(id)sender {
    if(self.cancelButtonClicked){
        self.cancelButtonClicked();
    }
}

- (IBAction)doBtnHandler:(id)sender {
    if(self.modifySuccess){
        self.modifySuccess();
    }
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

@end
