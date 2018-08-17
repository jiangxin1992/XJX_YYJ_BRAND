//
//  YYSeriesDetailInfoViewCell.m
//  Yunejian
//
//  Created by Apple on 15/12/22.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import "YYSeriesDetailInfoViewCell.h"
#import "YYUserApi.h"
#import "SCLoopScrollView.h"

#import "NSManagedObject+helper.h"
@implementation YYSeriesDetailInfoViewCell
//static NSInteger cellWidth = 435;

- (IBAction)showLookBookPics:(id)sender {
    if(_lookBookModel ==nil || [_lookBookModel.picUrls count] == 0){
        return;
    }
    NSInteger count = [_lookBookModel.picUrls count];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:count];
    if(count > 0){
        for(int i = 0 ; i < count; i++){
            NSString *imageName =[NSString stringWithFormat:@"%@",[[_lookBookModel.picUrls objectAtIndex:i] objectForKey:@"picUrl"]];
            NSString *_imageRelativePath = imageName;
            NSString *imgInfo = [NSString stringWithFormat:@"%@%@|%@",_imageRelativePath,kLookBookImage,@""];
            [tmpArr addObject:imgInfo];
        }
        
    }
    SCLoopScrollView *scrollView = [[SCLoopScrollView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
    scrollView.backgroundColor = [UIColor clearColor];
    //scrollView.defaultImage =[UIImage imageNamed:@"logo"];
    scrollView.images = tmpArr;
    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(scrollView.frame)-100)/2, (CGRectGetHeight(scrollView.frame) -28-15), 100, 28)];
    pageLabel.textColor = [UIColor whiteColor];//[UIColor colorWithHex:@"0xafafafaf99"];
    pageLabel.font = [UIFont systemFontOfSize:15];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.text = [NSString stringWithFormat:@"%d / %lu",1,(unsigned long)[tmpArr count]];
    __block UILabel *weakpageLabel = pageLabel;
    __block NSInteger blockPagecount = [tmpArr count];
    [scrollView show:^(NSInteger index) {
        
    } finished:^(NSInteger index) {
        if(blockPagecount == 0){
            [weakpageLabel setText:@""];
        }else{
            [weakpageLabel setText:[NSString stringWithFormat:@"%ld / %ld",index+1,(long)blockPagecount]];
        }
    }];
    CMAlertView *alert = [[CMAlertView alloc] initWithViews:@[scrollView,pageLabel] imageFrame:CGRectMake(0, 0, 600, 600) bgClose:NO];
    [alert show];

}

-(void)updateUI{
    _sortBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _sortBtn.layer.borderWidth = 1;
    [_sortBtn setImage:[UIImage imageNamed:@"triangle_down_icon"] forState:UIControlStateNormal];
    [_sortBtn setTitle:NSLocalizedString(@"已按款号降序排列",nil) forState:UIControlStateNormal];
    [_sortBtn setImage:[UIImage imageNamed:@"triangle_up_icon"] forState:UIControlStateSelected];
    [_sortBtn setTitle:NSLocalizedString(@"已按款号升序排列",nil) forState:UIControlStateSelected];

    _sortBtn.hidden = NO;
    if([_sortType isEqualToString:kSORT_STYLE_CODE_DESC]){
        _sortBtn.selected = NO;
    }else if([_sortType isEqualToString:kSORT_STYLE_CODE]){
        _sortBtn.selected = YES;
    }else{
      _sortBtn.hidden = YES;
    }
    if (_seriesModel != nil) {
        _nameLabel.text = _seriesModel.name;
        _styleAmountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"共%@款",nil),[_seriesModel.styleAmount stringValue]];
        if(_seriesModel.year){
            _seasonLabel.text = [NSString stringWithFormat:@"%@%@%@%@",@"Season：",[_seriesModel.year stringValue],NSLocalizedString(@"年",nil),_seriesModel.season];
        }else{
            _seasonLabel.text = [NSString stringWithFormat:@"%@%@",@"Season：",_seriesModel.season];
        }
        _supplyTimeLabel.text = [NSString stringWithFormat:@"%@%@-%@",NSLocalizedString(@"发货日期：",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd",[_seriesModel.supplyStartTime stringValue]),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd",[_seriesModel.supplyEndTime stringValue])];
        _orderDueTimeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"最晚下单：%@",nil),getShowDateByFormatAndTimeInterval(@"yyyy/MM/dd",_seriesModel.orderDueTime)];
    }else{
        _nameLabel.text = @"";
        _styleAmountLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ 款",nil),@"0"];
        _seasonLabel.text = [NSString stringWithFormat:@"%@%@",@"Season：",@""];
        _supplyTimeLabel.text = [NSString stringWithFormat:@"%@%@-%@",NSLocalizedString(@"发货日期：",nil),@"",@""];
        _orderDueTimeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"最晚下单：%@",nil),@""];
    }
    [self updateLookBookUI];
    [self loadLookBookInfo];
}

- (IBAction)sortBtnHandler:(id)sender {
    if(_selectButtonClicked){
        _selectButtonClicked(_sortBtn.selected);
    }
}

//+(NSInteger)getCellHeight:(NSString *)descStr{
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineHeightMultiple = 1.5;
//    NSDictionary *attrDict = @{ NSParagraphStyleAttributeName: paraStyle,
//                                NSFontAttributeName: [UIFont systemFontOfSize: 12] };
//
//    float textTotalHeight = getTxtHeight(cellWidth, descStr, attrDict);
//    //textTotalHeight = MAX(textTotalHeight, 65);
//    textTotalHeight = MIN(textTotalHeight, 115);
//    return textTotalHeight;
//}

-(void)loadLookBookInfo{
    WeakSelf(ws);
//    if([self downloadOfflineLookBook:[_seriesModel.id integerValue]]){
//        [self updateLookBookUI];
//    }else if (![YYCurrentNetworkSpace isNetwork]) {
//        [self fetchEntitys];
//    }else{
    if(_lookBookId != nil && [_lookBookId integerValue] > 0){
        [YYUserApi getLookBookInfoWithId:[_lookBookId integerValue] andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYLookBookModel *lookBookModel, NSError *error) {
            if(rspStatusAndMessage.status == kCode100){
                ws.lookBookModel = lookBookModel;
                [ws updateLookBookUI];
            }
        }];
    }
//    }
}


-(void)updateLookBookUI{
    _picsNullTipLabel.hidden = NO;
    if(_lookBookModel !=nil){
        _picsNullTipLabel.hidden = YES;
        NSString *imageRelativePath = _lookBookModel.coverPic;
        sd_downloadWebImageWithRelativePath(NO, imageRelativePath, _lookBookCoverImageView, kLookBookImage, 0);
    }
}


@end
