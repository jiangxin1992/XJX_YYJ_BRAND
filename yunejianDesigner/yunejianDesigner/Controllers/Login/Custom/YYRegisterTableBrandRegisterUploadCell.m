//
//  YYRegisterTableBrandRegisterUploadCell.m
//  yunejianDesigner
//
//  Created by Victor on 2017/12/22.
//  Copyright © 2017年 Apple. All rights reserved.
//

// c文件 —> 系统文件（c文件在前）

// 控制器
#import "YYRegisterTableBrandRegisterUploadCell.h"

// 自定义视图

// 接口

// 分类
#import "UIImage+YYImage.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

// 自定义类和三方类（ cocoapods类 > model > 工具类 > 其他）

@interface YYRegisterTableBrandRegisterUploadCell()

@property (nonatomic, strong) UILabel *uploadLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *firstItemLabel;
@property (nonatomic, strong) UIButton *firstHelpButton;
@property (nonatomic, strong) UIButton *firstPhotoUploadButton;
@property (nonatomic, strong) UIView *firstPhotoTipView;
@property (nonatomic, strong) UIImageView *firstAddIcon;
@property (nonatomic, strong) UILabel *firstPhotoTipLabel;

@property (nonatomic, strong) UILabel *secondItemLabel;
@property (nonatomic, strong) UIButton *secondHelpButton;
@property (nonatomic, strong) UIButton *secondPhotoUploadButton;
@property (nonatomic, strong) UIView *secondPhotoTipView;
@property (nonatomic, strong) UIImageView *secondAddIcon;
@property (nonatomic, strong) UILabel *secondPhotoTipLabel;
@property (nonatomic, strong) UILabel *thirdPhotoTipLabel;

@property (nonatomic, strong) UIButton *submitButton;

@property(nonatomic,assign) NSInteger registerType;
@property (nonatomic, strong) CMAlertView *alert;

@end

@implementation YYRegisterTableBrandRegisterUploadCell

