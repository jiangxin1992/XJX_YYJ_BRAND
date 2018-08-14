//
//  ChatCell.m
//  AutoLayoutCellDemo
//
//  Created by siping ruan on 16/10/9.
//  Copyright © 2016年 Rasping. All rights reserved.
//

#import "YYMessageChatCell.h"
#import "YYMessageChatModel.h"
#import "SCGIFImageView.h"
#import "ZZCircleProgress.h"

#import <SDWebImage/UIImageView+WebCache.h>

#define URLReger @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"

@interface YYMessageChatCell ()

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet SCGIFImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *sendImageButton;

@end

@implementation YYMessageChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];

    self.sendImageButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailImage:)];
    [self.sendImageButton addGestureRecognizer:tapGesturRecognizer];

    self.message.userInteractionEnabled = YES;
    UITapGestureRecognizer *labGesturRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUrl:)];
    [self.message addGestureRecognizer:labGesturRecognizer];


}

- (void)detailImage:(UIImageView *)image{
    // 代理回调  点击查看大图
    if ([self.delegate respondsToSelector:@selector(YYMessageChatCellDelegateShowBigImage:)]) {
        [self.delegate YYMessageChatCellDelegateShowBigImage:self];
    }
}

- (void)showUrl:(UILabel *)label{

    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:URLReger options:0 error:nil];

    NSArray *results = [regex matchesInString:[self.model.message lowercaseString] options:0 range:NSMakeRange(0, self.model.message.length)];

    NSString *url = @"";

    for (NSTextCheckingResult *result in results) {
        url = [self.model.message substringWithRange:result.range];
    }

    if (![url isEqualToString:@""]) {
        // 跳转
        // 代理回调  点击查看大图
        if ([self.delegate respondsToSelector:@selector(YYMessageChatCellDelegateTapUrl:URL:)]) {
            [self.delegate YYMessageChatCellDelegateTapUrl:self URL:url];
        }
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView chatCellType:(ChatCellType)type
{
    static NSString *reuseIdentifier;
    NSInteger index = 0;
    if (type == ChatCellTypeOther) {
        reuseIdentifier = @"ChatCellTypeOther";
    }else if (type == ChatCellTypeSelf) {
        reuseIdentifier = @"ChatCellTypeSelf";
        index= 1;
    }

    YYMessageChatCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"YYMessageChatCell" owner:self options:0][index];
        cell.backgroundColor = [UIColor clearColor];
        UIImageView *logoIcon = [cell viewWithTag:10001];
        logoIcon.layer.borderWidth = 1;
        logoIcon.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;

        logoIcon.layer.cornerRadius = 23.5;
        logoIcon.layer.masksToBounds = YES;
    }
    return cell;
}

- (void)setModel:(YYMessageChatModel *)model
{
    _model = model;

    if (model.type == ChatTypeOther) {
        self.time.text    = model.time;

        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:URLReger options:0 error:nil];

        NSArray *results = [regex matchesInString:[model.message lowercaseString] options:0 range:NSMakeRange(0, model.message.length)];

        NSString *url = @"";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.message];
        for (NSTextCheckingResult *result in results) {
            url = [model.message substringWithRange:result.range];
            //字符串字体大小、颜色全部统一样式
            [str addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:result.range];

        }
        self.message.attributedText = str;

        NSString *logoPath = model.icon;
        sd_downloadWebImageWithRelativePath(NO, logoPath, self.icon, kLogoCover, 0);
    }

    if ([model.chatType isEqualToString:@"IMAGE"]) {
        self.sendImageButton.hidden = NO;

        NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.message, kSendMessageImage]];
        [self.sendImageButton sd_setImageWithURL:imgUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (cacheType == SDImageCacheTypeNone || cacheType == SDImageCacheTypeDisk) {
                // 回调刷新
                if ([self.delegate respondsToSelector:@selector(YYMessageChatCellDelegate:)]) {
                    [self.delegate YYMessageChatCellDelegate:self];
                }
            }
        }];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@""];
        self.message.attributedText = str;
    }else{
        self.sendImageButton.hidden = YES;
        [self.sendImageButton setImage:nil];
    }
}

- (IBAction)headBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:-1 section:-1 andParmas:@[@"buyerInfo"]];
    }
}
@end

@interface ChatCellSelf ()
@property (weak, nonatomic) IBOutlet UILabel *timeSelf;
@property (weak, nonatomic) IBOutlet UILabel *messageSelf;
@property (weak, nonatomic) IBOutlet SCGIFImageView *iconSelf;
@property (weak, nonatomic) IBOutlet UIImageView *sendImageButtonSelf;
@property (weak, nonatomic) IBOutlet UIView *progressBackView;

