//
//  YYShoppingStyleSizeInputView.h
//  YunejianBuyer
//
//  Created by Apple on 16/2/29.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YYShoppingStyleSizeInputView : UIView<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *sizeNameLabel;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,weak) id<YYTableCellDelegate> delegate;
@property (nonatomic, copy) void(^textFieldDidEndEditingBlock)(YYShoppingStyleSizeInputView *inputView) ;

@property (nonatomic, assign) NSInteger minCount;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger value;

-(void)updateUI;
@end
