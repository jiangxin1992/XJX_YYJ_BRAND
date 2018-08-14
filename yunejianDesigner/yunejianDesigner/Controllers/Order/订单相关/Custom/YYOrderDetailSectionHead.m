//
//  YYOrderDetailSectionHead.m
//  Yunejian
//
//  Created by Apple on 15/8/17.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYOrderDetailSectionHead.h"

@interface YYOrderDetailSectionHead ()

@property (weak, nonatomic) IBOutlet UILabel *seriesLabel;
//@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliverGoodsLabel;//发货

//@property (weak, nonatomic) IBOutlet UIView *selectDateView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countLabelLayoutRightConstraint;

@end

@implementation YYOrderDetailSectionHead

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUI{
    //_countLabel.hidden = YES;
    if (_orderOneInfoModel) {
        if(_orderOneInfoModel.dateRange && _orderOneInfoModel.dateRange.id){
            _seriesLabel.text = [NSString stringWithFormat:@"%@",_orderOneInfoModel.dateRange.name];//;
        }else{
            //_seriesLabel.text = _orderOneInfoModel.seriesName;
            _seriesLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"马上发货",nil)];//NSLocalizedString(@"发货日期  马上发货",nil);
        }
        
        if (_orderOneInfoModel.dateRange && [_orderOneInfoModel.dateRange.id integerValue] > 0) {
            NSString *string = [NSString stringWithFormat:@"%@",[_orderOneInfoModel.dateRange.start stringValue]];
            NSString *beginDate = getShowDateByFormatAndTimeInterval(@"yy/MM/dd",string);
            string = [NSString stringWithFormat:@"%@",[_orderOneInfoModel.dateRange.end stringValue]];
            NSString *endDate = getShowDateByFormatAndTimeInterval(@"yy/MM/dd",string);
            NSString *showValue = [NSString stringWithFormat:@"%@-%@", beginDate,endDate];
                    
            _deliverGoodsLabel.text = showValue;
        }else{
            _deliverGoodsLabel.text = @"";
        }
    }
}



@end
