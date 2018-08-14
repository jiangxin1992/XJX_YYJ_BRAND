//
//  YYSellerInfoCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/6/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYSeller.h"
#import "YYShowRoomSubModel.h"
#import <MGSwipeTableCell.h>
#import <MGSwipeButton.h>

typedef void (^SwitchClicked)(NSNumber *salesmanId,BOOL isOn);

@interface YYSellerInfoCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UISwitch *statusSwitch;
//@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic,assign)NSInteger currentShowType;
@property(nonatomic,strong)YYSeller *seller;
@property(nonatomic,strong)YYShowRoomSubModel *subModel;
@property(nonatomic,strong)SwitchClicked switchClicked;

- (void)updateUIWithShowType:(NSInteger )showType;
- (void)setLabelStatus:(float)alpha;
@end
