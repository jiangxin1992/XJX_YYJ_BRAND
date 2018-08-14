//
//  YYPickingListStyleCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/17.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPackingListStyleModel;

typedef NS_ENUM(NSInteger, YYPickingListStyleType) {
    YYPickingListStyleTypeNormal,
    YYPickingListStyleTypePackage,
    YYPickingListStyleTypePackageError
};

@interface YYPickingListStyleCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier styleType:(YYPickingListStyleType)styleType;

-(void)updateUI;

@property (nonatomic, strong) YYPackingListStyleModel *packingListStyleModel;

@end
