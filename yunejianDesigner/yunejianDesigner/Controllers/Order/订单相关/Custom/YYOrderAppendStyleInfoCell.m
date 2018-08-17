//
//  YYOrderAppendStyleInfoCell.m
//  Yunejian
//
//  Created by Apple on 16/8/8.
//  Copyright © 2016年 yyj. All rights reserved.
//

#import "YYOrderAppendStyleInfoCell.h"
@implementation YYOrderAppendStyleInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateUI{
    _nameLabel.text = _styleModel.name;
    _codeLabel.text = _styleModel.styleCode;
    
    if([_selectCellSections containsObject:@(_indexPath.section)]){
        [_selectBtn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    }else{
        [_selectBtn setImage:[UIImage imageNamed:@"noChecked"] forState:UIControlStateNormal];
    }
    
    NSString *imageRelativePath = _styleModel.albumImg;
    sd_downloadWebImageWithRelativePath(NO, imageRelativePath,_albumImgView, kStyleCover, 0);
}
- (IBAction)selectBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:nil];
    }
}
@end
