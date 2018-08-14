//
//  YYUserHomePageModel.h
//  Yunejian
//
//  Created by yyj on 2016/12/16.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YYUserHomePageModel : JSONModel

typedef NS_ENUM(NSInteger, UserContactInfoType) {
    UserContactInfoEmail = 1,
    UserContactInfoPhone = 2,
    UserContactInfoQQ = 3,
    UserContactInfoWechat = 4,
};
/** 品牌ID*/
@property (strong, nonatomic) NSNumber <Optional>*brandId;
/** 品牌介绍*/
@property (strong, nonatomic) NSString <Optional>*brandIntroduction;
/** 品牌名*/
@property (strong, nonatomic) NSString <Optional>*brandName;
/** 作品图片*/
@property (strong, nonatomic) NSArray <Optional>*indexPics;
/** logo 路径*/
@property (strong, nonatomic) NSString <Optional>*logoPath;
/** 合作买手店名称*/
@property (strong, nonatomic) NSArray <Optional>*retailerName;
/** 用户联系工具信息*/
@property (strong, nonatomic) NSArray <Optional>*userContactInfos;
/** 用户社会化工具信息*/
@property (strong, nonatomic) NSArray <Optional>*userSocialInfos;
/** 品牌官网*/
@property (strong, nonatomic) NSString <Optional>*webUrl;

/** 计算 填写比例*/
@property (strong, nonatomic) NSNumber <Optional>*percent;

/**
 * 获取对应类型的contactValue
 */
-(NSString *)getuserContactInfosWithType:(UserContactInfoType )type;

@end
