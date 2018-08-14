//
//  YYGuideView.m
//  YunejianBuyer
//
//  Created by Apple on 16/11/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYGuideView.h"
#import "UIView+Layout.h"
#import "UIImage+Mask.h"
@interface YYGuideView ()

@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) UIView *maskBg;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIImageView *btnMaskView;
@property (nonatomic, strong) UIImageView *arrwoView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic,strong)NSString *tipStr;
@property (nonatomic, weak) UIView *maskBtn;
@property (nonatomic, assign) NSInteger direction;
@property (nonatomic, assign) NSInteger gapx;

@property (nonatomic, strong) UIView *topMaskView;
@property (nonatomic, strong) UIView *bottomMaskView;
@property (nonatomic, strong) UIView *leftMaskView;
@property (nonatomic, strong) UIView *rightMaskView;

@end

@implementation YYGuideView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //self.userInteractionEnabled = NO;
        [self addSubview:self.topMaskView];
        [self addSubview:self.bottomMaskView];
        [self addSubview:self.leftMaskView];
        [self addSubview:self.rightMaskView];
        [self addSubview:self.okBtn];
        [self addSubview:self.btnMaskView];
        [self addSubview:self.arrwoView];
        [self addSubview:self.tipsLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = _parentView.bounds;
    _maskBg.frame = self.bounds;
//    _btnMaskView.center = [_parentView convertPoint:_maskBtn.center toView:_parentView];
//    _btnMaskView.size = CGSizeMake(floor(_maskBtn.size.width), floor(_maskBtn.size.height));
    
    CGRect btnMaskRect = [_maskBtn convertRect:CGRectMake(-_gapx, 0, CGRectGetWidth(_maskBtn.frame)+_gapx*2, CGRectGetHeight(_maskBtn.frame)) toView:_parentView];
//    btnMaskRect.size = CGSizeMake(floor(_maskBtn.size.width), floor(_maskBtn.size.height));
//    btnMaskRect.origin = CGPointMake(floor(_maskBtn.origin.x), floor(_maskBtn.origin.y));
    _btnMaskView.frame = btnMaskRect;
    
    _topMaskView.left = 0;
    _topMaskView.top = 0;
    _topMaskView.height = _btnMaskView.top;
    _topMaskView.width = self.width;
    
    _bottomMaskView.left = 0;
    _bottomMaskView.top = _btnMaskView.bottom;
    _bottomMaskView.width = self.width;
    _bottomMaskView.height = self.height - _bottomMaskView.top;
    
    _leftMaskView.left = 0;
    _leftMaskView.top = _btnMaskView.top;
    _leftMaskView.width = _btnMaskView.left;
    _leftMaskView.height = _btnMaskView.height;
    
    _rightMaskView.left = _btnMaskView.right;
    _rightMaskView.top = _btnMaskView.top;
    _rightMaskView.width = self.width - _rightMaskView.left;
    _rightMaskView.height = _btnMaskView.height;
    
    _tipsLabel.text = _tipStr;
    [_tipsLabel sizeToFit];
    
    CGSize tipStrSize = [_tipStr sizeWithAttributes:@{NSFontAttributeName:_tipsLabel.font}];
    NSInteger contentWidth = CGRectGetWidth(_arrwoView.frame)+tipStrSize.width+26;
    if (_direction == GuideViewDirectionTop) {
        NSInteger arrowRight = CGRectGetMidX(btnMaskRect);
        arrowRight = arrowRight+MAX(0, contentWidth-arrowRight);
        
        _arrwoView.right = arrowRight;
        _arrwoView.bottom = _btnMaskView.top - 8;
        _tipsLabel.right = _arrwoView.left - 6;
        _tipsLabel.bottom = _arrwoView.top + 17;
        _arrwoView.image = [UIImage imageNamed:@"guide_arrow_down"];
        _okBtn.right = _tipsLabel.right;
        _okBtn.top = _tipsLabel.bottom +10;
    }else if (_direction == GuideViewDirectionBottom){
        NSInteger arrowRight = CGRectGetMidX(btnMaskRect) + CGRectGetWidth(_arrwoView.frame);
        arrowRight = arrowRight-MAX(0, contentWidth- (SCREEN_WIDTH- CGRectGetMidX(btnMaskRect)));
        
        _arrwoView.right = arrowRight;
        _arrwoView.top = _btnMaskView.bottom + 8;
        _tipsLabel.left = _arrwoView.right + 6;
        _tipsLabel.top = _arrwoView.bottom - 17;
        _arrwoView.image = [UIImage imageNamed:@"guide_arrow_up"];
        _okBtn.right = _tipsLabel.right;
        _okBtn.top = _tipsLabel.bottom + 10;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}


- (void)showInView:(UIView *)view targetView:(UIView *)targetview tipStr:(NSString *)tipStr direction:(NSInteger)direction gap:(NSInteger)gap{
    self.parentView = view;
    self.maskBtn = targetview;
    self.direction = direction;
    self.tipStr = tipStr;
    self.gapx = gap;
    self.alpha = 0;
    [view addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:nil];
    [self layoutSubviews];
}


- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - getter and setter

- (UIView *)maskBg {
    if (!_maskBg) {
        UIView *view = [[UIView alloc] init];
        _maskBg = view;
    }
    return _maskBg;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"okBtn"] forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _okBtn = btn;
    }
    return _okBtn;
}

- (UIImageView *)btnMaskView {
    if (!_btnMaskView) {
                UIImage *image = [UIImage imageNamed:@"guide_white_mask"];
                image = [[image maskImage:[[UIColor blackColor] colorWithAlphaComponent:0.71]] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.backgroundColor = [UIColor clearColor];
//        imageView.layer.cornerRadius = 2;
//        imageView.layer.masksToBounds =YES;
//        imageView.userInteractionEnabled = NO;
        _btnMaskView = imageView;
    }
    return _btnMaskView;
}

- (UIImageView *)arrwoView {
    if (!_arrwoView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_arrow_down"]];
        _arrwoView = imageView;
    }
    return _arrwoView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = NSLocalizedString(@"点击这里\n打开下一个页面",nil);
        tipsLabel.numberOfLines = 0;
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.font = [UIFont boldSystemFontOfSize:17];
        _tipsLabel = tipsLabel;
    }
    return _tipsLabel;
}

- (UIView *)topMaskView {
    if (!_topMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _topMaskView = view;
    }
    return _topMaskView;
}

- (UIView *)bottomMaskView {
    if (!_bottomMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _bottomMaskView = view;
    }
    return _bottomMaskView;
}

- (UIView *)leftMaskView {
    if (!_leftMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _leftMaskView = view;
    }
    return _leftMaskView;
}

- (UIView *)rightMaskView {
    if (!_rightMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _rightMaskView = view;
    }
    return _rightMaskView;
}
@end
