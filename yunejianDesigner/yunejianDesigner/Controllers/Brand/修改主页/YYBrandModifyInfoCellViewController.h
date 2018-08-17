//
//  YYBuyerModifyInfoTxtViewController.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YYBrandModifyInfoCellViewType) {
    YYBrandModifyInfoCellViewArea = 0,
    YYBrandModifyInfoCellViewDetailAddress = 1,
    YYBrandModifyInfoCellViewDesc ,
    YYBrandModifyInfoCellViewPrice,
    YYBrandModifyInfoCellViewConnBrand,
    YYBrandModifyInfoCellViewWebsite,
    YYBrandModifyInfoCellViewSocial,
    YYBrandModifyInfoCellViewContactTxt,
    YYBrandModifyInfoCellViewContactMobile,
    YYBrandModifyInfoCellViewContactTelephone
};
@interface YYBrandModifyInfoCellViewController : UIViewController
@property (nonatomic,strong)CancelButtonClicked cancelButtonClicked;
@property (nonatomic,strong)SelectedValue saveButtonClicked;

@property (nonatomic ,assign) NSInteger viewType;
@property (nonatomic ,strong) NSString *detailType;
@property (nonatomic ,strong) NSString *value;

@end
