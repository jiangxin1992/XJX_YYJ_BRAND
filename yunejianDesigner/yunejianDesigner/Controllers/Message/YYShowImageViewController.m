//
//  YYShowImageViewController.m
//  parking
//
//  Created by chjsun on 2017/2/8.
//  Copyright © 2017年 chjsun. All rights reserved.
//

#import "YYShowImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface YYShowImageViewController ()<UIScrollViewDelegate>

/** image */
@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation YYShowImageViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubView];

}


#pragma mark - 系统代理
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}


#pragma mark - 自定义代理


#pragma mark - 自定义响应
- (void)touchScrollView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 自定义方法


#pragma mark - UI
- (void)initSubView{
    self.view.clipsToBounds = YES;
    // 创建加载时的文字
    UILabel *placeLabel = [[UILabel alloc] init];
    placeLabel.text = @"图片正在拼命加载中 ·  ·  ·";
    placeLabel.textAlignment = NSTextAlignmentCenter;
    placeLabel.textColor = [UIColor whiteColor];
    placeLabel.numberOfLines = 0;
    [self.view addSubview:placeLabel];

    // 缩放
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    scrollView.contentSize = CGSizeMake(WIDTH, HEIGHT - 64);

    [self.view addSubview:scrollView];

    // 设置背景色
    self.view.backgroundColor = [UIColor blackColor];
    // 要显示的图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    // 自适应图片
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView = imageView;

    if (self.imageUrl) {
        NSURL *imgplaceUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.imageUrl, kSendMessageImage]];
        UIImageView *image = [[UIImageView alloc] init];
        [image sd_setImageWithURL:imgplaceUrl];
        [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY);
            make.width.mas_equalTo(17);
        }];

        NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.imageUrl, kSendMessageBigImage]];

        [imageView sd_setImageWithURL:imgUrl placeholderImage:image.image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [placeLabel removeFromSuperview];
        }];

    }else if (self.imageImage){
        imageView.image = self.imageImage;
        // 移除提示文本
        [placeLabel removeFromSuperview];
    }else{
        NSLog(@"需要传入图片或者图片地址");
    }

    [scrollView addSubview:imageView];

    // 设置缩放内容视图的缩放比例范围
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 2;
    // 当缩放比例超出范围之后，是否有反弹效果（no:不会超出范围，yes:超出范围之后反弹）
    scrollView.bouncesZoom = YES;
    // 打开多点触控
    scrollView.multipleTouchEnabled = YES;
    // 隐藏条
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    scrollView.delegate = self;
    //默认是no，假如是yes并且bounces是yes, 甚至如果内容大小小于bounds的时候，允许垂直/水平拖动
    scrollView.alwaysBounceVertical = YES;
    scrollView.alwaysBounceHorizontal = YES;

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollView)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [scrollView addGestureRecognizer:recognizer];
}


@end
