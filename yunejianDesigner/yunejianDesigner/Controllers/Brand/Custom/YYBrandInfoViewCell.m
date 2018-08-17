//
//  YYBrandInfoViewCell.m
//  Yunejian
//
//  Created by Apple on 15/12/3.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYBrandInfoViewCell.h"
#import "UIView+UpdateAutoLayoutConstraints.h"

static NSInteger curCellWidth;


@implementation YYBrandInfoViewCell
- (IBAction)addBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:@[]];
    }
}

- (IBAction)detaiBtnHandler:(id)sender {
    if(self.delegate){
       // [self.delegate btnClick:_indexPath.row section:_indexPath.section andParmas:nil];
    }
}

-(void)updateUI{
    if(_designerModel != nil){
        _nameLabel.text = _designerModel.brandName;
        _emailLabel.text =  _designerModel.designerName;
//        NSString *retailerNameStr =[_designerModel.retailerNameList componentsJoinedByString:@" "];
//        _connBuyersLabel.text =[NSString stringWithFormat:@"合作过的买手店:%@",retailerNameStr] ;
        
        sd_downloadWebImageWithRelativePath(NO, _designerModel.logo, _logoImageView, kLogoCover, 0);
        for (int i=0; i<1; i++) {
            SCGIFImageView *lookbookImage = [self valueForKey:[NSString stringWithFormat:@"lookbookImage%d",(i+1)]];
            NSString *imageRelativePath = @"";
            if(i < [_designerModel.indexPicList count]){
                imageRelativePath = [_designerModel.indexPicList objectAtIndex:i];
            }
            sd_downloadWebImageWithRelativePath(NO, imageRelativePath, lookbookImage, kStyleDetailCover, 0);

        }
        
        //add
        _addBtn.hidden = YES;
        //[_addBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        //[_addBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
        _connStatusLabel.hidden = YES;
        if([_designerModel.connectStatus integerValue] == YYUserConnStatusNone){
            _addBtn.hidden = NO;
        }else {
            _connStatusLabel.hidden = NO;
        }
        
        //desc
//        NSString *descStr = _designerModel.brandDescription;
//        if([descStr isEqualToString:@""]){
//            descStr = @"无品牌简介";
//        }
//        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//        paraStyle.lineHeightMultiple = 1.3;
//        NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
//                                    NSFontAttributeName: [UIFont systemFontOfSize: 12] };
//        CGSize textSize = [descStr sizeWithAttributes:attrDict];
//        if(textSize.width > cellWidth*2){
//            _detailBtn.hidden = NO;
//            if(_curShowDetailRow == _indexPath.row){
//                _detailBtn.selected = YES;
//            }else{
//                _detailBtn.selected = NO;
//            }
//            //[descStr s];
//        }else{
//            if(textSize.width < cellWidth){
//                descStr = [descStr stringByAppendingString:@"\n"];
//            }
//            _detailBtn.hidden = YES;
//        }
//        _brandDescLabel.attributedText = [[NSAttributedString alloc] initWithString: descStr attributes: attrDict];
        
    }else{
        sd_downloadWebImageWithRelativePath(NO, @"", _logoImageView, kLogoCover, 0);
        sd_downloadWebImageWithRelativePath(NO, @"", _lookbookImage1, kStyleDetailCover, 0);
//        sd_downloadWebImageWithRelativePath(NO, @"", _lookbookImage2, kLookBookCover, 0);
//        sd_downloadWebImageWithRelativePath(NO, @"", _lookbookImage3, kLookBookCover, 0);
        _nameLabel.text = NSLocalizedString(@"品牌名称",nil);
        _emailLabel.text =  NSLocalizedString(@"设计名称",nil);
//        _connBuyersLabel.text = @"合作过的买手店:";
//        _brandDescLabel.text = @"无品牌简介";
        _detailBtn.hidden = YES;
        _addBtn.hidden = YES;
        _connStatusLabel.hidden = YES;
    }
    _addBtn.layer.cornerRadius = 2.5;
    _connStatusLabel.layer.cornerRadius = 2.5;
    _connStatusLabel.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 25;
    _logoImageView.layer.masksToBounds = YES;
    _lookbookImage1.layer.cornerRadius = 2.5;
    _lookbookImage1.layer.masksToBounds = YES;
    
    float curCellHeight =  (float)curCellWidth/341*260;
    [_lookbookImage1 setConstraintConstant:curCellHeight forAttribute:NSLayoutAttributeHeight];

}

+(float)HeightForCell:(NSInteger )cellWidth{
    //375 260  375  350  | 341 260 375 426
    curCellWidth = cellWidth - (375 - 341) ;
    float curCellHeight =  (float)curCellWidth/341*260;
    
    return 426 + curCellHeight-260;
}
@end
