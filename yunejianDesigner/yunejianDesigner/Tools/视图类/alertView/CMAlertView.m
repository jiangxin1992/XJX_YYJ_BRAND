//
//  CMAlertView.m
//  CMRead-iPhone
//
//  Created by Yrl on 14-10-24.
//  Copyright (c) 2014年 CMRead. All rights reserved.
//

#import "CMAlertView.h"

// c文件 —> 系统文件（c文件在前）

// 控制器

// 自定义视图
#import "FXBlurView.h"

// 接口

// 分类
#import "UIImage+YYImage.h"
#import "UIImage+Tint.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）
#import "MLInputDodger.h"

#define MY_MAX 100
#define kAnimationDuration 0.2
#define kLineBorder 10

@interface CMAlertView()<UIGestureRecognizerDelegate,UITextViewDelegate,CAAnimationDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cancelBT;
@property (nonatomic, copy) NSArray *otherBts;
@property (nonatomic, assign) BOOL needwarn;
@property (nonatomic, assign) BOOL uncloseBgTap;
@property (nonatomic, weak) id<CMAlertViewDelegate> delegate;

@property (nonatomic, strong) NSString *otherBtnBackColor;

@end

@implementation CMAlertView
{
    UIView *alertView;
    UILabel *resetInputLabel;
    UITextView *reasonTextView;
}

@synthesize specialParentView;

- (id)initWithTitle:(NSString *)title message:(NSString *)message needwarn:(BOOL)needwarn delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelBT otherButtonTitles:(NSArray *)otherButtonTitles otherBtnBackColor:(NSString *)color
{
    self = [self init];
    if (self)
    {
        self.otherBtnBackColor = color;
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.cancelBT = cancelBT;
        self.otherBts = otherButtonTitles;
        self.needwarn = needwarn;
        [self setupAlertView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message needwarn:(BOOL)needwarn delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelBT otherButtonTitles:(NSArray *)otherButtonTitles
{
    self = [self init];
    if (self)
    {
        self.title = title;
        self.message = message;
        self.delegate = delegate;
        self.cancelBT = cancelBT;
        self.otherBts = otherButtonTitles;
        self.needwarn = needwarn;
        [self setupAlertView];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message needwarn:(BOOL)needwarn delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelBT otherButtonTitles:(NSArray *)otherButtonTitles bgClose:(BOOL)isClose{
    self.uncloseBgTap = isClose;
    return [self initWithTitle:title message:message needwarn:needwarn delegate:delegate cancelButtonTitle:cancelBT otherButtonTitles:otherButtonTitles];
}

- (id)initWithImage:(UIImage *)image imageFrame:(CGRect)frame cancelButtonTitle:(NSString *)cancelBT bgClose:(BOOL)isClose{
    self.uncloseBgTap = isClose;
    self = [self init];
    if (self)
    {
        self.cancelBT = cancelBT;
        [self setupAlertViewBgImage:image imageFrame:frame];
    }
    return self;
}

- (id)initWithViews:(NSArray *)uis imageFrame:(CGRect)frame  bgClose:(BOOL)isClose{
    self.uncloseBgTap = isClose;
    self = [self init];
    if (self)
    {
        [self setupAlertViewUI:uis imageFrame:frame];
    }
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        if(!self.uncloseBgTap){
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBg:)];
            tap.delegate = self;
            [self addGestureRecognizer:tap];
        }
    }
    
    return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}

- (void)dealloc
{
    self.specialParentView = nil;
}

- (UIImage *)blur:(UIImage *)theImage
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:inputImage forKey:kCIInputImageKey];
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform
     objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    CIImage *extendedImage = [affineClampFilter valueForKey:kCIOutputImageKey];
    
    //setting up Gaussian Blur (could use one of many filters offered by Core Image)
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setValue:extendedImage forKey:kCIInputImageKey];
    [blurFilter setValue:@(1.0f) forKey:@"inputRadius"];
    CIImage *result = [blurFilter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    //create a UIImage for this function to "return" so that ARC can manage the memory of the blur...
    //ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
}

