//
//  YYAlertViewController.m
//  Yunejian
//
//  Created by Apple on 15/11/9.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYAlertViewController.h"

@interface YYAlertViewController ()

@end

@implementation YYAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_titleBtn setTitle:_titelStr forState:UIControlStateNormal];
    NSArray *msgArr = [_msgStr componentsSeparatedByString:@"|"];
    NSInteger oldHeight = 200;
    //NSInteger oldTop = 270;
    NSString *newMsg = [msgArr componentsJoinedByString:@"\n"];
    CGSize textSize = [_msgStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    NSInteger needHeight = textSize.height*([msgArr count]);
    self.msgLabel.textAlignment = _textAlignment;
    self.msgLabel.text = newMsg;
    if([_msgStr isEqualToString:@""]){
        _ttitleSpaceLayoutConstraint.constant = 0;
        needHeight =needHeight-23;
    }else{
        _ttitleSpaceLayoutConstraint.constant = 23;
    }
    _layoutHeightConstraints.constant = oldHeight+needHeight+1;
    //_layoutTopConstraints.constant = oldTop -needHeight/2;
    if(_widthConstraintsValue > 0){
        _layoutWidthConstraints.constant = _widthConstraintsValue;
    }else{
        _layoutWidthConstraints.constant = 620;
    }
    if(self.btnStr){
        [self.submitBtn setTitle:self.btnStr forState:UIControlStateNormal];
    }
    self.closeBtn.hidden = !_needCloseBtn;
    UIView *yellowView = [self.view viewWithTag:10001];
    yellowView.layer.cornerRadius = 5;
    _submitBtn.layer.cornerRadius= 2.5;
    _submitBtn.layer.masksToBounds = YES;
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

- (IBAction)btnClicked:(id)sender {
    if(self.cancelButtonClicked){
        self.cancelButtonClicked(@"makesure");
    }
}
- (IBAction)closeHandler:(id)sender {
    if(self.cancelButtonClicked){
        self.cancelButtonClicked(@"close");
    }
}
@end