@property (weak, nonatomic) IBOutlet UIImageView *changeBG;
@property (weak, nonatomic) IBOutlet UIButton *errorButton;

@property (strong, nonatomic) ZZCircleProgress *progressView;

@end

@implementation ChatCellSelf

- (void)awakeFromNib{
    [super awakeFromNib];

    //无小圆点、同动画时间
    self.progressView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(0, 0, 0, 0) pathBackColor:[UIColor grayColor] pathFillColor:[UIColor whiteColor] startAngle:-90 strokeWidth:2];
    self.progressView.showPoint = NO;
    self.progressView.animationModel = CircleIncreaseSameTime;
    self.progressView.progress = 0.0;
    self.progressView.increaseFromLast = YES;

    [self.progressBackView addSubview:self.progressView];

    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.changeBG.mas_centerX);
        make.centerY.mas_equalTo(self.changeBG.mas_centerY);
        make.width.height.mas_equalTo(35);
    }];

    self.sendImageButtonSelf.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detailImage:)];
    [self.sendImageButtonSelf addGestureRecognizer:tapGesturRecognizer];

    self.messageSelf.userInteractionEnabled = YES;
    UITapGestureRecognizer *labGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showUrl:)];
    [self.messageSelf addGestureRecognizer:labGesturRecognizer];

}

- (IBAction)errorClick:(UIButton *)sender {
    // 代理回调 错误提示
    if ([self.delegate respondsToSelector:@selector(YYMessageChatCellDelegateUploadAgain:)]) {
        [self.delegate YYMessageChatCellDelegateUploadAgain:self];
    }
    // 隐藏
    self.isShowError = NO;
}

- (void)setIsShowError:(BOOL)isShowError{
    [super setIsShowError:isShowError];
    self.errorButton.hidden = !isShowError;
}

- (void)setModel:(YYMessageChatModel *)model
{
    [super setModel:model];

    if (model.type == ChatTypeSelf) {
        self.timeSelf.text = model.time;

        NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:URLReger options:0 error:nil];

        NSArray *results = [regex matchesInString:[model.message lowercaseString] options:0 range:NSMakeRange(0, model.message.length)];

        NSString *url = @"";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:model.message];
        for (NSTextCheckingResult *result in results) {
            url = [model.message substringWithRange:result.range];
            //字符串字体大小、颜色全部统一样式
            [str addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:result.range];

        }
        self.messageSelf.attributedText = str;


        NSString *logoPath = model.icon;
        sd_downloadWebImageWithRelativePath(NO, logoPath, self.iconSelf, kLogoCover, 0);
    }

    if ([model.chatType isEqualToString:@"IMAGE"]) {
        self.sendImageButtonSelf.hidden = NO;
        self.progressBackView.hidden = YES;

        NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",model.message, kSendMessageImage]];
        [self.sendImageButtonSelf sd_setImageWithPreviousCachedImageWithURL:imgUrl placeholderImage:nil options:SDWebImageRetryFailed progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            // 回调刷新
            if (cacheType == SDImageCacheTypeNone || cacheType == SDImageCacheTypeDisk) {
                // 回调刷新
                if ([self.delegate respondsToSelector:@selector(YYMessageChatCellDelegate:)]) {
                    [self.delegate YYMessageChatCellDelegate:self];
                }
            }
        }];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@""];
        self.messageSelf.attributedText = str;
    }else if([model.chatType isEqualToString:@"IMAGE-location"]) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@""];
        self.messageSelf.attributedText = str;
        self.sendImageButtonSelf.hidden = NO;

        if (model.isUploadSuccess) {
            self.progressBackView.hidden = YES;
        }else{
            self.progressBackView.hidden = NO;
        }

        // 宽度
        CGFloat width = 160;
        UIImage *showImage = [self imageCompressForWidth:model.locationImage targetWidth:width];

        self.sendImageButtonSelf.image = showImage;

    }else{
        self.sendImageButtonSelf.hidden = YES;
        self.progressBackView.hidden = YES;
        [self.sendImageButtonSelf setImage:nil];
    }
}

- (void)setProgress:(CGFloat)progress{
    [super setProgress:progress];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = progress;
    });
}

- (void)setIsHiddenProgress:(BOOL)isHiddenProgress{
    [super setIsHiddenProgress:isHiddenProgress];
    self.progressBackView.hidden = isHiddenProgress;
}

//指定宽度按比例缩放图片
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

@end


