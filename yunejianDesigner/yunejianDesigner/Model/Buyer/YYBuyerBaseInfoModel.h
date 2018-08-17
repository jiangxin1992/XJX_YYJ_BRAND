//
//  YYBuyerBaseInfoModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/7/9.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YYBuyerBaseInfoModel : JSONModel

@property (strong, nonatomic) NSString <Optional>*userName;
@property (strong, nonatomic) NSString <Optional>*userlogo;
@property (strong, nonatomic) NSNumber <Optional>*connected;
@property (strong, nonatomic) NSString <Optional>*userEmail;
@property (strong, nonatomic) NSNumber <Optional>*userId;

@end
