//
//  YYSalesManModel.h
//  Yunejian
//
//  Created by yyj on 15/7/15.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "JSONModel.h"

@protocol YYSalesManModel @end

@interface YYSalesManModel : JSONModel

//@property (strong, nonatomic) NSNumber <Optional>*salesmanId;
//@property (strong, nonatomic) NSString <Optional>*name;
//@property (strong, nonatomic) NSString <Optional>*email;
//@property (strong, nonatomic) NSNumber <Optional>*status;
@property (strong, nonatomic) NSNumber <Optional>*userId;
@property (strong, nonatomic) NSString <Optional>*username;
@property (strong, nonatomic) NSString <Optional>*email;
@property (strong, nonatomic) NSNumber <Optional>*status;//'0，正常，1， 停用'仅销售代表会返回此字段|
@property (strong, nonatomic) NSNumber <Optional>*userType;
@property (strong, nonatomic) NSString <Optional>*showroomName;

@end
