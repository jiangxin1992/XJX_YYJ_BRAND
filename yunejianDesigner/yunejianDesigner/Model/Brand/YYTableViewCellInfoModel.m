//
//  YYTableViewCellInfoModel.m
//  Yunejian
//
//  Created by Apple on 15/9/24.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "YYTableViewCellInfoModel.h"
#import "RegexKitLite.h"
#import "YYVerifyTool.h"
@implementation YYTableViewCellInfoModel

-(BOOL)checkPhoneWarnWithPhoneCode:(NSInteger )phoneCode{
    if([self.propertyKey isEqualToString:@"phone"] ){
        if([NSString isNilOrEmpty:self.value]){
            //没有的时候不显示警告
            return YES;
        }else{
            if([YYVerifyTool numberVerift:self.value]){
                //通过数字验证
                if(phoneCode == 86){
                    //            中国
                    if(self.value.length == 11){
                        return YES;
                    }
                }else{
                    //            国外
                    if(self.value.length <= 20 && self.value.length >= 6){
                        return YES;
                    }
                    
                }
            }
        }
    }
    return NO;
}

-(BOOL)checkWarn{
    if (![self.warnStr isEqualToString:@""] && (self.value != nil && ![self.value isEqualToString:@""])) {
        if([self.propertyKey isEqualToString:@"password"]){
            if(self.passwordvalue != nil && ![self.passwordvalue isEqualToString:@""]){
                if(![self.passwordvalue isEqualToString:self.value]){
                    return NO;
                }
            }
        }else if([self.propertyKey isEqualToString:@"webUrl"]){
            return [self.value isMatchedByRegex: @"[a-zA-z]+://[^\s]*"];
        }else if([self.propertyKey isEqualToString:@"phone"]){
            return self.validated;
        }else if([self.propertyKey isEqualToString:@"email"] || [self.propertyKey isEqualToString:@"contactEmail"]){
            return [self.value  isMatchedByRegex:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"];

        }else if([self.propertyKey isEqualToString:@"brandFiles"] ){
            NSArray *valueArr = [self.value componentsSeparatedByString:@","];
            if([valueArr count] >=2 && ![[valueArr objectAtIndex:0] isEqualToString:@""] && ![[valueArr objectAtIndex:1] isEqualToString:@""]){
                return YES;
            }else{
                return NO;
            }
        }else if([self.propertyKey isEqualToString:@"storeImgs"] ){
            NSArray *valueArr = [self.value componentsSeparatedByString:@","];
            if([valueArr count] >=1 && ![[valueArr objectAtIndex:0] isEqualToString:@""] && ![[valueArr objectAtIndex:1] isEqualToString:@""]&& ![[valueArr objectAtIndex:2] isEqualToString:@""]){
                return YES;
            }else{
                return NO;
            }
        }else if([self.propertyKey isEqualToString:@"copBrands"] ){
            NSArray *valueArr = [self.value componentsSeparatedByString:@","];
            if([valueArr count] >=2 && ![[valueArr objectAtIndex:0] isEqualToString:@""] ){
                return YES;
            }else{
                return NO;
            }
        }
        
    }
    return YES;
}

-(NSString *)getParamStr{
    if([self.propertyKey isEqualToString:@"city"]){//province city
//        NSArray *valueArr = [self.value componentsSeparatedByString:@","];
//        return [NSString stringWithFormat:@"province=%@&city=%@",[valueArr objectAtIndex:0],[valueArr objectAtIndex:1]];
        NSString *currentProvinece = @"";
        NSString *currentProvineceID = @"";
        NSString *currentCity = @"";
        NSString *currentCityID = @"";
        NSArray *provinceCityArr = [self.value componentsSeparatedByString:@","];
        if(provinceCityArr.count){
            NSArray * provinceArr = [provinceCityArr[0] componentsSeparatedByString:@"/"];
            if(provinceArr.count > 1){
                currentProvinece = provinceArr[0];
                currentProvineceID = [[NSString alloc] initWithFormat:@"%ld",[provinceArr[1] integerValue]];
                NSInteger tempID = [currentProvineceID integerValue];
                if(tempID < 0){
                    currentProvinece = @"";
                    currentProvineceID = @"";
                }
                NSLog(@"111");
            }
            
            if(provinceCityArr.count > 1){
                
                NSArray * cityArr = [provinceCityArr[1] componentsSeparatedByString:@"/"];
                if(cityArr.count > 1){
                    currentCity = cityArr[0];
                    currentCityID = [[NSString alloc] initWithFormat:@"%ld",[cityArr[1] integerValue]];
                    NSLog(@"111");
                }
            }
        }
        return [NSString stringWithFormat:@"province=%@&provinceId=%@&city=%@&cityId=%@",currentProvinece,currentProvineceID,currentCity,currentCityID];
    }
    if([self.propertyKey isEqualToString:@"brandFiles"]){//province city
        NSArray *valueArr = [self.value componentsSeparatedByString:@","];
        return [NSString stringWithFormat:@"personalBrandCert:%@,personalIdCard:%@",[valueArr objectAtIndex:0],[valueArr objectAtIndex:1]];
    }

    if([self.propertyKey isEqualToString:@"approach"]){
        NSArray *valueArr = [self.value componentsSeparatedByString:@"|"];
        NSMutableArray *tmpParamArr = [[NSMutableArray alloc] initWithCapacity:4];
        for (NSString * infoStr in valueArr) {
            if(![infoStr isEqualToString:@","]){
            NSArray * infoArr = [infoStr componentsSeparatedByString:@","];
            [tmpParamArr addObject:@{@"approach":[infoArr objectAtIndex:0],@"approachDetail":[infoArr objectAtIndex:1]}];
            }
        }
        NSError *error;
        NSData * JSONData = [NSJSONSerialization dataWithJSONObject:tmpParamArr
                                                            options:kNilOptions
                                                              error:&error];
        NSString *jsonStr = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        return [NSString stringWithFormat:@"%@=%@",self.propertyKey,jsonStr];
    }
    
    if([self.propertyKey isEqualToString:@"pics"]){//province city
        NSArray *valueArr = [self.value componentsSeparatedByString:@","];
        NSMutableArray *tmpvalueArr = [[NSMutableArray alloc] init];
        for (NSString *tmpUrl in valueArr) {
            if(![tmpUrl isEqualToString:@""]){
                [tmpvalueArr addObject:tmpUrl];
            }
        }
        
        return [tmpvalueArr componentsJoinedByString:@","];
    }
    if([self.propertyKey isEqualToString:@"copBrands"] ){
        NSString *jsonStr = objArrayToJSON([self.value componentsSeparatedByString:@","]);
        return [NSString stringWithFormat:@"%@=%@",self.propertyKey,jsonStr];
    }
//    retailerName=cccc,ffff,deed

    if(![NSString isNilOrEmpty:self.propertyKey])
    {
        if (![NSString isNilOrEmpty:self.value]) {
            return [NSString stringWithFormat:@"%@=%@",self.propertyKey,self.value];
        }
    }
    return @"";
    
}
@end
