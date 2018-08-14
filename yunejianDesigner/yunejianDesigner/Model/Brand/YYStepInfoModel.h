//
//  YYStepInfoModel.h
//  yunejianDesigner
//
//  Created by Victor on 2017/12/23.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, StepStyle) {
    StepStyleThreeStep,
    StepStyleFourStep
};

@interface YYStepInfoModel : NSObject

@property (nonatomic, assign) StepStyle stepStyle;
@property (nonatomic, strong) NSString *firtTitle;
@property (nonatomic, strong) NSString *secondTitle;
@property (nonatomic, strong) NSString *thirdTitle;
@property (nonatomic, strong) NSString *fourthTitle;
@property (nonatomic, assign) NSInteger currentStep;

@end