- (void)show
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(self.noLongerRemindKey!=nil &&[userDefaults objectForKey:self.noLongerRemindKey] != nil){
        return;
    }

    [self addToParentViewController];
}

- (void)show:(UIView *)parentView
{
    self.specialParentView = parentView;
    [self show];
}


/*
 This method adds the menu view to the top view controller
 */
- (void)addToParentViewController
{
    UIViewController *parent = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if([[parent childViewControllers] count] > 0)
    {
        //parent = [[parent childViewControllers] lastObject];
    }
    
    CGRect rc = CGRectZero;
  
    //开始   开始至结束部份，朱国军修改 2015.01.11
    UIView *parentView = nil;
    if (self.specialParentView)
    {
        parentView = self.specialParentView;
        rc = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height);
    }
    else
    {
       parentView = parent.view;
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")){
            rc = CGRectMake(0, 0, parentView.frame.size.height, parentView.frame.size.width);
        }else{
            rc = CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height);
        }
    }

    self.frame = rc;
    
    [parentView addSubview:self];

    //结束
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];

    [self popupAnimation:alertView];
}

-(void)OnTapBg:(UITapGestureRecognizer *)sender{
    if(self.needwarn){
        return;
    }

    [self hideAnimation:alertView];
}

/** 弹出视图的动画 */
- (void)popupAnimation:(UIView *)outView
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [outView.layer addAnimation:popAnimation forKey:nil];
}

- (void)hideAnimation:(UIView *)outView
{
    CABasicAnimation *hideAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.1f;
    hideAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    hideAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.75, 0.75, 1.0)];
    hideAnimation.fillMode = kCAFillModeForwards;
    hideAnimation.removedOnCompletion = NO;
    hideAnimation.delegate = self;
    [outView.layer addAnimation:hideAnimation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    for (UIView * ui in alertView.subviews) {
        [ui removeFromSuperview];
    }
    [alertView.layer removeAllAnimations];
    [self removeFromSuperview];
}
- (id)initRefuseOrderReasonWithTitle:(NSString *)title message:(NSString *)message otherButtonTitles:(NSArray *)otherButtonTitles{
    self = [self init];
    if (self)
    {
        self.title = title;
        self.message = message;
        self.otherBts = otherButtonTitles;
        [self setupRefuseOrderAlertView];
    }
    return self;
}
-(void)setupRefuseOrderAlertView{

    self.shiftHeightAsDodgeViewForMLInputDodger = 30;
    [self registerAsDodgeViewForMLInputDodger];

    alertView = [[UIView alloc]initWithFrame:CGRectMake(25, (SCREEN_HEIGHT-280)/2, SCREEN_WIDTH - 50, 280)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.borderColor = [UIColor blackColor].CGColor;
    alertView.layer.borderWidth = 4;
    [self addSubview:alertView];

    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 280)];

    //圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:infoView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = infoView.bounds;
    maskLayer.path = maskPath.CGPath;
    infoView.layer.mask = maskLayer;

    [alertView addSubview:infoView];

    UILabel *alertTitle;
    //题目
    if (self.title)
    {
        alertTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, CGRectGetWidth(infoView.frame), 18)];
        alertTitle.textAlignment = NSTextAlignmentCenter;
        alertTitle.font = [UIFont systemFontOfSize:15];//[UIFont fontWithName:@"Heiti SC" size:14.5];
        alertTitle.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        [alertTitle setText:self.title];
        [infoView addSubview:alertTitle];
    }

    reasonTextView = [[UITextView alloc] initWithFrame:CGRectMake(27, alertTitle?CGRectGetMaxY(alertTitle.frame)+15:23, CGRectGetWidth(infoView.frame)-27*2, 120)];
    [infoView addSubview:reasonTextView];
    reasonTextView.textColor = _define_black_color;
    reasonTextView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    reasonTextView.font = [UIFont systemFontOfSize:13.0f];
    reasonTextView.delegate = self;
    reasonTextView.layer.borderWidth = 1.0f;
    reasonTextView.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;

    resetInputLabel = [UILabel getLabelWithAlignment:0 WithTitle:[NSString stringWithFormat:NSLocalizedString(@"还可输入 %@ 字",nil),@"100"] WithFont:12.0f WithTextColor:[UIColor colorWithHex:@"919191"] WithSpacing:0];
    [infoView addSubview:resetInputLabel];
    resetInputLabel.frame = CGRectMake(27, CGRectGetMaxY(reasonTextView.frame), CGRectGetWidth(infoView.frame)-27*2, 32);

    [infoView setFrame:CGRectMake(CGRectGetMinX(infoView.frame), CGRectGetMinY(infoView.frame), CGRectGetWidth(infoView.frame),CGRectGetMaxY(resetInputLabel.frame))];


    UIButton *button = [UIButton getCustomTitleBtnWithAlignment:0 WithFont:14.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:_define_white_color WithSelectedTitle:nil WithSelectedColor:nil];
    [alertView addSubview:button];
    if(![NSArray isNilOrEmpty:_otherBts]){
        [button setTitle:_otherBts[0] forState:UIControlStateNormal];
    }
    button.backgroundColor = _define_black_color;
    [button addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-28);
        make.left.mas_equalTo(27);
        make.right.mas_equalTo(-27);
        make.height.mas_equalTo(38);
    }];
}

