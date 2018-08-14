//
//  PopoverBackgroundView.m
//  CustomPopover
//
//  Created by Aaron Crabtree on 3/25/13.
//  Copyright (c) 2013 Tap Dezign. All rights reserved.
//

#import "YYPopoverBackgroundView.h"
#import "UIImage+YYImage.h"
#import <UIKit/UIKit.h>
#define ARROW_BASE 15.0f
#define ARROW_HEIGHT 10.0f
#define kBorderInset 0.0f
#define CAP_INSET 25.0
@interface YYPopoverBackgroundView(){
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIImageView *borderImageView;
- (UIImage *)drawArrowImage:(CGSize)size;
@end


@implementation YYPopoverBackgroundView

@synthesize arrowDirection  = _arrowDirection;
@synthesize arrowOffset     = _arrowOffset;

#pragma mark - Graphics Methods
- (UIImage *)drawArrowImage:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, size.width, size.height));

    CGMutablePathRef arrowPath = CGPathCreateMutable();
    CGPathMoveToPoint(arrowPath, NULL, (size.width/2.0f), 0.0f); //Top Center
    CGPathAddLineToPoint(arrowPath, NULL, size.width, size.height); //Bottom Right
    CGPathAddLineToPoint(arrowPath, NULL, 0.0f, size.height); //Bottom Right
    CGPathCloseSubpath(arrowPath);
    CGContextAddPath(ctx, arrowPath);
    CGPathRelease(arrowPath);

    UIColor *fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;

}


#pragma mark - UIPopoverBackgroundView Overrides
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //TODO: update with border image view
        CGSize areaSize = CGSizeMake(CAP_INSET*2+2, CAP_INSET*2+2);
        _borderImageView = [[UIImageView alloc] initWithImage:[[UIImage imageWithColor:[UIColor blackColor] size:areaSize] resizableImageWithCapInsets:UIEdgeInsetsMake(CAP_INSET,CAP_INSET,CAP_INSET,CAP_INSET)]];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView = arrowImageView;
        
        [self addSubview:_borderImageView];
        [self addSubview:_arrowImageView];
        
    }
    return self;
}

+ (CGFloat)arrowBase
{
    return ARROW_BASE;
}

+ (CGFloat)arrowHeight
{
    return ARROW_HEIGHT;
}

- (CGFloat) arrowOffset {
    return _arrowOffset;
}

- (void) setArrowOffset:(CGFloat)arrowOffset {
    _arrowOffset = arrowOffset;
}

- (UIPopoverArrowDirection)arrowDirection {
    return _arrowDirection;
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection {
    _arrowDirection = arrowDirection;
}


+ (UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsMake(kBorderInset, kBorderInset, kBorderInset, kBorderInset);
}

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}



- (void)layoutSubviews
{
    [super layoutSubviews];


    //TODO: test for arrow UIPopoverArrowDirection
   // if (![[self class] wantsDefaultContentAppearance]) {
        self.layer.shadowOpacity = 0.0f;
        UIView * testView = self.superview;
        while (![testView isKindOfClass:[UIWindow class]]) {
            for (UIView *subview in testView.subviews) {
                if (subview.layer.cornerRadius != 0.0) {
                    subview.layer.cornerRadius = 0.0;
                    
                }//else{
                if (![[self class] wantsDefaultContentAppearance]){
                    for (UIView *subsubview in subview.subviews) {
                        if ( subsubview.class == [UIImageView class]){
                            subsubview.hidden = YES;
                        }
                    }
                }
                //}
                
            }
            testView = testView.superview;
        }
   // }

    
    CGFloat _height = self.frame.size.height;
    CGFloat _width = self.frame.size.width;
    CGFloat _left = 0.0;
    CGFloat _top = 0.0;
    CGFloat _coordinate = 0.0;
    CGAffineTransform _rotation = CGAffineTransformIdentity;
    CGSize arrowSize = CGSizeMake([[self class] arrowBase], [[self class] arrowHeight]);
    self.arrowImageView.image = [self drawArrowImage:arrowSize];
    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp:
            _top += ARROW_HEIGHT;
            _height -= ARROW_HEIGHT;
            _coordinate = ((self.frame.size.width / 2) + self.arrowOffset) - (ARROW_BASE/2);
            _arrowImageView.frame = CGRectMake(_coordinate, 0, ARROW_BASE, ARROW_HEIGHT);
            break;
            
            
        case UIPopoverArrowDirectionDown:
            _height -= ARROW_HEIGHT;
            _coordinate = ((self.frame.size.width / 2) + self.arrowOffset) - (ARROW_BASE/2);
            _arrowImageView.frame = CGRectMake(_coordinate, _height, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( M_PI );
            break;
            
        case UIPopoverArrowDirectionLeft:
            _left += ARROW_BASE;
            _width -= ARROW_BASE;
            _coordinate = ((self.frame.size.height / 2) + self.arrowOffset) - (ARROW_HEIGHT/2);
            _arrowImageView.frame = CGRectMake(0, _coordinate, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( -M_PI_2 );
            break;
            
        case UIPopoverArrowDirectionRight:
            _width -= ARROW_BASE;
            _coordinate = ((self.frame.size.height / 2) + self.arrowOffset)- (ARROW_HEIGHT/2);
            _arrowImageView.frame = CGRectMake(_width, _coordinate, ARROW_BASE, ARROW_HEIGHT);
            _rotation = CGAffineTransformMakeRotation( M_PI_2 );
            
            break;
        
    }
    _borderImageView.frame =  CGRectMake(_left, _top, _width, _height);
    [_arrowImageView setTransform:_rotation];
}

@end
