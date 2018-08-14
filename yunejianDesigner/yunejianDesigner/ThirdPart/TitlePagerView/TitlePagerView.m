//
//  TitlePagerView.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TitlePagerView.h"

static CGFloat TitlePagerViewTitleSpace = 40;

@interface TitlePagerView ()

@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) UIImageView *pageIndicator;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation TitlePagerView
#pragma mark - --------------生命周期--------------
-(instancetype)init{
    self = [super init];
    if (self) {
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{
    if(_pageIndicatorHeight == 0){
        _pageIndicatorHeight = 2;
    }
    _dynamicTitlePagerViewTitleSpace = TitlePagerViewTitleSpace;
    self.views = [NSMutableArray array];
}
- (void)PrepareUI{}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    [self addSubview:self.pageIndicator];
}

#pragma mark - --------------自定义响应----------------------
- (void)didTapTextLabel:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchBWTitle:)]) {
        [self.delegate didTouchBWTitle:gestureRecognizer.view.tag];
    }
}

#pragma mark - --------------自定义方法----------------------
- (void)addObjects:(NSArray *)objects {
    self.titleArray = objects;
    if(self.views == nil){
        [self init];
    }
    [self.views makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.views removeAllObjects];

    __weak typeof(self) weakself = self;

    [objects enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        if ([object isKindOfClass:[NSString class]]) {
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = object;
            textLabel.tag = idx;
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = self.font;
            textLabel.userInteractionEnabled = YES;

            UITapGestureRecognizer *tapTextLabel = [[UITapGestureRecognizer alloc] initWithTarget:weakself action:@selector(didTapTextLabel:)];
            [textLabel addGestureRecognizer:tapTextLabel];

            [weakself addSubview:textLabel];
            [weakself.views addObject:textLabel];

        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.pageIndicator.y = self.height - self.pageIndicatorHeight;
    self.pageIndicator.width = (self.width - _dynamicTitlePagerViewTitleSpace * (self.titleArray.count - 1))/self.titleArray.count;

    [self.views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view sizeToFit];
        CGSize size = view.frame.size;
        size.width = self.width;
        CGFloat viewWidth = (size.width - _dynamicTitlePagerViewTitleSpace * (self.titleArray.count - 1))/self.titleArray.count;
        view.frame = CGRectMake((viewWidth + _dynamicTitlePagerViewTitleSpace) * idx, 0, viewWidth, size.height * 2);
    }];
}


- (UIImageView *)pageIndicator {
    if (!_pageIndicator) {
        _pageIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, self.pageIndicatorHeight)];
        _pageIndicator.contentMode = UIViewContentModeScaleAspectFill;
        _pageIndicator.clipsToBounds = YES;
        _pageIndicator.backgroundColor = [UIColor blackColor];
    }
    return _pageIndicator;
}

- (void)updatePageIndicatorPosition:(CGFloat)xPosition {
    CGFloat pageIndicatorXPosition = (((xPosition - SCREEN_WIDTH)/SCREEN_WIDTH) * (self.width - self.pageIndicator.width))/(self.titleArray.count - 1);
    self.pageIndicator.x = pageIndicatorXPosition;
}
- (void)adjustTitleViewByIndexNew:(NSInteger)index {
    for (UILabel *textLabel in self.subviews) {
        if ([textLabel isKindOfClass:[UILabel class]]) {
            textLabel.textColor = [UIColor colorWithWhite:0.675 alpha:1.000];
            if (textLabel.tag == index) {
                textLabel.textColor = [UIColor blackColor];
            }

            //            textLabel.backgroundColor = [UIColor colorWithRed:(CGFloat)(arc4random() % 255)/255.0f green:(CGFloat)(arc4random() % 255)/255.0f blue:(CGFloat)
        }
    }
    CGFloat item_width = (self.width - _dynamicTitlePagerViewTitleSpace * (self.titleArray.count - 1))/self.titleArray.count;
    //    NSLog(@"self.width = %lf",self.width);
    //    NSLog(@"item_width = %lf",item_width);
    //    NSLog(@"_dynamicTitlePagerViewTitleSpace = %lf",_dynamicTitlePagerViewTitleSpace);
    if (index == 0) {
        self.pageIndicator.x = 0;
    }else{
        self.pageIndicator.x = (item_width + _dynamicTitlePagerViewTitleSpace)*index;
    }
}

- (void)adjustTitleViewByIndex:(CGFloat)index {
    for (UILabel *textLabel in self.subviews) {
        if ([textLabel isKindOfClass:[UILabel class]]) {
            textLabel.textColor = [UIColor colorWithWhite:0.675 alpha:1.000];
            if (textLabel.tag == index) {
                textLabel.textColor = [UIColor blackColor];
            }
        }
    }

    if (index == 0) {
        self.pageIndicator.x = 0;
    } else if (index == self.titleArray.count - 1) {
        self.pageIndicator.x = self.width - self.pageIndicator.width;
    }
}

#pragma mark - --------------other----------------------
//获取了pageview的宽度
+ (CGFloat)calculateTitleWidth:(NSArray *)titleArray withFont:(UIFont *)titleFont {
    return [self getMaxTitleWidthFromArray:titleArray withFont:titleFont] * [titleArray count] + TitlePagerViewTitleSpace * ([titleArray count] -1);
}
//获取了pageview的宽度
+ (CGFloat)getMaxTitleWidthFromArray:(NSArray *)titleArray withFont:(UIFont *)titleFont {
    CGFloat maxWidth = 0;

    for (int i = 0; i < titleArray.count; i++) {
        NSString *titleString = [titleArray objectAtIndex:i];
        CGFloat titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:titleFont}].width;
        if (titleWidth > maxWidth) {
            maxWidth = titleWidth;
        }
    }

    return maxWidth;
}

@end

