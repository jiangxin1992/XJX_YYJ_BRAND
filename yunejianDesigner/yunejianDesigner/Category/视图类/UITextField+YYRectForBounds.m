//
//  UITextField+YYRectForBounds.m
//  Yunejian
//
//  Created by yyj on 15/7/22.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import "UITextField+YYRectForBounds.h"

@implementation UITextField (YYRectForBounds)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (CGRect)textRectForBounds:(CGRect)bounds{
    
    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-20, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{

    CGRect inset = CGRectMake(bounds.origin.x+10, bounds.origin.y, bounds.size.width-20, bounds.size.height);
    return inset;
}

#pragma clang diagnostic pop

@end
