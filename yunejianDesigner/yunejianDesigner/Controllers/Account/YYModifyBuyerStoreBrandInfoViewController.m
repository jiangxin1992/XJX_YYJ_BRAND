//
//  YYModifyBuyerStoreBrandInfoViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYModifyBuyerStoreBrandInfoViewController.h"
#import "YYRspStatusAndMessage.h"
#import "YYUserApi.h"

static CGFloat yellowView_default_constant = 112;

@interface YYModifyBuyerStoreBrandInfoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UITextField *priceMinField;
@property (weak, nonatomic) IBOutlet UITextField *priceMaxField;
@property (weak, nonatomic) IBOutlet UITextField *name01Field;
@property (weak, nonatomic) IBOutlet UITextField *name02Field;
@property (weak, nonatomic) IBOutlet UITextField *name03Field;
@property (weak, nonatomic) IBOutlet UITextField *otherNameField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yellowViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *yellowView;

@end

@implementation YYModifyBuyerStoreBrandInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    popWindowAddBgView(self.view);
    
    _yearField.delegate = self;
    _priceMinField.delegate = self;
    _priceMaxField.delegate = self;
    _name01Field.delegate = self;
    _name02Field.delegate = self;
    _name03Field.delegate = self;
    _otherNameField.delegate = self;
    
    _yearField.keyboardType = UIKeyboardTypeNumberPad;
    _priceMinField.keyboardType = UIKeyboardTypeDecimalPad;
    _priceMaxField.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self updateUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI{
    if (_currenBuyerStoreModel) {
        if (_currenBuyerStoreModel.foundYear) {
            _yearField.text = _currenBuyerStoreModel.foundYear;
        }
        
        if (_currenBuyerStoreModel.priceMin) {
            _priceMinField.text = [NSString stringWithFormat:@"%f",[_currenBuyerStoreModel.priceMin floatValue]];
        }
        
        if (_currenBuyerStoreModel.priceMax) {
            _priceMaxField.text = [NSString stringWithFormat:@"%f",[_currenBuyerStoreModel.priceMax floatValue]];
        }
        
        if (_currenBuyerStoreModel.businessBrands) {
 
            NSArray *names = _currenBuyerStoreModel.businessBrands;
            if (names
                && [names count] > 0) {
                _name01Field.text = names[0];
                if ([names count] > 1) {
                    _name02Field.text = names[1];
                }
                
                if ([names count] > 2) {
                    _name03Field.text = names[2];
                }
                
                if ([names count] > 3) {
                   __block NSString *otherName = @"";
                    [names enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if (idx >= 3) {
                            if ([otherName length] > 0) {
                                otherName = [otherName stringByAppendingString:@","];
                            }
                            otherName = [otherName stringByAppendingString:(NSString *)obj];
                        }
                    }];
                    
                    _otherNameField.text = otherName;
                }
                
            }
        }

    }
}

- (IBAction)cancelClicked:(id)sender{
    if (_cancelButtonClicked) {
        _cancelButtonClicked();
    }
}

- (IBAction)saveClicked:(id)sender{
   
    NSString *year = trimWhitespaceOfStr(_yearField.text);
    NSString *priceMin = trimWhitespaceOfStr(_priceMinField.text);
    NSString *priceMax = trimWhitespaceOfStr(_priceMaxField.text);
    
    NSString *name01 = trimWhitespaceOfStr(_name01Field.text);
    NSString *name02 = trimWhitespaceOfStr(_name02Field.text);
    NSString *name03 = trimWhitespaceOfStr(_name03Field.text);
    NSString *other = trimWhitespaceOfStr(_otherNameField.text);
    
    
    if (! year || [year length] == 0) {
        
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入建店年份",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if (! priceMin || [priceMin length] == 0) {
        
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入批发最低价",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if (! priceMax || [priceMax length] == 0) {
        
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入批发最高价",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if ((! name01 || [name01 length] == 0)
        && (! name02 || [name02 length] == 0)
        && (! name03 || [name03 length] == 0)) {
        
        [YYToast showToastWithTitle:NSLocalizedString(@"至少输入一家合作品牌名称",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    NSString *names = @"";
    if (name01 && [name01 length]>0) {
        names = [names stringByAppendingString:name01];
    }
    
    if (name02 && [name02 length]>0) {
        if ([names length] > 0) {
            names = [names stringByAppendingString:@","];
        }
        names = [names stringByAppendingString:name02];
    }
    
    if (name03 && [name03 length]>0) {
        if ([names length] > 0) {
            names = [names stringByAppendingString:@","];
        }
        names = [names stringByAppendingString:name03];
    }
    
    if (other && [other length] > 0) {
        names = [names stringByAppendingString:@","];
        names = [names stringByAppendingString:other];
    }

    
    
    YYBuyerStoreModel *nowBuyerStoreModel = [[YYBuyerStoreModel alloc] init];
    nowBuyerStoreModel.name = _currenBuyerStoreModel.name;
    nowBuyerStoreModel.foundYear = year;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    nowBuyerStoreModel.priceMin = [numberFormatter numberFromString:priceMin];
    nowBuyerStoreModel.priceMax = [numberFormatter numberFromString:priceMax];
    nowBuyerStoreModel.businessBrands = [names componentsSeparatedByString:@","];
    
    [YYUserApi storeUpdateByBuyerStoreModel:nowBuyerStoreModel andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if (rspStatusAndMessage.status == kCode100) {
            [YYToast showToastWithTitle:NSLocalizedString(@"修改成功！",nil) andDuration:kAlertToastDuration];
            if (_modifySuccess) {
                _modifySuccess();
            }
        }else{
            [YYToast showToastWithTitle:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
    
    
}


@end
