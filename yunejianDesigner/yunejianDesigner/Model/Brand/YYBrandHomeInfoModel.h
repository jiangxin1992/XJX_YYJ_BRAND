//
//  YYDesignerHomeInfoModel.h
//  YunejianBuyer
//
//  Created by yyj on 2017/2/4.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "YYBuyerSocialInfoModel.h"
#import "YYBuyerContactInfoModel.h"

@interface YYBrandHomeInfoModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*webUrl;//
@property (strong, nonatomic) NSArray <Optional, ConvertOnDemand>*indexPics;//
@property (strong, nonatomic) NSArray<YYBuyerContactInfoModel,Optional, ConvertOnDemand>* userContactInfos;
@property (strong, nonatomic) NSNumber <Optional>*brandId;//
@property (strong, nonatomic) NSArray <Optional, ConvertOnDemand>*retailerName;//
@property (strong, nonatomic) NSNumber <Optional>*connectStatus;
@property (strong, nonatomic) NSArray<YYBuyerSocialInfoModel,Optional, ConvertOnDemand>* userSocialInfos;
@property (strong, nonatomic) NSNumber <Optional>*percent;//
@property (strong, nonatomic) NSString <Optional>*brandIntroduction;//
@property (strong, nonatomic) NSString <Optional>*brandName;//
@property (strong, nonatomic) NSString <Optional>*email;//
@property (strong, nonatomic) NSString <Optional>*logoPath;
@property (strong, nonatomic) NSString <Optional>*designerName;

@property (strong, nonatomic) NSNumber <Optional>*pickerRow;
@property (strong, nonatomic) NSNumber <Optional>*pickerComponent;

@property (strong, nonatomic) NSString <Optional>*legalPersonFiles;
@property (strong, nonatomic) NSString <Optional>*licenceFile;

//storeImgs首张图
-(NSString *)getStoreImgCover;

@end
