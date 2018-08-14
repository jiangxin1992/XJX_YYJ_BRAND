//
//  YYShowroomOrderingModel.h
//  yunejianDesigner
//
//  Created by yyj on 2018/3/8.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol YYShowroomOrderingModel @end

@interface YYShowroomOrderingModel : JSONModel

@property (strong, nonatomic) NSNumber <Optional>*id;
@property (strong, nonatomic) NSString <Optional>*name;
@property (strong, nonatomic) NSNumber <Optional>*year;
@property (strong, nonatomic) NSString <Optional>*season;
@property (strong, nonatomic) NSString <Optional>*status;
@property (strong, nonatomic) NSNumber <Optional>*peopleApplied;
@property (strong, nonatomic) NSNumber <Optional>*peopleToBeVerified;
@property (strong, nonatomic) NSString <Optional>*poster;

@end
