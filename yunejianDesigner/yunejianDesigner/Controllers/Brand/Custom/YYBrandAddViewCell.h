//
//  YYBrandAddViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/2/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYBrandAddViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;

@property (weak,nonatomic) id<YYTableCellDelegate>  delegate;
-(void)updateUI;
@end