#pragma mark - --------------生命周期--------------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth([UIScreen mainScreen].bounds), 0, 0);
        __weak typeof (self)weakSelf = self;
        
        self.uploadLabel = [[UILabel alloc] init];
        self.uploadLabel.text = NSLocalizedString(@"Step 2.上传文件", nil);
        self.uploadLabel.textColor = [UIColor lightGrayColor];
        self.uploadLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.uploadLabel];
        [self.uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(32);
            make.right.mas_equalTo(-17);
        }];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.equalTo(weakSelf.uploadLabel.mas_bottom).with.offset(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        self.firstItemLabel = [[UILabel alloc] init];
        self.firstItemLabel.text = NSLocalizedString(@"商标注册证 *", nil);
        self.firstItemLabel.textColor = _define_black_color;
        self.firstItemLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.firstItemLabel];
        [self.firstItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.lineView.mas_bottom).with.offset(12);
            make.left.mas_equalTo(32);
        }];
        
        self.firstHelpButton = [UIButton getCustomImgBtnWithImageStr:@"help_icon" WithSelectedImageStr:nil];
        [self.firstHelpButton addTarget:self action:@selector(firstHelpButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.firstHelpButton];
        [self.firstHelpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
            make.left.equalTo(weakSelf.firstItemLabel.mas_right).with.offset(-10);
            make.centerY.equalTo(weakSelf.firstItemLabel.mas_centerY);
        }];
        
        self.firstPhotoUploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.firstPhotoUploadButton.backgroundColor = [UIColor clearColor];
        [self.firstPhotoUploadButton addTarget:self action:@selector(uploadFirstPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.firstPhotoUploadButton];
        [self.firstPhotoUploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(247);
            make.height.mas_equalTo(185);
            make.top.equalTo(weakSelf.firstItemLabel.mas_bottom).with.offset(9);
            make.left.mas_equalTo(32);
        }];
        
        self.firstPhotoTipView = [[UIView alloc] init];
        self.firstPhotoTipView.userInteractionEnabled = NO;
        self.firstPhotoTipView.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
        self.firstPhotoTipView.layer.borderWidth = 1;
        self.firstPhotoTipView.layer.cornerRadius = 2.5;
        [self.contentView addSubview:self.firstPhotoTipView];
        [self.firstPhotoTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.firstPhotoUploadButton.mas_width);
            make.height.equalTo(weakSelf.firstPhotoUploadButton.mas_height);
            make.top.equalTo(weakSelf.firstItemLabel.mas_bottom).with.offset(9);
            make.left.mas_equalTo(32);
        }];
        
        self.firstAddIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_icon_gray"]];
        [self.firstPhotoTipView addSubview:self.firstAddIcon];
        [self.firstAddIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(22);
            make.height.mas_equalTo(22);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        
        self.firstPhotoTipLabel = [[UILabel alloc] init];
        self.firstPhotoTipLabel.text = NSLocalizedString(@"上传公司商标注册证", nil);
        self.firstPhotoTipLabel.textColor = [UIColor lightGrayColor];
        self.firstPhotoTipLabel.font = [UIFont systemFontOfSize:14];
        self.firstPhotoTipLabel.textAlignment = NSTextAlignmentCenter;
        self.firstPhotoTipLabel.numberOfLines = 2;
        [self.firstPhotoTipView addSubview:self.firstPhotoTipLabel];
        [self.firstPhotoTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.firstAddIcon.mas_bottom).with.offset(5);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
        }];
        
        self.secondItemLabel = [[UILabel alloc] init];
        self.secondItemLabel.text = NSLocalizedString(@"注册人身份证 *", nil);
        self.secondItemLabel.textColor = _define_black_color;
        self.secondItemLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.secondItemLabel];
        [self.secondItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.firstPhotoTipView.mas_bottom).with.offset(30);
            make.left.mas_equalTo(32);
        }];
        
        self.secondHelpButton = [UIButton getCustomImgBtnWithImageStr:@"help_icon" WithSelectedImageStr:nil];
                [self.secondHelpButton addTarget:self action:@selector(secondHelpButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.secondHelpButton];
        [self.secondHelpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
            make.left.equalTo(weakSelf.secondItemLabel.mas_right).with.offset(-10);
            make.centerY.equalTo(weakSelf.secondItemLabel.mas_centerY);
        }];
        
        self.secondPhotoUploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.secondPhotoUploadButton.backgroundColor = [UIColor clearColor];
                [self.secondPhotoUploadButton addTarget:self action:@selector(uploadSecondPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.secondPhotoUploadButton];
        [self.secondPhotoUploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(247);
            make.height.mas_equalTo(185);
            make.top.equalTo(weakSelf.secondItemLabel.mas_bottom).with.offset(9);
            make.left.mas_equalTo(32);
        }];
        
        self.secondPhotoTipView = [[UIView alloc] init];
        self.secondPhotoTipView.userInteractionEnabled = NO;
        self.secondPhotoTipView.layer.borderColor = [UIColor colorWithHex:@"d3d3d3"].CGColor;
        self.secondPhotoTipView.layer.borderWidth = 1;
        self.secondPhotoTipView.layer.cornerRadius = 2.5;
        [self.contentView addSubview:self.secondPhotoTipView];
        [self.secondPhotoTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakSelf.secondPhotoUploadButton.mas_width);
            make.height.equalTo(weakSelf.secondPhotoUploadButton.mas_height);
            make.top.equalTo(weakSelf.secondItemLabel.mas_bottom).with.offset(9);
            make.left.mas_equalTo(32);
        }];
        
        self.secondAddIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_icon_gray"]];
        [self.secondPhotoTipView addSubview:self.secondAddIcon];
        [self.secondAddIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(22);
            make.height.mas_equalTo(22);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        
        self.secondPhotoTipLabel = [[UILabel alloc] init];
        self.secondPhotoTipLabel.text = NSLocalizedString(@"上传注册公司营业执照", nil);
        self.secondPhotoTipLabel.textColor = [UIColor lightGrayColor];
        self.secondPhotoTipLabel.font = [UIFont systemFontOfSize:14];
        self.secondPhotoTipLabel.textAlignment = NSTextAlignmentCenter;
        [self.secondPhotoTipView addSubview:self.secondPhotoTipLabel];
        [self.secondPhotoTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.secondAddIcon.mas_bottom).with.offset(5);
            make.left.mas_equalTo(5);
            make.right.mas_equalTo(-5);
        }];
        
        self.thirdPhotoTipLabel = [[UILabel alloc] init];
        self.thirdPhotoTipLabel.text = NSLocalizedString(@"公司须与商标注册证上的公司保持一致", nil);
        self.thirdPhotoTipLabel.textColor = [UIColor lightGrayColor];
        self.thirdPhotoTipLabel.font = [UIFont systemFontOfSize:12];
        self.thirdPhotoTipLabel.textAlignment = NSTextAlignmentCenter;
        [self.secondPhotoTipView addSubview:self.thirdPhotoTipLabel];
        [self.thirdPhotoTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.secondPhotoTipLabel.mas_bottom).with.offset(3);
            make.left.mas_equalTo(4);
            make.right.mas_equalTo(-4);
        }];
    }
    return self;
}

#pragma mark - --------------SomePrepare--------------

