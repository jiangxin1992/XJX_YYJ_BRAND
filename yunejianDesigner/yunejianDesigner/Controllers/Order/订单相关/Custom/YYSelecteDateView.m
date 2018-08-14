//
//  YYSelecteDateView.m
//  Yunejian
//
//  Created by yyj on 15/8/19.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYSelecteDateView.h"

@interface YYSelecteDateView ()

@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;

@end

@implementation YYSelecteDateView


- (void)updateUI{
    self.beginButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.beginButton.layer.borderWidth = 1;
    
    self.endButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.endButton.layer.borderWidth = 1;
    
//    if (_orderOneInfoModel) {
//        NSString *string = [NSString stringWithFormat:@"%@",[_orderOneInfoModel.supplyStartTime stringValue]];
//        NSString *beginDate = getShowDateByFormatAndTimeInterval(@"yy年MM月dd日",string);
//        [_beginButton setTitle:beginDate forState:UIControlStateNormal];
//        
//        string = [NSString stringWithFormat:@"%@",[_orderOneInfoModel.supplyEndTime stringValue]];
//        NSString *endDate = getShowDateByFormatAndTimeInterval(@"yy年MM月dd日",string);
//        [_endButton setTitle:endDate forState:UIControlStateNormal];
//    }
//    
//    [_beginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//     [_endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//
//    if (_orderOneInfoModel.tmpSupplyStartTime != nil && _orderOneInfoModel.tmpSupplyEndTime != nil){
//        if([_orderOneInfoModel.supplyStartTime doubleValue] < [_orderOneInfoModel.tmpSupplyStartTime doubleValue]){
//            [_beginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        }    
//        if([_orderOneInfoModel.supplyEndTime doubleValue] > [_orderOneInfoModel.tmpSupplyEndTime doubleValue]){
//            [_endButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        }
//        if([_orderOneInfoModel.supplyStartTime doubleValue] > [_orderOneInfoModel.supplyEndTime doubleValue]){
//            [_beginButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//            [_endButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        }
//    }

}

- (IBAction)beginButtonClicked:(id)sender{
    if (_selectDateButtonClicked) {
        self.selectDateButtonClicked(YES,(UIView *)sender,_orderOneInfoModel);
    }
}

- (IBAction)endButtonClicked:(id)sender{
    if (_selectDateButtonClicked) {
        self.selectDateButtonClicked(NO,(UIView *)sender,_orderOneInfoModel);
    }
}

@end
