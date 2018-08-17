//
//  YYInventoryTableViewCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYInventoryTableViewCell.h"

#import "SCGIFImageView.h"

@interface YYInventoryTableViewCell()
@property (weak, nonatomic) IBOutlet SCGIFImageView *styleImageView;
@property (weak, nonatomic) IBOutlet UILabel *styleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet SCGIFImageView *colorImageView;
@property (weak, nonatomic) IBOutlet UIView *unReadFlagView;

@end

@implementation YYInventoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *imageRelativePath = _allottingModel.albumImg;
    _styleImageView.layer.cornerRadius = 2.5;
    _styleImageView.layer.borderColor = [UIColor colorWithHex:@"efefef"].CGColor;
    _styleImageView.layer.borderWidth = 1;
    _styleImageView.layer.masksToBounds = YES;
    sd_downloadWebImageWithRelativePath(NO, imageRelativePath, _styleImageView, kStyleCover, 0);
    
    _styleNameLabel.text = _allottingModel.styleName;
    _colorLabel.text = _allottingModel.colorName;
    NSString *colorValue = _allottingModel.colorValue;    
    _colorImageView.layer.borderWidth = 1;
    _colorImageView.layer.borderColor =  [UIColor colorWithHex:@"efefef"].CGColor;
    if (colorValue) {
        if ([colorValue hasPrefix:@"#"] && [colorValue length] == 7) {
            //16进制的色值
            UIColor *color = [UIColor colorWithHex:[colorValue substringFromIndex:1]];
            [_colorImageView setImage:[UIColor createImageWithColor:color]];
        }else{
            //图片
            NSString *imageRelativePath = colorValue;
            if(imageRelativePath)
            sd_downloadWebImageWithRelativePath(NO, imageRelativePath, _colorImageView, kStyleColorImageCover, 0);
        }
    }
    
    _unReadFlagView.layer.cornerRadius = 4;
    _unReadFlagView.layer.masksToBounds = YES;
    if([_allottingModel.hasRead integerValue]){
        _unReadFlagView.hidden = YES;
    }else{
        _unReadFlagView.hidden = NO;
    }

}

@end
