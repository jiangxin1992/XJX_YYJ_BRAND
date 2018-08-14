//
//  YYHelpPanelViewController.m
//  yunejianDesigner
//
//  Created by Apple on 16/7/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYHelpPanelViewController.h"
#import "UIImage+Tint.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
@interface YYHelpPanelViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView1;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn1;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel1;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn2;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel2;

@end

@implementation YYHelpPanelViewController
static NSArray *helpContentData = nil;
//static dispatch_once_t onceToken;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     // helpPanelType
    
    //static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        helpContentData = @[@[NSLocalizedString(@"品牌主要联系人",nil),NSLocalizedString(@"主要联系人将视为品牌账号的拥有者，建议填写设计师本人。主要联系人可以建立多个销售代表账号管理品牌的作品和订单。",nil)],
                            @[NSLocalizedString(@"主要联系人电话",nil),NSLocalizedString(@"主要联系人电话，将只有YCO System工作人员可见，便于YCO System在第一时间与您联系。",nil)],
                            @[NSLocalizedString(@"折扣 = (税前总价+税金) x (1-打折%)",nil),NSLocalizedString(@"折扣是针对税后价格打折,买手店不能够编辑折扣。",nil),NSLocalizedString(@"实付 = 税前总价 + 税金 - 折扣",nil),NSLocalizedString(@"除人民币外的其他币种,不提供加税功能。",nil)]];
//    });
    float contentViewWidth = MIN(292, SCREEN_WIDTH-30);
    float contentViewHeight = 0;
    _contentView.hidden = YES;
    _contentView1.hidden = YES;
    NSArray *helpContentArr = [helpContentData objectAtIndex:(_helpPanelType-1)];
    if(_helpPanelType < HelpPanelTypeTax){
       _contentView.hidden = NO;
        contentViewHeight = 128-31
        ;
        self.contentView.layer.borderWidth = 4;
        self.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        [_titleBtn setImage:[[UIImage imageNamed:@"infohelp_icon"] imageWithTintColor:[UIColor blackColor]] forState:UIControlStateNormal];

        [_titleBtn setTitle:helpContentArr[0] forState:UIControlStateNormal];
        NSString *helpContent = helpContentArr[1];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 10;
        NSDictionary *attDic = @{NSParagraphStyleAttributeName: paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSInteger hasHeight = getTxtHeight(contentViewWidth-48, helpContent, attDic);
        _txtLabel.attributedText = [[NSAttributedString alloc] initWithString:helpContent attributes:attDic];
        contentViewHeight = contentViewHeight+hasHeight;
        [_contentView setConstraintConstant:contentViewWidth forAttribute:NSLayoutAttributeWidth];
        [_contentView setConstraintConstant:contentViewHeight forAttribute:NSLayoutAttributeHeight];
    }else{
        _contentView1.hidden = NO;
        contentViewHeight = 128-9;
        self.contentView1.layer.borderWidth = 4;
        self.contentView1.layer.borderColor = [UIColor blackColor].CGColor;
        [_titleBtn1 setTitle:helpContentArr[0] forState:UIControlStateNormal];
        [_titleBtn2 setTitle:helpContentArr[2] forState:UIControlStateNormal];
        NSString *helpContent = helpContentArr[1];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 1;
        NSDictionary *attDic = @{NSParagraphStyleAttributeName: paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:13]};
        NSInteger hasHeight = getTxtHeight(contentViewWidth-34, helpContent, attDic);
        [_txtLabel1 setConstraintConstant:hasHeight forAttribute:NSLayoutAttributeHeight];
        _txtLabel1.attributedText = [[NSAttributedString alloc] initWithString:helpContent attributes:attDic];
        contentViewHeight = contentViewHeight+hasHeight;
        helpContent = helpContentArr[3];
        hasHeight = getTxtHeight(contentViewWidth-34, helpContent, attDic);
        [_txtLabel2 setConstraintConstant:hasHeight forAttribute:NSLayoutAttributeHeight];
        _txtLabel2.attributedText = [[NSAttributedString alloc] initWithString:helpContent attributes:attDic];
        contentViewHeight = contentViewHeight+hasHeight;
        [_contentView1 setConstraintConstant:contentViewWidth forAttribute:NSLayoutAttributeWidth];
        [_contentView1 setConstraintConstant:contentViewHeight forAttribute:NSLayoutAttributeHeight];
    }

    popWindowAddBgView(self.view);
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

- (IBAction)closeHandler:(id)sender {
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}
@end
