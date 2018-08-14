//
//  YYStepViewCell.h
//  yunejianDesigner
//
//  Created by Victor on 2017/12/19.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYStepInfoModel.h"

@interface YYStepViewCell : UITableViewCell

@property (nonatomic, strong) NSString *firtTitle;
@property (nonatomic, strong) NSString *secondTitle;
@property (nonatomic, strong) NSString *thirdTitle;
@property (nonatomic, strong) NSString *fourthTitle;
@property (nonatomic, assign) NSInteger currentStep;

- (instancetype)initWithStepStyle:(StepStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateUI;

@end
