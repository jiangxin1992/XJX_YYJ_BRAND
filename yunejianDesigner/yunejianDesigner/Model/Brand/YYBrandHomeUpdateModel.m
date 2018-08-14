//
//  YYBrandHomeUpdateModel.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandHomeUpdateModel.h"
@implementation YYBrandHomeUpdateModel
+(YYBrandHomeUpdateModel *)createUploadCertModel:(NSArray *)paramsArr{
    YYBrandHomeUpdateModel *model = [YYBrandHomeUpdateModel new];
    NSString *key = nil;
    NSString *value = nil;
    NSMutableArray<YYBuyerSocialInfoModel *> *socialInfoArr = [NSMutableArray new];
    NSMutableArray<YYBuyerContactInfoModel *> *contactInfoArr = [NSMutableArray new];
    
    for (NSString *info in paramsArr) {
        NSArray *infoArr = [info componentsSeparatedByString:@"="];
        key = [infoArr objectAtIndex:0];
        
        if([infoArr count] > 1 && ![NSString isNilOrEmpty:key]){
            value = [infoArr objectAtIndex:1];
            if([key containsString:@"Social_"]){
                NSInteger type = [[key substringFromIndex:7] integerValue];
                YYBuyerSocialInfoModel * socialInfoModel = [YYBuyerSocialInfoModel new];
                socialInfoModel.socialName = value;
                socialInfoModel.socialType = [NSNumber numberWithInteger:type];
                [socialInfoArr addObject:socialInfoModel];
            }else if([key containsString:@"Contact_"]){
                NSInteger type = [[key substringFromIndex:8] integerValue];
                YYBuyerContactInfoModel * contactInfoModel = [YYBuyerContactInfoModel new];
                NSArray *valueArr = dictionaryWithJsonString(value);
                if([valueArr count] > 1){
                    contactInfoModel.contactValue = [valueArr objectAtIndex:0];
                    NSInteger authValue = [[valueArr objectAtIndex:1] integerValue];
                    contactInfoModel.auth = [NSNumber numberWithInteger:authValue];
                }
                contactInfoModel.contactType = [NSNumber numberWithInteger:type];
                [contactInfoArr addObject:contactInfoModel];
            }else if([key containsString:@"retailerName"]){
                model.retailerName = dictionaryWithJsonString(value);
            }else if([key containsString:@"indexPics"]){
                model.indexPics = [value componentsSeparatedByString:@","];
                NSLog(@"111");
            }else{
                //[model setValue:value forKey:key];
                [model setValue:value forKeyPath:key];
            }
        }
        
    }
    if([socialInfoArr count] > 0){
        model.userSocialInfos = [socialInfoArr copy];
    }
    if([contactInfoArr count] > 0){
        model.userContactInfos = [contactInfoArr copy];
    }
    return model;
}
@end
