//
//  YYSupplyStatusView.m
//  Yunejian
//
//  Created by yyj on 15/8/25.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYSupplyStatusView.h"

@interface YYSupplyStatusView ()

@property (weak, nonatomic) IBOutlet UILabel *supplyLabel;


//@property (weak, nonatomic) IBOutlet UILabel *endSupplyTipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *endSupplyLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation YYSupplyStatusView

- (void)updateUI{
//    if (_hiddenEndSupplyTipsLabel) {
//        _endSupplyTipsLabel.hidden = YES;
//    }

    _progressView.layer.cornerRadius = 4;
    _progressView.layer.masksToBounds = YES;
    _progressView.layer.borderWidth = 2;
    _progressView.layer.borderColor = [[UIColor colorWithHex:@"efefef"] CGColor];
    if (_orderSupplyTimeModel) {
        
        NSString *endDay = NSLocalizedString(@"无",nil);
        
//        if (_orderSupplyTimeModel.supplyEndTime) {
//            endDay = getShowDateByFormatAndTimeInterval(@"yy.MM.dd",[_orderSupplyTimeModel.supplyEndTime stringValue]);
//        }
        NSInteger txtlength = 0;
        if ([_orderSupplyTimeModel.supplyStatus intValue] == 0) {
            //_daysLabel.hidden = YES;
            //_day02Label.hidden = YES;
            //_supplyLabel.text = NSLocalizedString(@"马上发货",nil);
            endDay = NSLocalizedString(@"马上发货",nil);
            txtlength = endDay.length;
        }else{
            endDay = [NSString stringWithFormat:@"%@ %@",[_orderSupplyTimeModel.dayRemains stringValue],NSLocalizedString(@"天",nil)];
            txtlength = endDay.length-1;
        }
        

        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString: endDay];
        [attributedStr addAttribute: NSFontAttributeName value: [UIFont systemFontOfSize:12] range: NSMakeRange(txtlength, endDay.length-txtlength)];
        [attributedStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithHex:@"919191"] range: NSMakeRange(txtlength, endDay.length-txtlength)];
        _endSupplyLabel.attributedText = attributedStr;
        //_endSupplyLabel.text = endDay;
    
        
        if (!_orderSupplyTimeModel.supplyEndTime || [_orderSupplyTimeModel.supplyStatus intValue] == 0) {
            //没有截止日期或有现货
            UIColor *tempLightGrayColor = [UIColor lightGrayColor];
            _progressView.progressTintColor = tempLightGrayColor;
            _progressView.trackTintColor = [UIColor colorWithHex:@"a5a5a5"];
            _progressView.progress = 1.0;
        }else{
            if ([_orderSupplyTimeModel.dayRemains intValue] > 30) {
                //离有截止日期30天以上
                UIColor *tempLightGrayColor = [UIColor grayColor];
                _progressView.progressTintColor = tempLightGrayColor;
                _progressView.trackTintColor = tempLightGrayColor;
                _progressView.progress = 1.0;
            }else{
                _progressView.progressTintColor = [UIColor colorWithHex:@"efefef"];
                _progressView.trackTintColor = [UIColor colorWithHex:@"ed6498"];
                
                float passDay = 30 - [_orderSupplyTimeModel.dayRemains intValue];
                
                _progressView.progress = passDay/30;
            }
        }
    }
    

}

@end
