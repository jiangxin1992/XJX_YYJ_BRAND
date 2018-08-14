//
//  YYShowroomOrderingCheckModel.m
//  yunejianDesigner
//
//  Created by yyj on 2018/3/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "YYShowroomOrderingCheckModel.h"

@implementation YYShowroomOrderingCheckModel

- (YYOrderingCheckStatus)getEnumStatus{
    if(self){
        if([self.status isEqualToString:@"TO_BE_VERIFIED"]){
            // 待审核
            return YYOrderingCheckStatus_TO_BE_VERIFIED;
        }else if([self.status isEqualToString:@"VERIFIED"]){
            // 已通过
            return YYOrderingCheckStatus_VERIFIED;
        }else if([self.status isEqualToString:@"REJECTED"]){
            // 已拒绝
            return YYOrderingCheckStatus_REJECTED;
        }else if([self.status isEqualToString:@"CANCELLED"]){
            // 已取消
            return YYOrderingCheckStatus_CANCELLED;
        }else if([self.status isEqualToString:@"INVALIDATED"]){
            // 已失效
            return YYOrderingCheckStatus_INVALIDATED;
        }else if([self.status isEqualToString:@"DELETED"]){
            // 已删除
            return YYOrderingCheckStatus_DELETED;
        }
    }
    // unknow
    return YYOrderingCheckStatus_UNKNOW;
}
- (NSString *)getStrStatus{
    if(self){
        if([self.status isEqualToString:@"TO_BE_VERIFIED"]){
            // 待审核
            return NSLocalizedString(@"待审核", nil);
        }else if([self.status isEqualToString:@"VERIFIED"]){
            // 已通过
            return NSLocalizedString(@"已通过", nil);
        }else if([self.status isEqualToString:@"REJECTED"]){
            // 已拒绝
            return NSLocalizedString(@"已拒绝", nil);
        }else if([self.status isEqualToString:@"CANCELLED"]){
            // 已取消
            return NSLocalizedString(@"已取消", nil);
        }else if([self.status isEqualToString:@"INVALIDATED"]){
            // 已失效
            return NSLocalizedString(@"已失效", nil);
        }else if([self.status isEqualToString:@"DELETED"]){
            // 已删除
            return NSLocalizedString(@"已删除", nil);
        }
    }
    // unknow
    return @"";
}
+ (NSString *)getStatusParameter:(YYOrderingCheckStatus)status{
    switch (status) {
        case YYOrderingCheckStatus_TO_BE_VERIFIED:
            return @"TO_BE_VERIFIED";
            break;
        case YYOrderingCheckStatus_VERIFIED:
            return @"VERIFIED";
            break;
        case YYOrderingCheckStatus_REJECTED:
            return @"REJECTED";
            break;
        case YYOrderingCheckStatus_CANCELLED:
            return @"CANCELLED";
            break;
        case YYOrderingCheckStatus_INVALIDATED:
            return @"INVALIDATED";
            break;
        case YYOrderingCheckStatus_DELETED:
            return @"DELETED";
            break;
        case YYOrderingCheckStatus_UNKNOW:
            return nil;
            break;
    }
    return nil;
}
@end