-(void)submitClick:(UIButton *)sender{
    if(_alertViewSubmitBlock && reasonTextView){
        if(![NSString isNilOrEmpty:reasonTextView.text]){
            _alertViewSubmitBlock(reasonTextView.text);
            [self hideAnimation:alertView];
        }else{
            [YYToast showToastWithTitle:NSLocalizedString(@"拒绝原因不能为空", nil) andDuration:kAlertToastDuration];
        }
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if(resetInputLabel){
        NSInteger number = MY_MAX - (textView.text.length - range.length + text.length);
        resetInputLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"还可输入 %@ 字",nil), [NSNumber numberWithInteger:number]];

        if ((textView.text.length - range.length + text.length) > MY_MAX){
            resetInputLabel.text = [[NSString alloc] initWithFormat:NSLocalizedString(@"还可输入 %@ 字",nil), [NSNumber numberWithInteger:0]];
            return NO;

        }else{
            return YES;
        }
    }

    return YES;
}

- (void)setupAlertView
{
    float width = MIN(325,SCREEN_WIDTH-15);
    float height = 260;
    float contentTop = 43;
    
    alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-width)/2,(SCREEN_HEIGHT-height)/2, width, height)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.borderColor = [UIColor blackColor].CGColor;
    alertView.layer.borderWidth = 4;
    [self addSubview:alertView];
    
    UIView *infoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];

    //圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:infoView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = infoView.bounds;
    maskLayer.path = maskPath.CGPath;
    infoView.layer.mask = maskLayer;

    [alertView addSubview:infoView];
    
    UILabel *alertTitle;
    //题目
    if (self.title)
    {
        alertTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, contentTop, width,18)];
        alertTitle.textAlignment = NSTextAlignmentCenter;
        alertTitle.font = [UIFont systemFontOfSize:15];//[UIFont fontWithName:@"Heiti SC" size:14.5];
        alertTitle.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
        [alertTitle setText:self.title];
        [infoView addSubview:alertTitle];
    }
    UILabel *alertMessage;
    if (self.message) {
        //message
        alertMessage = [[UILabel alloc]initWithFrame:CGRectMake(20,alertTitle?alertTitle.frame.origin.y+alertTitle.frame.size.height+10:contentTop,  width-40,20)];
        UIFont *font = [alertMessage.font fontWithSize:13];
        alertMessage.textColor = [UIColor colorWithHex:@"919191"];//[UIColor colorWithRed:132/255.0f green:132/255.0f blue:131/255.0f alpha:1.0f];
        [alertMessage setFont:font];
        [alertMessage setNumberOfLines:0];

        CGFloat messageH = getTxtHeight(CGRectGetWidth(alertMessage.frame), self.message, @{NSFontAttributeName:font});

        
        CGRect dateFrame = CGRectMake(20,alertTitle?alertTitle.frame.origin.y+alertTitle.frame.size.height+10:contentTop,width-40,messageH);
        alertMessage.textAlignment = NSTextAlignmentCenter;
        alertMessage.frame = dateFrame;
        [alertMessage setText:self.message];
        [infoView addSubview:alertMessage];
    }
    
    
    self.select = NO;
    //警告选项
    UIButton *selectBox;
    if (self.needwarn)
    {
        selectBox = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBox.frame = CGRectMake(90, alertMessage.frame.origin.y + alertMessage.frame.size.height+12, 80, 16);
        [selectBox setImage:[UIImage imageNamed:@"checkSquare"] forState: UIControlStateNormal];
        [selectBox setImage:[UIImage imageNamed:@"checkedSquare"] forState: UIControlStateSelected];
        [selectBox setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [selectBox.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [selectBox setTitle:NSLocalizedString(@"不再提醒",nil) forState:UIControlStateNormal];
        [selectBox setTitle:NSLocalizedString(@"不再提醒",nil) forState:UIControlStateSelected];
        [selectBox setTitleColor:[UIColor colorWithRed:113/255.0f green:113/255.0f blue:113/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [selectBox setTitleColor:[UIColor colorWithRed:113/255.0f green:113/255.0f blue:113/255.0f alpha:1.0f] forState:UIControlStateSelected];
        [selectBox addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        [infoView addSubview:selectBox];
    }
    
    [infoView setFrame:CGRectMake(infoView.frame.origin.x, infoView.frame.origin.y,infoView.frame.size.width,contentTop+alertTitle.frame.size.height+((alertTitle && alertMessage)?10:0)+alertMessage.frame.size.height+(selectBox?10:0)+selectBox.frame.size.height+23)];
    float leftRightspace = 40;
    float bottomSpace = 20;
    float btnHeight = 38;
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:0];
    //取消按钮
    if (self.cancelBT)
    {
        float btnwidth =(float)(width-leftRightspace*2);
        for (int i =0 ;i<self.otherBts.count+1;i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(infoView.frame.origin.x+leftRightspace,infoView.frame.origin.y+infoView.frame.size.height+i*btnHeight+i*kLineBorder,btnwidth,btnHeight);

            button.titleLabel.font = [UIFont systemFontOfSize:14];//[UIFont fontWithName:@"Heiti SC" size:14.5];

            button.tag = i;
            [button setBackgroundColor:[UIColor whiteColor]];
            if (self.otherBts.count>0)
            {
                //圆角
                if (i==self.otherBts.count){
                    button.tag=0;
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] size:button.frame.size] forState:UIControlStateNormal];
                    button.layer.borderWidth = 1;
                    button.layer.borderColor = [UIColor blackColor].CGColor;
                    button.layer.masksToBounds = YES;
                    [button setTitle:self.cancelBT forState:UIControlStateNormal];

                }else if (i>=0)
                {
                    button.tag = i+1;
                    NSArray *btnInfo = [self.otherBts[i] componentsSeparatedByString:@"|"];
                    NSString *colorStr = (([btnInfo count] ==2)?[btnInfo objectAtIndex:1]:(_otherBtnBackColor?_otherBtnBackColor:@"ef4e31"));
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:colorStr] size:button.frame.size] forState:UIControlStateNormal];
                    [button setTitle:[btnInfo objectAtIndex:0] forState:UIControlStateNormal];
                    
                }
            }else{
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1] size:button.frame.size] forState:UIControlStateNormal];
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor blackColor].CGColor;
                button.layer.masksToBounds = YES;
                [button setTitle:self.cancelBT forState:UIControlStateNormal];
            }

            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [list addObject:button];
            [alertView addSubview:button];
        }
    }
    float alertViewHeight = infoView.frame.origin.y+infoView.frame.size.height+(btnHeight+kLineBorder)*(self.otherBts.count+1)-kLineBorder+bottomSpace;
    self.buttonList = [NSArray arrayWithArray:list];
    //重新调整
    [alertView setFrame:CGRectMake((SCREEN_WIDTH-width)/2,(SCREEN_HEIGHT-alertViewHeight)/2, width,alertViewHeight)];
}

