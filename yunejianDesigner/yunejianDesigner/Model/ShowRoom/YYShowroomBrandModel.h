//
//  YYShowroomBrandModel.h
//  yunejianDesigner
//
//  Created by yyj on 2017/3/6.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol YYShowroomBrandModel @end

@interface YYShowroomBrandModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*brandId;
@property (strong, nonatomic) NSString <Optional>*designerName;
@property (strong, nonatomic) NSString <Optional>*email;
@property (strong, nonatomic) NSString <Optional>*brandLogo;
@property (strong, nonatomic) NSString <Optional>*brandName;
@property (strong, nonatomic) NSNumber <Optional>*designerId;

@end
