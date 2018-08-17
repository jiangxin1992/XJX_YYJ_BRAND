//
//  YYBuyerInfoCell.h
//  Yunejian
//
//  Created by lixuezhi on 15/8/17.
//  Copyright (c) 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYOrderInfoModel;

typedef void (^OriginalOrderButtonClicked)();
typedef void (^BuyerCardButtonClicked)(UIImage *image);
typedef void (^ReConnStatusButtonClicked)(NSArray *info);


@interface YYBuyerInfoCell1 : UITableViewCell

@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, copy) YYOrderInfoModel *currentYYOrderInfoModel;
@property (nonatomic, strong) id<YYTableCellDelegate>delegate;

@property (nonatomic, strong) OriginalOrderButtonClicked originalOrderButtonClicked;
@property (nonatomic, strong) BuyerCardButtonClicked buyerCardButtonClicked;
@property (nonatomic, strong) ReConnStatusButtonClicked  reConnStatusButtonClicked;
@property(nonatomic,assign) NSInteger currentOrderConnStatus;


- (void)updataUI;

+ (NSInteger) getCellHeight:(NSString *)desc;

@end