- (void)setupAlertViewBgImage:(UIImage*)img imageFrame:(CGRect)frame
{
    float width = CGRectGetWidth(frame);
    float height = CGRectGetHeight(frame);
    
    alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-width)/2,(SCREEN_HEIGHT-height)/2, width, height)];
    alertView.backgroundColor = [UIColor whiteColor];
    [self addSubview:alertView];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    bgView.layer.contents =  (__bridge id _Nullable)(img.CGImage);
    [alertView addSubview:bgView];
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:0];
    //取消按钮
    if (self.cancelBT)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,height-40,width,40);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        button.tag = 0;
        [button setBackgroundColor:[UIColor whiteColor]];
        button.alpha = 0.9f;
        [button setTitle:self.cancelBT forState:UIControlStateNormal];
        [button setTintColor:[UIColor whiteColor]];
        [button setImage:[[UIImage imageNamed:@"right"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        CGSize btnTextSize =[self.cancelBT sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
        CGSize imageSize = [UIImage imageNamed:@"right"].size;
        float labelWidth = btnTextSize.width+4;
        float imageWith = imageSize.width;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWith, 0, imageWith);

        button.imageView.tintColor = [UIColor blueColor];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1] size:button.frame.size] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [list addObject:button];
        [alertView addSubview:button];
       
    }

    self.buttonList = [NSArray arrayWithArray:list];
}

