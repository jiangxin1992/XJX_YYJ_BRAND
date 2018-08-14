//
//  SCGIFButtonView.h
//  Yunejian
//
//  Created by yyj on 16/7/25.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SCGIFButtonFrame : NSObject {
    
}
@property (nonatomic) double duration;
@property (nonatomic, retain) UIImage* image;

@end

@interface SCGIFButtonView : UIButton{
    NSInteger _currentImageIndex;
}
@property (nonatomic, retain) NSArray* imageFrameArray;
@property (nonatomic, retain) NSTimer* timer;
//Setting this value to pause or continue animation;
@property (nonatomic) BOOL animating;
@property (nonatomic,strong) NSString *imageRelativePath;
- (void)setData:(NSData*)imageData;
@end
