//
//  YYBrandIntroductionViewCell.h
//  YunejianBuyer
//
//  Created by Apple on 16/2/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYBrandIntroductionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandDescLabel;
@property (copy,nonatomic) NSString *descStr;
-(void)updateUI;
+(float)HeightForCell:(NSString *)desc;
@end
