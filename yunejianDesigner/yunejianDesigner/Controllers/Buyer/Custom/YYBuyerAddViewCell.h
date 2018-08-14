//
//  YYBuyerAddViewCell.h
//  yunejianDesigner
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYBuyerAddViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
-(void)updateUI;
@end
