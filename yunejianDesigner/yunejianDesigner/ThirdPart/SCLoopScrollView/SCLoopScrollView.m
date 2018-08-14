//
//  SCLoopScrollView.m
//  ShiCang
//
//  Created by ShiCang on 15/3/18.
//  Copyright (c) 2015年 ShiCang. All rights reserved.
//

#define ZERO_POINT          0.0f

#define SELF_WIDTH          self.frame.size.width
#define SELF_HEIGHT         self.frame.size.height

#define MIN_BORDER          ZERO_POINT
#define MAX_BORDER          SELF_WIDTH*2

#import "SCLoopScrollView.h"

#import "SCLoopManager.h"
#import "UIImage+YYImage.h"
#import "SCGIFImageView.h"

typedef void(^BLOCK)(NSInteger index);

@implementation SCLoopScrollView {
    BLOCK          _scrollBlock;
    BLOCK          _tapBlock;
    
    SCLoopManager *_manager;
    UIScrollView  *_scrollView;
    SCGIFImageView   *_firstImageView;
    SCGIFImageView   *_centerImageView;
    SCGIFImageView   *_lastImageView;
}

#pragma mark - Init Methods
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

#pragma mark - Config Methods
- (void)initConfig {
    _manager = [[SCLoopManager alloc] init];
}

- (void)viewConfig {
    [self layoutIfNeeded];
    NSInteger imageCount = _images.count;
    // 初始化并配置ScrollView以及其三个子视图ImageView，刷新三个ImageView并显示Image
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(SELF_WIDTH * 3, ZERO_POINT);
        [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
        [self addSubview:_scrollView];
    }
    
    if (!_firstImageView && (imageCount > 1)) {
        _firstImageView = [[SCGIFImageView alloc] initWithFrame:CGRectMake(ZERO_POINT, ZERO_POINT, SELF_WIDTH, SELF_HEIGHT)];
        //_firstImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_firstImageView];
    } else if (imageCount == 1) {
        [_firstImageView removeFromSuperview];
        _firstImageView = nil;
    }
    
    if (!_centerImageView) {
        _centerImageView = [[SCGIFImageView alloc] init];
        //_centerImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_centerImageView];
    }
    if (!_lastImageView && (imageCount > 1)) {
        _lastImageView = [[SCGIFImageView alloc] initWithFrame:CGRectMake(SELF_WIDTH*2, ZERO_POINT, SELF_WIDTH, SELF_HEIGHT)];
        //_lastImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_lastImageView];
    } else if (imageCount == 1) {
        [_lastImageView removeFromSuperview];
        _lastImageView = nil;
    }
    
    _scrollView.frame = CGRectMake(ZERO_POINT, ZERO_POINT, SELF_WIDTH, SELF_HEIGHT);
    _centerImageView.frame = CGRectMake(((imageCount > 1) ? SELF_WIDTH : ZERO_POINT), ZERO_POINT, SELF_WIDTH, SELF_HEIGHT);
    _scrollView.scrollEnabled = imageCount >> 1;
    [self display];
}

#pragma mark - Setter And Getter Methods
- (NSInteger)index {
    return _manager.currentItem.index;
}

- (void)setImages:(NSArray *)images {
    if (images.count) {
        _images = images;
        _manager.images = images;
    }
    [self viewConfig];
}

#pragma mark - Public Methods
- (void)show:(void(^)(NSInteger index))tap
    finished:(void(^)(NSInteger index))finished {
    [self showWithAutoScroll:NO tap:tap finished:finished];
}

- (void)showWithAutoScroll:(BOOL)autoScroll
                       tap:(void(^)(NSInteger index))tap
                  finished:(void(^)(NSInteger index))finished {
    _autoScroll  = autoScroll;
    _tapBlock    = tap;
    _scrollBlock = finished;
}

#pragma mark - Private Methods
- (void)display {
    [self handelInitConfigImageView:_firstImageView];
    [self handelInitConfigImageView:_centerImageView];
    [self handelInitConfigImageView:_lastImageView];
    [self refreshImage];
}

