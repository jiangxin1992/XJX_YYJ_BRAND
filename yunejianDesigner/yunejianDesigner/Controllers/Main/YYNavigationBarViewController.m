//
//  YYNavigationBarViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/13.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYNavigationBarViewController.h"

@interface YYNavigationBarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *goBackButton;
@property (weak, nonatomic) IBOutlet UIButton *previousTitleButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation YYNavigationBarViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
    [_titleLabel setAdjustsFontSizeToFitWidth:YES];
    [_previousTitleButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
}

- (void)updateUI{
    if (_nowTitle) {
        _titleLabel.text = _nowTitle;
    }
    
    if (_previousTitle) {
        [_previousTitleButton setTitle:_previousTitle forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender{
    NSLog(@"go back ");
    if (self.navigationButtonClicked) {
        self.navigationButtonClicked(NavigationButtonTypeGoBack);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
