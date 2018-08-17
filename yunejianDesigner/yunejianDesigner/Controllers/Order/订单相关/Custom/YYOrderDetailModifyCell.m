//
//  YYOrderDetailModifyCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/6/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYOrderDetailModifyCell.h"

#import "YYOrderInfoModel.h"

@interface YYOrderDetailModifyCell()

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property (weak, nonatomic) IBOutlet UIButton *lookLogBtn;

@end

@implementation YYOrderDetailModifyCell

#pragma mark - --------------生命周期--------------
- (void)awakeFromNib {
    [super awakeFromNib];
    [self SomePrepare];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
    self.modifyBtn.layer.cornerRadius = 2.5;
    self.modifyBtn.layer.masksToBounds = YES;

    self.lookLogBtn.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.lookLogBtn.currentTitle attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{}

#pragma mark - --------------请求数据----------------------
-(void)RequestData{}

#pragma mark - --------------自定义响应----------------------


#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------

-(void)updateUI{

    NSInteger needAppendOrderMenu = 0;
    if([self.currentYYOrderInfoModel.isAppend integerValue] == 0){
        if([self.currentYYOrderInfoModel.hasAppend integerValue] == 0){
            if(self.currentOrderConnStatus == YYOrderConnStatusNotFound || self.currentOrderConnStatus == YYOrderConnStatusUnconfirmed || self.currentOrderConnStatus == YYOrderConnStatusLinked ){
                needAppendOrderMenu = 1;//追单
            }
        }else{
            needAppendOrderMenu = 2;//查看追单
        }
    }else{
        if(self.currentYYOrderInfoModel.originalOrderCode ){
            needAppendOrderMenu = 3;//查看原始订单
        }
    }


    //已下单
    BOOL isDesignerConfrim = [_currentYYOrderInfoModel isDesignerConfrim];
    BOOL isBuyerConfrim = [_currentYYOrderInfoModel isBuyerConfrim];

    if(!isBuyerConfrim && !isDesignerConfrim){
        //双方都未确认
        if(needAppendOrderMenu == 3){
            _modifyBtn.hidden = NO;
        }else{
            _modifyBtn.hidden = NO;
        }
    }else{
        if(needAppendOrderMenu == 3){
            _modifyBtn.hidden = YES;
        }else{
            _modifyBtn.hidden = YES;
        }
    }
}
- (IBAction)modifyBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"modifyOrder"]];
    }
}
- (IBAction)lookLogBtnHandler:(id)sender {
    if(self.delegate){
        [self.delegate btnClick:0 section:0 andParmas:@[@"lookModifyLog"]];
    }
}
@end
