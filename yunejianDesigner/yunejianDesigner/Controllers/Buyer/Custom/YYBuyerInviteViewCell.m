//
//  YYBuyerInviteViewCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/6/22.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerInviteViewCell.h"
#import "UIView+UpdateAutoLayoutConstraints.h"
static NSInteger curCellWidth;
@implementation YYBuyerInviteViewCell

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
    _logoImageView.backgroundColor = [UIColor whiteColor];
    //_lookbookImage1.backgroundColor = [UIColor blackColor];
    _lookbookImage1.contentMode = UIViewContentModeScaleAspectFill;
    if(_buyerModel != nil){
        _nameLabel.text = _buyerModel.name;
        //_emailLabel.text =  _buyerModel.city;
        //        NSString *retailerNameStr =[_designerModel.retailerNameList componentsJoinedByString:@" "];
        //        _connBuyersLabel.text =[NSString stringWithFormat:@"合作过的买手店:%@",retailerNameStr] ;
        if(_buyerModel.businessBrands && [_buyerModel.businessBrands count] > 0){
        
            NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
            paraStyle.lineSpacing = 8;
            NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                        NSFontAttributeName: [UIFont systemFontOfSize: 12] };
            NSString* connInfo = [_buyerModel.businessBrands componentsJoinedByString:@"，"];
            CGSize connInfoSize = [connInfo sizeWithAttributes:attrDict];
            if(connInfoSize.width > (curCellWidth-34)){
                _connInfoLabel.attributedText = [[NSAttributedString alloc] initWithString:connInfo attributes: attrDict];
            }else{
                _connInfoLabel.text = connInfo;
            }
        }else{
            _connInfoLabel.text = @"";
        }
        
        _priceLabel.text = replaceMoneyFlag([NSString stringWithFormat:@"￥%@ -￥%@",_buyerModel.priceMin,_buyerModel.priceMax],0);
        sd_downloadWebImageWithRelativePath(NO, _buyerModel.logoPath, _logoImageView, kLogoCover, 0);
        for (int i=0; i<1; i++) {
            UIImageView *lookbookImage = [self valueForKey:[NSString stringWithFormat:@"lookbookImage%d",(i+1)]];
            NSString *imageRelativePath = @"";
            if(i < [_buyerModel.storeImgs count]){
                imageRelativePath = [_buyerModel.storeImgs objectAtIndex:i];
            }
            lookbookImage.contentMode = UIViewContentModeScaleAspectFit;
            sd_downloadWebImageWithRelativePath(YES, imageRelativePath, lookbookImage, kStyleDetailCover, UIViewContentModeScaleAspectFit);
        }
        
        //add
        _addBtn.hidden = YES;
        //[_addBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        //[_addBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
        _connStatusLabel.hidden = YES;
        if([_buyerModel.connectStatus integerValue] == kConnStatus){
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
        _nameLabel.text = @"";
        //_emailLabel.text =  @"";
        //        _connBuyersLabel.text = @"合作过的买手店:";
        //        _brandDescLabel.text = @"无品牌简介";
        //_detailBtn.hidden = YES;
        _addBtn.hidden = YES;
        _connStatusLabel.hidden = YES;
    }
//    _addBtn.layer.cornerRadius = 2.5;
//    _connStatusLabel.layer.cornerRadius = 2.5;
//    _connStatusLabel.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 25;
    _logoImageView.layer.masksToBounds = YES;
    _lookbookImage1.layer.cornerRadius = 2.5;
    _lookbookImage1.layer.masksToBounds = YES;
    
    float curCellHeight =  (float)curCellWidth/370*280;
    [_lookbookImage1 setConstraintConstant:curCellHeight forAttribute:NSLayoutAttributeHeight];
    
}

+(float)HeightForCell:(NSInteger )cellWidth connInfo:(NSString*)connInfo{
    //370 260  375  350  | 341 260    375 426
    
      //370 280  | 375 260
    curCellWidth = cellWidth ;
    float curCellHeight =  (float)curCellWidth/370*280;
    
    NSInteger textHeight = 0;
    if([connInfo isEqualToString:@""]){
        textHeight = 15;
    }else{
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 8;
        NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
                                    NSFontAttributeName: [UIFont systemFontOfSize: 12] };
        CGSize connInfoSize = [connInfo sizeWithAttributes:attrDict];
        if(connInfoSize.width > (curCellWidth-34)){
            textHeight = getTxtHeight(curCellWidth-34, connInfo, attrDict);
        }else{
           textHeight = 15;
        }
        
        
        // textHeight = getTxtHeight(txtWidth, desc, @{NSFontAttributeName:[UIFont systemFontOfSize:15]});
    }
    CGFloat returnHeight = 426 + curCellHeight-260 +textHeight-61;
    return returnHeight;
}

@end
