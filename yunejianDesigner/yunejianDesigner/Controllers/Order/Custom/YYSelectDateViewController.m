//
//  YYSelectDateViewController.m
//  Yunejian
//
//  Created by yyj on 15/8/19.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYSelectDateViewController.h"

@interface YYSelectDateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation YYSelectDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    _datePicker.locale = locale;
    
    
//    double  oneYear = 60*60*24*1000*365.0;  //1年的毫秒数
//   
//    
//    NSDate *begingDate = nil;
//    NSDate *endDate = nil;
    
    if (self.currentYYOrderInfoModel
        && self.currentYYOrderInfoModel.orderCreateTime) {

        
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        NSDate* date = _datePicker.date;
        
        [self.datePicker setDate:date];
        NSTimeInterval time = [date timeIntervalSince1970]*1000;
        
        self.selectedDateString = [NSString stringWithFormat:@"%f",time];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateSelected:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    
    
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    
    self.selectedDateString = [NSString stringWithFormat:@"%f",time];
}


@end
