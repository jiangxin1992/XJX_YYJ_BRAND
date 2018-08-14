//
//  YYBrandHomeUpdateModel.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"
#import "YYBuyerSocialInfoModel.h"
#import "YYBuyerContactInfoModel.h"
@interface YYBrandHomeUpdateModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*brandName;//

@property (strong, nonatomic) NSString <Optional>*webUrl;//
@property (strong, nonatomic) NSArray <Optional, ConvertOnDemand>*indexPics;//
@property (strong, nonatomic) NSArray<YYBuyerContactInfoModel,Optional, ConvertOnDemand>* userContactInfos;
@property (strong, nonatomic) NSArray <Optional, ConvertOnDemand> *retailerName;//
@property (strong, nonatomic) NSArray<YYBuyerSocialInfoModel,Optional, ConvertOnDemand>* userSocialInfos;
@property (strong, nonatomic) NSString <Optional>*brandIntroduction;//
@property (strong, nonatomic) NSString <Optional>*logoPath;

@property (strong, nonatomic) NSString <Optional>*legalPersonFiles;
@property (strong, nonatomic) NSString <Optional>*licenceFile;


+(YYBrandHomeUpdateModel *)createUploadCertModel:(NSArray *)paramsArr;

@end
