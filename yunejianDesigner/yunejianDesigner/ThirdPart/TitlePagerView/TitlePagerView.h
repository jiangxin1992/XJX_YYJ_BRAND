//
//  TitlePagerView.h
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Additions.h"

@protocol TitlePagerViewDelegate <NSObject>

@optional

- (void)didTouchBWTitle:(NSUInteger)index;

@end

@interface TitlePagerView : UIView

@property (nonatomic, strong) UIFont *font;//字体
@property (nonatomic, assign) CGFloat dynamicTitlePagerViewTitleSpace;//item之间的距离，默认为40
@property (nonatomic, assign) NSInteger pageIndicatorHeight;
@property (nonatomic, weak) id<TitlePagerViewDelegate> delegate;

- (void)addObjects:(NSArray *)images;

- (void)adjustTitleViewByIndex:(CGFloat)index;

- (void)adjustTitleViewByIndexNew:(NSInteger)index;

- (void)updatePageIndicatorPosition:(CGFloat)xPosition;

+ (CGFloat)calculateTitleWidth:(NSArray *)titleArray withFont:(UIFont *)titleFont;

+ (CGFloat)getMaxTitleWidthFromArray:(NSArray *)titleArray withFont:(UIFont *)titleFont;

@end