- (void)setupAlertViewUI:(NSArray*)uis imageFrame:(CGRect)frame{
    float width = CGRectGetWidth(frame);
    float height = CGRectGetHeight(frame);
    
    alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-width)/2,(SCREEN_HEIGHT-height)/2, width, height)];
    alertView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    [self addSubview:alertView];
    for (UIView *ui in uis) {
        [alertView addSubview:ui];

    }
}

- (void)choose:(UIButton *)sender
{
#ifdef SUPPORT_UMENG_ANALYTICS
    NSString *eventID = [CMUMAnalytics getEventID:CM_BookReaderPage_NoLongerRemind checkNetworkType:NO];
    if(eventID)
    {
        [CMUMAnalytics endEvent:eventID];
    }
#endif
    if (self.select)
    {
        self.select = NO;
        sender.selected = NO;
    }else{
        self.select = YES;
        sender.selected = YES;
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if(self.select){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"true" forKey:self.noLongerRemindKey];
        [userDefaults synchronize];
    }
    
    if (self.delegate)
    {
        [self.delegate alertView:self clickedButtonAtIndex:sender.tag];
    }else if(_alertViewBlock){
        _alertViewBlock((NSInteger)sender.tag);
    }
    
    [self hideAnimation:alertView];
}

- (void)buttonAddBBG:(UIButton *)sender
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, sender.frame.size.width, sender.frame.size.height)];
    [view setBackgroundColor:[UIColor blackColor]];
    view.alpha = 0.1f;
    [sender addSubview:view];
}

- (void)buttonRemoveBBG:(UIButton *)sender
{
    UIView *view = sender.subviews.lastObject;
    [view removeFromSuperview];
}

@end
