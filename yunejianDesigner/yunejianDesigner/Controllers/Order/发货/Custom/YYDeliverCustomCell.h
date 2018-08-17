//
//  YYDeliverCustomCell.h
//  yunejianDesigner
//
//  Created by yyj on 2018/6/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYDeliverModel;

/**
 cell状态
 */
typedef NS_ENUM(NSInteger, YYDeliverCellType) {
    YYDeliverCellTypeReceiverAddress,//收件地址
    YYDeliverCellTypeLogisticsName,  //物流公司
    YYDeliverCellTypeLogisticsCode   //物流单号
};

@interface YYDeliverCustomCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type, NSString *value))block;

-(void)updateUI;

@property (nonatomic, assign) YYDeliverCellType deliverCellType;//cell类型

@property (nonatomic, strong) NSNumber *buyerStockEnabled;//此单的买手店库存是否已经开通 bool

@property (nonatomic ,strong) YYDeliverModel *deliverModel;

@end