#pragma mark - --------------UIConfig----------------------
-(void)updateCellInfo:(YYTableViewCellInfoModel *)info{
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    YYTableViewCellInfoModel *infoModel = info;
    self.registerType = infoModel.brandRegisterType;
    if(self.registerType == 0){
        self.firstPhotoTipLabel.text = @"";
        self.secondPhotoTipLabel.text = @"";
        self.thirdPhotoTipLabel.text = @"";
    }else if(self.registerType == 1){
        self.firstPhotoTipLabel.text = NSLocalizedString(@"上传个人商标注册证",nil);
        self.secondPhotoTipLabel.text = NSLocalizedString(@"上传注册人身份证（正面）",nil);
        self.thirdPhotoTipLabel.text = NSLocalizedString(@"身份证为商标注册证上的注册人",nil);
    }else if(self.registerType == 2){
        self.firstPhotoTipLabel.text = NSLocalizedString(@"上传公司商标注册证",nil);
        self.secondPhotoTipLabel.text = NSLocalizedString(@"上传注册公司营业执照",nil);
        self.thirdPhotoTipLabel.text = NSLocalizedString(@"公司须与商标注册证上的公司保持一致",nil);
    }else if(self.registerType == 3){
        self.firstPhotoTipLabel.text = NSLocalizedString(@"上传商标授权书",nil);
        self.secondPhotoTipLabel.text = NSLocalizedString(@"上传被授权公司营业执照",nil);
        self.thirdPhotoTipLabel.text = NSLocalizedString(@"公司须与商标授权书上的被授权公司保持一致",nil);
    }
    
    [self.firstPhotoUploadButton setImage:self.firstUploadImage forState:UIControlStateNormal];
    [self.secondPhotoUploadButton setImage:self.secondUploadImage forState:UIControlStateNormal];
    self.firstPhotoTipView.hidden = (self.firstUploadImage != nil);
    self.secondPhotoTipView.hidden = (self.secondUploadImage != nil);
    
    float photoImageWidth = SCREEN_WIDTH - 64;
    float photoImageHeight = photoImageWidth/622*372;
    self.firstPhotoUploadButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.secondPhotoUploadButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.firstPhotoUploadButton setConstraintConstant:photoImageWidth forAttribute:NSLayoutAttributeWidth];
    [self.firstPhotoUploadButton setConstraintConstant:photoImageHeight forAttribute:NSLayoutAttributeHeight];
    [self.secondPhotoUploadButton setConstraintConstant:photoImageWidth forAttribute:NSLayoutAttributeWidth];
    [self.secondPhotoUploadButton setConstraintConstant:photoImageHeight forAttribute:NSLayoutAttributeHeight];
}

#pragma mark - --------------请求数据----------------------

#pragma mark - --------------系统代理----------------------


#pragma mark - --------------自定义代理/block----------------------


#pragma mark - --------------自定义响应----------------------
- (void)firstHelpButtonClick {
    [self showHelpUI:1];
}

- (void)secondHelpButtonClick {
    [self showHelpUI:2];
}

- (void)uploadFirstPhoto {
    NSLog(@"uploadFirstPhoto");
    if(self.registerType == 0){
        [YYToast showToastWithTitle:NSLocalizedString(@"选择商标注册类型",nil) andDuration:kAlertToastDuration];
        return;
    }
    [self.delegate upLoadPhotoImage:1 pointX:0 pointY:0];
}

- (void)uploadSecondPhoto {
    NSLog(@"uploadSecondPhoto");
    if(self.registerType==0){
        [YYToast showToastWithTitle:NSLocalizedString(@"选择商标注册类型",nil) andDuration:kAlertToastDuration];
        return;
    }
    [self.delegate upLoadPhotoImage:2 pointX:0 pointY:0];
}

#pragma mark - --------------自定义方法----------------------
-(void)showHelpUI:(NSInteger)photoType{
    
    if(_registerType==0){
        [YYToast showToastWithTitle:NSLocalizedString(@"选择商标注册类型",nil) andDuration:kAlertToastDuration];
        
        return;
    }
    float photoUIWidth = 124;
    float photoUIHeight = 172;
    if(photoType == 2){
        photoUIWidth = 256;
    }
    float uirate = (SCREEN_WIDTH-30)/photoUIWidth;
    photoUIWidth = photoUIWidth*uirate;
    photoUIHeight = photoUIHeight*uirate;
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view.frame = CGRectMake(0, 0, photoUIWidth, photoUIHeight);
    //controller.view.backgroundColor = [UIColor colorWithHex:kDefaultImageColor];
    
    NSString *imageName = [NSString stringWithFormat:@"%@brand-help/brandhelpImg%ld_%ld",kYYServerResURL,(long)_registerType,(long)photoType];//
    NSString *imageUrlName = nil;
    if( [UIScreen mainScreen].scale > 1){
        imageUrlName = [NSString stringWithFormat:@"%@@2x.jpg",imageName];
    }else{
        imageUrlName = [NSString stringWithFormat:@"%@.jpg",imageName];
    }
    NSURL *url=[NSURL URLWithString:imageUrlName];
    UIImage *imgFromUrl =[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]];
    controller.view.layer.contentsScale = [UIScreen mainScreen].scale;
    controller.view.layer.contents = (__bridge id _Nullable)(imgFromUrl.CGImage);
    
    self.alert = [[CMAlertView alloc] initWithViews:@[ controller.view] imageFrame:CGRectMake(0, 0, photoUIWidth, photoUIHeight) bgClose:NO];
    [self.alert show];
}

#pragma mark - --------------other----------------------
+(float)cellheight{
    float photoImageWidth = SCREEN_WIDTH - 64;
    float photoImageHeight = photoImageWidth/622*372;
    return 600 - (185 -photoImageHeight)*2;
}

@end
