//
//  YYBuyerHomeModel.h
//  YunejianBuyer
//
//  Created by Apple on 16/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "JSONModel.h"
#import "YYBuyerSocialInfoModel.h"
#import "YYBuyerContactInfoModel.h"

@interface YYBuyerHomeInfoModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*priceMin;//
@property (strong, nonatomic) NSString <Optional>*logoPath;
@property (strong, nonatomic) NSNumber <Optional>*buyerId;//
@property (strong, nonatomic) NSNumber <Optional>*priceMax;//
@property (strong, nonatomic) NSArray<YYBuyerContactInfoModel,Optional, ConvertOnDemand>* userContactInfos;
@property (strong, nonatomic) NSString <Optional>*introduction;//
@property (strong, nonatomic) NSArray<YYBuyerSocialInfoModel,Optional, ConvertOnDemand>* userSocialInfos;
@property (strong, nonatomic) NSString <Optional>*street;//
@property (strong, nonatomic) NSNumber <Optional>*connectStatus;
@property (strong, nonatomic) NSString <Optional>*addressDetail;//
@property (strong, nonatomic) NSString <Optional>*town;//
@property (strong, nonatomic) NSArray <Optional, ConvertOnDemand>*copBrands;//
@property (strong, nonatomic) NSArray <Optional, ConvertOnDemand>*storeImgs;//
@property (strong, nonatomic) NSNumber <Optional>*percent;//
@property (strong, nonatomic) NSString <Optional>*webUrl;//
@property (strong, nonatomic) NSString <Optional>*name;//
@property (strong, nonatomic) NSString <Optional>*email;//

@property (strong, nonatomic) NSString <Optional>*nation;
@property (strong, nonatomic) NSString <Optional>*province;//省
@property (strong, nonatomic) NSString <Optional>*city;//城市

@property (strong, nonatomic) NSString <Optional>*nationEn;
@property (strong, nonatomic) NSString <Optional>*provinceEn;
@property (strong, nonatomic) NSString <Optional>*cityEn;

@property (strong, nonatomic) NSNumber <Optional>*nationId;
@property (strong, nonatomic) NSNumber <Optional>*provinceId;
@property (strong, nonatomic) NSNumber <Optional>*cityId;

@property (strong, nonatomic) NSNumber <Optional>*pickerRow;
@property (strong, nonatomic) NSNumber <Optional>*pickerComponent;

@property (strong, nonatomic) NSString <Optional>*legalPersonFiles;
@property (strong, nonatomic) NSString <Optional>*licenceFile;

//获取对应Component/Row
-(void )SetPickerRowAndComponent;

//storeImgs首张图
-(NSString *)getStoreImgCover;

@end
