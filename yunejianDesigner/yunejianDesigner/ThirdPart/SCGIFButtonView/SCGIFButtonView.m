//
//  SCGIFButtonView.m
//  Yunejian
//
//  Created by yyj on 16/7/25.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "SCGIFButtonView.h"
#import <ImageIO/ImageIO.h>
#import "NSTimer+eocBlockSupports.h"

@implementation SCGIFButtonFrame
@synthesize image = _image;
@synthesize duration = _duration;

@end

@interface SCGIFButtonView ()

- (void)resetTimer;

- (void)showNextImage;

@end

@implementation SCGIFButtonView
@synthesize imageFrameArray = _imageFrameArray;
@synthesize timer = _timer;
@synthesize animating = _animating;

- (void)resetTimer {
    if (_timer && _timer.isValid) {
        [_timer invalidate];
    }
    
    self.timer = nil;
}

- (void)setData:(NSData *)imageData {
    if (!imageData) {
        return;
    }
    [self resetTimer];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
    size_t count = CGImageSourceGetCount(source);
    
    NSMutableArray* tmpArray = [NSMutableArray array];
    
    for (size_t i = 0; i < count; i++) {
        SCGIFButtonFrame* gifImage = [[SCGIFButtonFrame alloc] init];
        
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        gifImage.image = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
//        NSDictionary* frameProperties =(NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        NSDictionary* frameProperties =(NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, i, NULL));
        gifImage.duration = [[[frameProperties objectForKey:(NSString*)kCGImagePropertyGIFDictionary] objectForKey:(NSString*)kCGImagePropertyGIFDelayTime] doubleValue];
        gifImage.duration = MAX(gifImage.duration, 0.01);
        
        [tmpArray addObject:gifImage];
        
//        CGImageRelease(image);
    }
//    CFRelease(source);
    
    self.imageFrameArray = nil;
    if (tmpArray.count > 1) {
        self.imageFrameArray = tmpArray;
        _currentImageIndex = -1;
        _animating = YES;
        [self showNextImage];
    } else {
        [self setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
    }
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self resetTimer];
    self.imageFrameArray = nil;
    _animating = NO;
}

- (void)showNextImage {
    if (!_animating) {
        return;
    }
    
    _currentImageIndex = (++_currentImageIndex) % _imageFrameArray.count;
    SCGIFButtonFrame* gifImage = [_imageFrameArray objectAtIndex:_currentImageIndex];
    [super setImage:[gifImage image] forState:UIControlStateNormal ];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:gifImage.duration target:self selector:@selector(showNextImage) userInfo:nil repeats:NO];
    __block typeof(self)weakSelf = self;
    self.timer = [NSTimer eocScheduledTimerWithTimeInterval:gifImage.duration block:^{
        [weakSelf showNextImage];
    } repeats:NO];
}

- (void)setAnimating:(BOOL)animating {
    if (_imageFrameArray.count < 2) {
        _animating = animating;
        return;
    }
    
    if (!_animating && animating) {
        //continue
        _animating = animating;
        if (!_timer) {
            [self showNextImage];
        }
    } else if (_animating && !animating) {
        //stop
        _animating = animating;
        [self resetTimer];
    }
}
@end