- (void)handelInitConfigImageView:(SCGIFImageView *)imageView {
    if (imageView) {
        imageView.backgroundColor = [UIColor clearColor];
        //imageView.image = _defaultImage;
        imageView.contentMode = UIViewContentModeCenter;
        [imageView setData:_defaultImage];
    }
}

/**
 *  单击事件
 */
- (void)tapGestureRecognizer {
    if (_tapBlock) {
        _tapBlock(_manager.currentItem.index);
    }
}

/**
 *  左滑事件
 */
- (void)swipeLeft {
    [_manager moveRight];
    [self refreshImage];
    if (_scrollBlock) {
        _scrollBlock(_manager.currentItem.index);
    }
}

/**
 *  右滑事件
 */
- (void)swipeRight {
    [_manager moveLeft];
    [self refreshImage];
    if (_scrollBlock) {
        _scrollBlock(_manager.currentItem.index);
    }
}

/**
 *  刷新三个子视图所显示的Image
 */
- (void)refreshImage {
    
    if(_defaultImage == nil){
        NSString *gifName=@"loading.gif";
        NSString* filePath = [[NSBundle mainBundle] pathForResource:gifName ofType:nil];
        _defaultImage = [NSData dataWithContentsOfFile:filePath];
    }
    //_firstImageView.image = nil;
    //_centerImageView.image = _defaultImage;
    _centerImageView.contentMode = UIViewContentModeCenter;
    [_centerImageView setData:_defaultImage];
    //_lastImageView.image = nil;
    WeakSelf(ws);
    __block SCGIFImageView   *_blockfirstImageView = _firstImageView;
    __block SCGIFImageView   *_blockcenterImageView = _centerImageView;
    __block SCGIFImageView   *_blocklastImageView = _lastImageView;

    [_manager.currentItem request:^(SCLoopItem *item) {
        __strong __typeof(ws)strongSelf = ws;

        //_centerImageView.image = [UIImage imageWithData:item.data];
        _blockcenterImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_blockcenterImageView setData:item.data];
        
        if (strongSelf.images.count > 1) {
            //_firstImageView.image = _defaultImage;
            [_blockfirstImageView setData:strongSelf.defaultImage];
            _blockfirstImageView.contentMode = UIViewContentModeCenter;
            if (item.preItem) {
                [item.preItem request:^(SCLoopItem *item) {
                    //_firstImageView.image = [UIImage imageWithData:item.data];
                    _blockfirstImageView.contentMode = UIViewContentModeScaleAspectFit;
                    [_blockfirstImageView setData:item.data];
                }];
            } else {
                _blockfirstImageView.image = nil;
            }
            [_blocklastImageView setData:strongSelf.defaultImage];
            _blocklastImageView.contentMode = UIViewContentModeCenter;
            
            if (item.nextItem) {
                [item.nextItem request:^(SCLoopItem *item) {
                    //_lastImageView.image = [UIImage imageWithData:item.data];
                    _blocklastImageView.contentMode = UIViewContentModeScaleAspectFit;
                    [_blocklastImageView setData:item.data];
                }];
            } else {
                _blocklastImageView.image = nil;
            }
        }
    }];
    [self resetOffset];
}

/**
 *  重设ScrollView偏移位置
 */
- (void)resetOffset {
    _scrollView.contentOffset = CGPointMake(((_images.count > 1) ? SELF_WIDTH : ZERO_POINT), ZERO_POINT);
}

#pragma mark - UISrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX <= MIN_BORDER) {
        [self swipeRight];
    } else if (offsetX >= MAX_BORDER) {
        [self swipeLeft];
    }else{
        [_scrollView setContentOffset: CGPointMake(_scrollView.contentOffset.x, ZERO_POINT)];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 防止滚动结束后的卡顿处理
    if (scrollView.contentOffset.x/SELF_WIDTH) {
        [self resetOffset];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 防止滚动结束后的卡顿处理
    if (scrollView.contentOffset.x/SELF_WIDTH) {
        [self resetOffset];
    }
}

@end
