//
//  YYRegisterTableBuyerPhotosCell.m
//  Yunejian
//
//  Created by Apple on 15/12/6.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYBuyerModifyInfoUploadViewCell.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
@implementation YYBuyerModifyInfoUploadViewCell{
    NSInteger itemWidth;
    NSInteger maxPhotoNum;
}
#pragma mark - awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateParamInfo:nil];
}

-(void)updateParamInfo:(NSArray*)info{
    _updateTipLabel.text = NSLocalizedString(@"上传照片",nil);
    maxPhotoNum = 8;
}
#pragma mark - update
-(void)updateCellInfo:(NSArray*)info{
    NSInteger imgnum = [info count];
    SCGIFButtonView *imageBtn = nil;
    UIButton *deleteBtn = nil;
    
    if(itemWidth == 0 ){
        itemWidth = (SCREEN_WIDTH - 17*2 -15*2 -80)/3;
        
        [_photoImageTipView1 setConstraintConstant:itemWidth forAttribute:NSLayoutAttributeHeight];
        [_photoImageTipView1 setConstraintConstant:itemWidth forAttribute:NSLayoutAttributeWidth];
        for (int i =0; i<8; i++) {
            imageBtn = [self valueForKey:[NSString stringWithFormat:@"photoIamgeBtn%d",(i+1)]];
            [imageBtn setConstraintConstant:itemWidth forAttribute:NSLayoutAttributeHeight];
            [imageBtn setConstraintConstant:itemWidth forAttribute:NSLayoutAttributeWidth];
        }
    }
    _photoImageTipView1.hidden = YES;
    NSInteger tipViewWidth = itemWidth;
    NSInteger tipViewHeight = itemWidth;
    NSInteger itemspace = 15; //top 15 left 17
    for (int i =0; i<8; i++) {
        imageBtn = [self valueForKey:[NSString stringWithFormat:@"photoIamgeBtn%d",(i+1)]];
        deleteBtn = [self valueForKey:[NSString stringWithFormat:@"photoDeleteBtn%d",(i+1)]];
        imageBtn.hidden = NO;
        deleteBtn.hidden = NO;
        imageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if(i == imgnum ){
            if(imgnum >= maxPhotoNum ){
                imageBtn.hidden = YES;
                deleteBtn.hidden = YES;
                _photoImageTipView1.hidden = YES;
            }else{
                imageBtn.hidden = NO;
                [imageBtn setImage:nil forState:UIControlStateNormal];
                deleteBtn.hidden = YES;
                _photoImageTipView1.hidden = NO;
            }
            _tipViewLayoutTopConstraint.constant = 15 +(i/3)*(tipViewHeight+itemspace);
            _tipViewLayoutLeftConstraint.constant = 100 + (i%3)*(tipViewWidth+itemspace);
            NSLog(@"%f,%f",_tipViewLayoutTopConstraint.constant,_tipViewLayoutLeftConstraint.constant );
        }else if(i < imgnum){
            if([[info objectAtIndex:i] isKindOfClass:[UIImage class]]){
                [imageBtn setImage:[info objectAtIndex:i] forState:UIControlStateNormal];
            }else{
                NSString *imageRelativePath=[info objectAtIndex:i];
                sd_downloadWebImageWithRelativePath(NO, imageRelativePath, imageBtn,kLookBookImage, 0);
            }
            
        }else{
            imageBtn.hidden = YES;
            deleteBtn.hidden = YES;
            [imageBtn setImage:nil forState:UIControlStateNormal];
        }
    }
    
}
#pragma mark - 上传照片
- (IBAction)photoBtnClicked1:(id)sender{
    if(_photoDeleteBtn1.hidden == NO){
        return;
    }
    [self.delegate btnClick:1 section:0 andParmas:@[@"add"]];
}

- (IBAction)photoBtnClicked2:(id)sender{
    if(_photoDeleteBtn2.hidden == NO){
        return;
    }
    [self.delegate btnClick:2 section:0 andParmas:@[@"add"]];
}

- (IBAction)photoBtnClicked3:(id)sender{
    if(_photoDeleteBtn3.hidden == NO){
        return;
    }
    [self.delegate btnClick:3 section:0 andParmas:@[@"add"]];
}
- (IBAction)photoBtnClicked4:(id)sender{
    if(_photoDeleteBtn4.hidden == NO){
        return;
    }
    [self.delegate btnClick:4 section:0 andParmas:@[@"add"]];
}

- (IBAction)photoBtnClicked5:(id)sender{
    if(_photoDeleteBtn5.hidden == NO){
        return;
    }
    [self.delegate btnClick:5 section:0 andParmas:@[@"add"]];
}

- (IBAction)photoBtnClicked6:(id)sender{
    if(_photoDeleteBtn6.hidden == NO){
        return;
    }
    [self.delegate btnClick:6 section:0 andParmas:@[@"add"]];
}
- (IBAction)photoBtnClicked7:(id)sender{
    if(_photoDeleteBtn7.hidden == NO){
        return;
    }
    [self.delegate btnClick:7 section:0 andParmas:@[@"add"]];
}

- (IBAction)photoBtnClicked8:(id)sender{
    if(_photoDeleteBtn8.hidden == NO){
        return;
    }
    [self.delegate btnClick:8 section:0 andParmas:@[@"add"]];
}
#pragma mark - 删除照片
- (IBAction)photoDeleteBtnClicked1:(id)sender{
    [self.delegate btnClick:1 section:0 andParmas:@[@"delete"]];
}
- (IBAction)photoDeleteBtnClicked2:(id)sender{
    [self.delegate btnClick:2 section:0 andParmas:@[@"delete"]];
}
- (IBAction)photoDeleteBtnClicked3:(id)sender{
    [self.delegate btnClick:3 section:0 andParmas:@[@"delete"]];
}
- (IBAction)photoDeleteBtnClicked4:(id)sender{
    [self.delegate btnClick:4 section:0 andParmas:@[@"delete"]];
}
- (IBAction)photoDeleteBtnClicked5:(id)sender{
    [self.delegate btnClick:5 section:0 andParmas:@[@"delete"]];
}
- (IBAction)photoDeleteBtnClicked6:(id)sender{
    [self.delegate btnClick:6 section:0 andParmas:@[@"delete"]];
}
- (IBAction)photoDeleteBtnClicked7:(id)sender{
    [self.delegate btnClick:7 section:0 andParmas:@[@"delete"]];
}
- (IBAction)photoDeleteBtnClicked8:(id)sender{
    [self.delegate btnClick:8 section:0 andParmas:@[@"delete"]];
    
}
#pragma mark - 获取高度
+(float)cellHeight:(NSInteger)count{
    NSInteger itemWidth = (SCREEN_WIDTH - 17*2 -15*2 -80)/3; //top 15 bottom 39
    
    return (15 + itemWidth)*((count/3)+1) +20;
}
#pragma mark - Other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
