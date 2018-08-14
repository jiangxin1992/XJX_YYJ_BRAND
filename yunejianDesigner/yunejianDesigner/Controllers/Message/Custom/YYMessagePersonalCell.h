//
//  YYMessagePersonalCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/10/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYMessageUserChatModel.h"
#import "SCGIFImageView.h"
@interface YYMessagePersonalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SCGIFImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *msgContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsNumLabel;

@property (strong,nonatomic) YYMessageUserChatModel *chatModel;
-(void)updateUI;
@end
