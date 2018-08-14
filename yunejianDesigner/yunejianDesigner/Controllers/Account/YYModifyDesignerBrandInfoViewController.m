//
//  YYModifyDesignerBrandInfoViewController.m
//  Yunejian
//
//  Created by yyj on 15/7/20.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYModifyDesignerBrandInfoViewController.h"
#import "YYRspStatusAndMessage.h"
#import "YYUserApi.h"

#import "UITextField+YYRectForBounds.h"
#import "RegexKitLite.h"

static CGFloat yellowView_default_constant = 112;

@interface YYModifyDesignerBrandInfoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *brandUrlField;
@property (weak, nonatomic) IBOutlet UITextField *buyerStoreNumbersField;
@property (weak, nonatomic) IBOutlet UITextField *buyerStore01Field;
@property (weak, nonatomic) IBOutlet UITextField *buyerStore02Field;
@property (weak, nonatomic) IBOutlet UITextField *buyerStore03Field;
@property (weak, nonatomic) IBOutlet UITextField *salePerYearField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yellowViewTopLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIView *yellowView;

@end

@implementation YYModifyDesignerBrandInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    popWindowAddBgView(self.view);
    
    _buyerStoreNumbersField.keyboardType = UIKeyboardTypeNumberPad;
    _salePerYearField.keyboardType = UIKeyboardTypeDecimalPad;
    
    
    _brandUrlField.delegate = self;
    _buyerStoreNumbersField.delegate = self;
    _buyerStore01Field.delegate = self;
    _buyerStore02Field.delegate = self;
    _buyerStore03Field.delegate = self;
    _salePerYearField.delegate = self;
    
    [self updateUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI{
    
    if (_currenDesingerBrandInfoModel) {
        if (_currenDesingerBrandInfoModel.brandName) {
            _brandUrlField.text = _currenDesingerBrandInfoModel.webUrl;
        }
        
        if (_currenDesingerBrandInfoModel.underlinePartnerCount) {
            _buyerStoreNumbersField.text =  [NSString stringWithFormat:@"%i",[_currenDesingerBrandInfoModel.underlinePartnerCount intValue]];
        }
        
        if (_currenDesingerBrandInfoModel.annualSales) {
            _salePerYearField.text =  [NSString stringWithFormat:@"%0.2f",[_currenDesingerBrandInfoModel.annualSales floatValue]];
        }
        
        if (_currenDesingerBrandInfoModel.retailerName) {
            
            
            NSArray *names = _currenDesingerBrandInfoModel.retailerName;
            if (names
                && [names count] > 0) {
                _buyerStore01Field.text = names[0];
                if ([names count] > 1) {
                    _buyerStore02Field.text = names[1];
                }
                
                if ([names count] > 2) {
                    _buyerStore03Field.text = names[2];
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
     NSString *url = trimWhitespaceOfStr(_brandUrlField.text);
     NSString *numbers = trimWhitespaceOfStr(_buyerStoreNumbersField.text);
     NSString *storeName01 = trimWhitespaceOfStr(_buyerStore01Field.text);
     NSString *storeName02 = trimWhitespaceOfStr(_buyerStore02Field.text);
     NSString *storeName03 = trimWhitespaceOfStr(_buyerStore03Field.text);
     NSString *perYear = trimWhitespaceOfStr(_salePerYearField.text);
    
    
    if (! url || [url length] == 0) {
        
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入品牌网站地址",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    BOOL isWebUrl = [url isMatchedByRegex: @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"];
    if (!isWebUrl) {
        [YYToast showToastWithTitle:NSLocalizedString(@"网站格式不对！",nil) andDuration:kAlertToastDuration];
        return;
    }
    

    
    if (! numbers || [numbers length] == 0) {
        
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入买手店合作数量",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    BOOL isNumbers = [numbers isMatchedByRegex:@"^[0-9]*$"];
    if (!isNumbers) {
        [YYToast showToastWithTitle:NSLocalizedString(@"合作数量请输入数字！",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    if ((! storeName01 || [storeName01 length] == 0)
        && (! storeName02 || [storeName02 length] == 0)
        && (! storeName03 || [storeName03 length] == 0)) {
        
        [YYToast showToastWithTitle:NSLocalizedString(@"至少输入一家合作买手店名称",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    NSString *names = @"";
    if (storeName01 && [storeName01 length]>0) {
        names = [names stringByAppendingString:storeName01];
    }

    if (storeName02 && [storeName02 length]>0) {
        if ([names length] > 0) {
            names = [names stringByAppendingString:@","];
        }
        names = [names stringByAppendingString:storeName02];
    }

    if (storeName03 && [storeName03 length]>0) {
        if ([names length] > 0) {
            names = [names stringByAppendingString:@","];
        }
        names = [names stringByAppendingString:storeName03];
    }
    
    
    
    if (! perYear || [perYear length] == 0) {
        
        [YYToast showToastWithTitle:NSLocalizedString(@"请输入年销售额",nil) andDuration:kAlertToastDuration];
        return;
    }
    
    BOOL isFloat = [perYear isMatchedByRegex:@"^[0-9]+(.[0-9]{2})?$"];
    if (!isFloat) {
        [YYToast showToastWithTitle:NSLocalizedString(@"年销售额格式不对！",nil) andDuration:kAlertToastDuration];
        return;
    }

    
    [YYUserApi brandInfoUpdateByBrandName:_currenDesingerBrandInfoModel.brandName
                                   webUrl:url
                    underLinePartnerCount:[numbers intValue]
                              annualSales:[perYear floatValue]
                             retailerName:names
                                 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
                                     if (rspStatusAndMessage.status == YYReqStatusCode100) {
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
