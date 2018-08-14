//
//  YYSkuMessageModel.h
//  yunejianDesigner
//
//  Created by Victor on 2018/3/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol YYSkuMessageModel
@end

@interface YYSkuMessageModel : JSONModel

@property (nonatomic, strong) NSNumber <Optional>*sizeId;
@property (nonatomic, strong) NSNumber <Optional>*styleId;
@property (nonatomic, strong) NSNumber <Optional>*id;
@property (nonatomic, strong) NSString <Optional>*styleCode;
@property (nonatomic, strong) NSNumber <Optional>*hasRead;
@property (nonatomic, strong) NSNumber <Optional>*created;
@property (nonatomic, strong) NSString <Optional>*styleName;
@property (nonatomic, strong) NSString <Optional>*styleImg;
@property (nonatomic, strong) NSString <Optional>*orderCode;
@property (nonatomic, strong) NSNumber <Optional>*colorId;
@property (nonatomic, strong) NSNumber <Optional>*designerId;

@end
