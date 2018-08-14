//
//  YYConnBrandInfoModel.h
//  Yunejian
//
//  Created by Apple on 15/12/2.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"
@protocol YYConnBrandInfoModel @end
@interface YYConnBrandInfoModel : JSONModel
@property (strong, nonatomic) NSString <Optional>*brandName;//":"赞鱼鱼",
@property (strong, nonatomic) NSNumber <Optional>*createTime;//":null,
@property (strong, nonatomic) NSNumber <Optional>*designerId;//":21,
@property (strong, nonatomic) NSString <Optional>*email;//":"4458975741@qq.com",
@property (strong, nonatomic) NSString <Optional>*logoPath;//":"http://source.yunejian.com/ufile/20150908/e05af2877ad44af2889b61279c77f19b",
@property (strong, nonatomic) NSNumber <Optional>*modifyTime;//":null
@property (strong, nonatomic) NSString <Optional>*contactName;
@end
