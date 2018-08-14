//
//  YYOrderAppendStyleInfoCell.h
//  Yunejian
//
//  Created by Apple on 16/8/8.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYOpusStyleModel.h"
#import "SCGIFImageView.h"
@interface YYOrderAppendStyleInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SCGIFImageView *albumImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic,strong) YYOpusStyleModel * styleModel;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
@property (nonatomic,strong) NSArray *selectCellSections;
-(void)updateUI;
@end
