//
//  YYBuyerInfoContactCell.m
//  YunejianBuyer
//
//  Created by yyj on 2017/1/5.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "YYBuyerInfoContactCell.h"

#import "YYTypeTextView.h"
#import "YYTypeButton.h"
#import "YYNoDataView.h"

#import "YYBuyerInfoTool.h"
#import "YYBuyerContactInfoModel.h"
#import "YYBuyerSocialInfoModel.h"
#import "YYBuyerHomeInfoModel.h"

@interface YYBuyerInfoContactCell ()

@property (nonatomic,strong) NSMutableArray *contactArr;
@property (nonatomic,strong) NSMutableArray *socialArr;

@property (nonatomic,strong) UILabel *contactTitleLabel;
@property (nonatomic,strong) UILabel *socialTitleLabel;

@property (nonatomic,strong) UIView *noIntroductionDataView;

@end

@implementation YYBuyerInfoContactCell
#pragma mark - init
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithBlock:(void(^)(NSString *type ,YYTypeButton *typeButton))block
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _cellblock=block;
    }
    return self;
}

-(id)initWithBlock:(void(^)(NSString *type ,YYTypeButton *typeButton))block{
    self=[super init];
    if(self)
    {
        _cellblock=block;
    }
    return self;
}
#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
//@property (strong, nonatomic) NSNumber <Optional>*auth;//0 合作可见，1, 自己可见，2 全部可见
//@property (strong, nonatomic) NSNumber <Optional>*connectStatus;//": -1 没有关系0 我已发送邀请，对方未处理1 已为好友2 对方已发出邀请，我未处理
//数据解析  排序/视图创建
-(void)PrepareData
{
    NSMutableArray *_contactTempArr=[[NSMutableArray alloc] init];
    NSMutableArray *_socialTempArr=[[NSMutableArray alloc] init];
    
    [_homePageModel.userContactInfos enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL haveValue = NO;
        BOOL isVisible = NO;
        NSInteger auth = 0;
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *value = (NSDictionary *)obj;
            
            if(![YYBuyerInfoTool isNilOrEmptyWithContactValue:[value objectForKey:@"contactValue"] WithContactType:[value objectForKey:@"contactType"]])
            {
                haveValue = YES;
                auth = [[value objectForKey:@"auth"] integerValue];
            }
            
        }else if([obj isKindOfClass:[YYBuyerContactInfoModel class]])
        {
            YYBuyerContactInfoModel *value = (YYBuyerContactInfoModel *)obj;
            
            if(![YYBuyerInfoTool isNilOrEmptyWithContactValue:value.contactValue WithContactType:value.contactType])
            {
                haveValue = YES;
                auth = [value.auth integerValue];
            }
        }
        
        if(haveValue)
        {
            if(_isHomePage){
                isVisible = YES;
            }else
            {
                if(!auth)
                {
                    //合作可见
                    if([_homePageModel.connectStatus integerValue] == 1)
                    {
                        //已经合作了
                        isVisible = YES;
                    }else
                    {
                        isVisible = NO;
                    }
                }else if(auth == 1)
                {
                    //自己可见
                    isVisible = NO;
                }else if(auth ==2)
                {
                    //全部可见
                    isVisible = YES;
                }
            }
            
            if(isVisible){
                [_contactTempArr addObject:obj];
            }
        }
    }];
    
    [_homePageModel.userSocialInfos enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *value = (NSDictionary *)obj;
            if(![NSString isNilOrEmpty:[value objectForKey:@"socialName"]])
            {
                [_socialTempArr addObject:value];
            }
        }else if([obj isKindOfClass:[YYBuyerSocialInfoModel class]])
        {
            YYBuyerSocialInfoModel *value = (YYBuyerSocialInfoModel *)obj;
            if(![NSString isNilOrEmpty:value.socialName])
            {
                [_socialTempArr addObject:value];
            }
        }
        
    }];
    
    if(_contactArr)
    {
        [_contactArr removeAllObjects];
    }else
    {
        _contactArr=[[NSMutableArray alloc] init];
    }
    
    if(_socialArr)
    {
        [_socialArr removeAllObjects];
    }else
    {
        _socialArr=[[NSMutableArray alloc] init];
    }
    
    if(_contactTempArr.count)
    {
        //先排个序
        for (int i = 0; i < _contactTempArr.count - 1; i++) {
            //比较的躺数
            for (int j = 0; j < _contactTempArr.count - 1 - i; j++) {
                id obj = [_contactTempArr objectAtIndex:j];
                NSInteger contactType = 0;
                if([obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *value = (NSDictionary *)obj;
                    contactType = [[value objectForKey:@"contactType"] integerValue];
                }else if([obj isKindOfClass:[YYBuyerContactInfoModel class]])
                {
                    
                    YYBuyerContactInfoModel *value = (YYBuyerContactInfoModel *)obj;
                    contactType = [value.contactValue integerValue];
                }
                //三目 条件以外的nextsocialTypeType表示新加字段 显示在最后
                NSInteger idx=contactType==0?0:contactType==1?2:contactType==2?3:contactType==3?4:contactType==4?1:-1;
                
                id nextobj = [_contactTempArr objectAtIndex:j+1];
                NSInteger nextcontactType = 0;
                if([nextobj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *nextvalue = (NSDictionary *)nextobj;
                    nextcontactType = [[nextvalue objectForKey:@"contactType"] integerValue];
                }else if([nextobj isKindOfClass:[YYBuyerContactInfoModel class]])
                {
                    YYBuyerContactInfoModel *nextvalue = (YYBuyerContactInfoModel *)nextobj;
                    nextcontactType = [nextvalue.contactValue integerValue];
                }
                NSInteger nextidx=nextcontactType==0?0:nextcontactType==1?2:nextcontactType==2?3:nextcontactType==3?4:nextcontactType==4?1:-1;
                //比较的次数
                if (idx > nextidx) {
                    //这里为升序排序
                    NSDictionary *temp = obj;
                    _contactTempArr[j] = _contactTempArr[j + 1];
                    //OC中的数组只能存储对象，所以这里转换成string对象
                    _contactTempArr[j + 1] = temp;
                }
            }
        }
        
        
        //0 邮箱，1 电话，2 QQ，3 微信号', 4 固定电话
        //0 邮箱, 4 固定电话 3 微信号, 1 电话, 2 QQ
        //        _contactArr = @[@"email_icon1",@"telephone_icon",@"weixin_icon",@"phone_icon",@"qq_icon"];
        
        [_contactTempArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BOOL isTextViewType=NO;
            NSInteger contactType = 0;
            NSString *contactValue = @"";
            NSString *type = @"";
            NSMutableDictionary *tempDict = nil;
            YYBuyerContactInfoModel *tempValue = nil;
            if([obj isKindOfClass:[NSDictionary class]])
            {
                //                /0 邮箱，1 电话，2 QQ，3 微信号'，4 固定电话
                NSDictionary *value = (NSDictionary *)obj;
                tempDict=[value mutableCopy];
                contactType = [[value objectForKey:@"contactType"] integerValue];
                type = contactType==0?@"email":contactType==1?@"phone":contactType==2?@"qq":contactType==3?@"weixin":contactType==4?@"telephone":@"";
                if(contactType == 0 || contactType == 1 || contactType == 4)
                {
                    if(_isHomePage)
                    {
                        isTextViewType = YES;
                    }else
                    {
                        isTextViewType = NO;
                    }
                }else
                {
                    isTextViewType = YES;
                }
                contactValue = [self getValueForObj:value];
            }else if([obj isKindOfClass:[YYBuyerContactInfoModel class]])
            {
                YYBuyerContactInfoModel *value = (YYBuyerContactInfoModel *)obj;
                tempValue=[value copy];
                contactType = [value.contactType integerValue];
                type = contactType==0?@"email":contactType==1?@"phone":contactType==2?@"qq":contactType==3?@"weixin":contactType==4?@"telephone":@"";
                if(contactType == 0 || contactType == 1 || contactType == 4)
                {
                    if(_isHomePage)
                    {
                        isTextViewType = YES;
                    }else
                    {
                        isTextViewType = NO;
                    }
                }else
                {
                    isTextViewType = YES;
                }
                contactValue = [self getValueForObj:value];
            }
            
            if(isTextViewType)
            {
                YYTypeTextView *contactTextView = [YYTypeTextView getCustomTextViewWithStr:@"" WithFont:13.0f WithTextColor:_define_black_color];
                contactTextView.text = contactValue;
                contactTextView.editable = NO;
                contactTextView.type = type;
                contactTextView.value = obj;
                contactTextView.scrollEnabled = NO;
                contactTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                if([obj isKindOfClass:[NSDictionary class]])
                {
                    if(tempDict)
                    {
                        [tempDict setObject:contactTextView forKey:@"view"];
                        [_contactArr addObject:tempDict];
                    }
                }else  if([obj isKindOfClass:[YYBuyerContactInfoModel class]])
                {
                    if(tempValue)
                    {
                        tempValue.view = contactTextView;
                        [_contactArr addObject:tempValue];
                    }
                }
            }else
            {
                YYTypeButton *contactButton = [YYTypeButton getCustomTitleBtnWithAlignment:1 WithFont:13.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:[UIColor colorWithHex:kDefaultBlueColor] WithSelectedTitle:nil WithSelectedColor:nil];
                contactButton.type = type;
                contactButton.value = obj;
                [contactButton addTarget:self action:@selector(contactAction:) forControlEvents:UIControlEventTouchUpInside];
                //非微信
                //                NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:contactValue];
                //                NSRange contentRange = {0,[content length]};
                //                [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                //                [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kDefaultTitleColor_phone] range:contentRange];
                //                [contactButton setAttributedTitle:content forState:UIControlStateNormal];
                [contactButton setTitle:contactValue forState:UIControlStateNormal];
                if([obj isKindOfClass:[NSDictionary class]])
                {
                    if(tempDict)
                    {
                        [tempDict setObject:contactButton forKey:@"view"];
                        [_contactArr addObject:tempDict];
                    }
                }else  if([obj isKindOfClass:[YYBuyerContactInfoModel class]])
                {
                    if(tempValue)
                    {
                        tempValue.view = contactButton;
                        [_contactArr addObject:tempValue];
                    }
                }
            }
        }];
    }
    
    if(_socialTempArr.count)
    {
        //先排个序
        for (int i = 0; i < _socialTempArr.count - 1; i++) {
            //比较的躺数
            for (int j = 0; j < _socialTempArr.count - 1 - i; j++) {
                
                id obj = [_socialTempArr objectAtIndex:j];
                NSInteger socialType = 0;
                if([obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *value = (NSDictionary *)obj;
                    socialType = [[value objectForKey:@"socialType"] integerValue];
                }else if([obj isKindOfClass:[YYBuyerSocialInfoModel class]])
                {
                    YYBuyerSocialInfoModel *value = (YYBuyerSocialInfoModel *)obj;
                    socialType = [value.socialType integerValue];
                }
                NSInteger idx=socialType==0?0:socialType==1?2:socialType==2?1:socialType==3?3:-1;
                
                id nextobj = [_socialTempArr objectAtIndex:j+1];
                NSInteger nextsocialTypeType = 0;
                if([nextobj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *value = (NSDictionary *)obj;
                    nextsocialTypeType = [[value objectForKey:@"socialType"] integerValue];
                }else if([nextobj isKindOfClass:[YYBuyerSocialInfoModel class]])
                {
                    YYBuyerSocialInfoModel *value = (YYBuyerSocialInfoModel *)obj;
                    nextsocialTypeType = [value.socialType integerValue];
                }
                //三目 条件以外的nextsocialTypeType表示新加字段 显示在最后
                NSInteger nextidx=nextsocialTypeType==0?0:nextsocialTypeType==1?2:nextsocialTypeType==2?1:nextsocialTypeType==3?3:-1;
                
                //比较的次数
                if (idx > nextidx) {
                    //这里为升序排序
                    NSDictionary *temp = obj;
                    _socialTempArr[j] = _socialTempArr[j + 1];
                    //OC中的数组只能存储对象，所以这里转换成string对象
                    _socialTempArr[j + 1] = temp;
                }
            }
        }
        
        //0 新浪微博，1 微信公众号，2 Facebook，3 Ins'
        //0 新浪微博，2 Facebook，1 微信公众号，3 Ins'
        //    _socialArr = @[@"sina_icon",@"facebook_icon",@"weixin_icon",@"instagram_icon"];
        
        [_socialTempArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            BOOL isTextViewType=NO;
            NSInteger socialType = 0;
            NSString *socialName = @"";
            NSString *type = @"";
            NSMutableDictionary *tempDict = nil;
            YYBuyerSocialInfoModel *tempValue = nil;
            if([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *value = (NSDictionary *)obj;
                tempDict=[value mutableCopy];
                socialType = [[value objectForKey:@"socialType"] integerValue];
                type = socialType==0?@"sina":socialType==1?@"weixin":socialType==2?@"facebook":socialType==3?@"instagram":@"";
                
                if(socialType==1)
                {
                    if([NSString isNilOrEmpty:[value objectForKey:@"image"]])
                    {
                        //空 uitextview
                        isTextViewType=YES;
                    }else
                    {
                        //非空 uilabel
                        isTextViewType=NO;
                    }
                }else
                {
                    if([NSString isNilOrEmpty:[value objectForKey:@"url"]])
                    {
                        //空 uitextview
                        isTextViewType=YES;
                    }else
                    {
                        //非空 uilabel
                        isTextViewType=NO;
                    }
                }
                
                socialName = [value objectForKey:@"socialName"];
                
            }else if([obj isKindOfClass:[YYBuyerSocialInfoModel class]])
            {
                YYBuyerSocialInfoModel *value = (YYBuyerSocialInfoModel *)obj;
                tempValue=[value copy];
                socialType = [value.socialType integerValue];
                type = socialType==0?@"sina":socialType==1?@"weixin":socialType==2?@"facebook":socialType==3?@"instagram":@"";
                if(socialType==1)
                {
                    if([NSString isNilOrEmpty:value.image])
                    {
                        //空 uitextview
                        isTextViewType=YES;
                    }else
                    {
                        //非空 uilabel
                        isTextViewType=NO;
                    }
                }else
                {
                    if([NSString isNilOrEmpty:value.url])
                    {
                        //空 uitextview
                        isTextViewType=YES;
                    }else
                    {
                        //非空 uilabel
                        isTextViewType=NO;
                    }
                }
                socialName = value.socialName;
            }
            
            if(isTextViewType)
            {
                YYTypeTextView *socialTextView = [YYTypeTextView getCustomTextViewWithStr:@"" WithFont:13.0f WithTextColor:_define_black_color];
                socialTextView.text = socialType==1?[[NSString alloc] initWithFormat:NSLocalizedString(@"%@（公众号）",nil),socialName]:socialName;
                socialTextView.editable=NO;
                socialTextView.type = type;
                socialTextView.value = obj;
                socialTextView.scrollEnabled=NO;
                socialTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                if([obj isKindOfClass:[NSDictionary class]])
                {
                    if(tempDict)
                    {
                        [tempDict setObject:socialTextView forKey:@"view"];
                        [_socialArr addObject:tempDict];
                    }
                }else if([obj isKindOfClass:[YYBuyerSocialInfoModel class]])
                {
                    if(tempValue)
                    {
                        tempValue.view = socialTextView;
                        [_socialArr addObject:tempValue];
                    }
                }
                
            }else
            {
                YYTypeButton *socialButton = [YYTypeButton getCustomTitleBtnWithAlignment:1 WithFont:13.0f WithSpacing:0 WithNormalTitle:nil WithNormalColor:[UIColor colorWithHex:kDefaultBlueColor] WithSelectedTitle:nil WithSelectedColor:nil];
                socialButton.type = type;
                socialButton.value = obj;
                [socialButton addTarget:self action:@selector(socialAction:) forControlEvents:UIControlEventTouchUpInside];
                [socialButton setTitle:socialType==1?[[NSString alloc] initWithFormat:NSLocalizedString(@"%@（公众号）",nil),socialName]:socialName forState:UIControlStateNormal];
                //                NSMutableAttributedString *content = nil;
                //
                //                if(socialType==1)
                //                {
                //                    NSString *titleStr = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@（公众号）",nil),socialName];
                //                    //微信
                //                    content = [[NSMutableAttributedString alloc]initWithString:titleStr];
                //
                //                    NSRange contentRange = {0,[content length]-5};
                //
                //                    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                //
                //                    NSRange allContentRange = {0,[content length]};
                //
                //                    [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kDefaultTitleColor_phone] range:allContentRange];
                //
                //                    [socialButton setAttributedTitle:content forState:UIControlStateNormal];
                //
                //                }else
                //                {
                //                    //非微信
                //                    content = [[NSMutableAttributedString alloc]initWithString:socialName];
                //
                //                    NSRange contentRange = {0,[content length]};
                //
                //                    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                //
                //                    [content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:kDefaultTitleColor_phone] range:contentRange];
                //
                //                    [socialButton setAttributedTitle:content forState:UIControlStateNormal];
                //
                //                }
                if([obj isKindOfClass:[NSDictionary class]])
                {
                    if(tempDict)
                    {
                        [tempDict setObject:socialButton forKey:@"view"];
                        [_socialArr addObject:tempDict];
                    }
                }else if([obj isKindOfClass:[YYBuyerSocialInfoModel class]])
                {
                    if(tempValue)
                    {
                        tempValue.view = socialButton;
                        [_socialArr addObject:tempValue];
                    }
                }
            }
            
            
        }];
    }
}

//移除视图
-(void)PrepareUI
{
    _lastView=nil;
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}
#pragma mark - UIConfig
-(void)UIConfig
{
    [self CreateSubView];
}
-(void)CreateNoDataView
{
    if(!_noIntroductionDataView)
    {
        if(_isHomePage)
        {
            _noIntroductionDataView = (YYNoDataView *)addNoDataView_phone(self.contentView,[NSString stringWithFormat:@"%@|icon:notxt_icon",NSLocalizedString(@"还未添加买手店联系信息，点击右上角编辑",nil)],kDefaultBorderColor,@"noinfo_icon");
        }else
        {
            _noIntroductionDataView = (YYNoDataView *)addNoDataView_phone(self.contentView,[NSString stringWithFormat:@"%@|icon:notxt_icon",NSLocalizedString(@"店家还未添加买手店联系信息",nil)],kDefaultBorderColor,@"noinfo_icon");
        }
        
    }
    [self.contentView addSubview:_noIntroductionDataView];
    [_noIntroductionDataView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.mas_equalTo(100);
    }];
    NSMutableArray *_contactTempArr=[[NSMutableArray alloc] init];
    NSMutableArray *_socialTempArr=[[NSMutableArray alloc] init];
    
    [_homePageModel.userContactInfos enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *value = (NSDictionary *)obj;
            if(![YYBuyerInfoTool isNilOrEmptyWithContactValue:[value objectForKey:@"contactValue"] WithContactType:[value objectForKey:@"contactType"]])
            {
                [_contactTempArr addObject:value];
            }
            
        }else if([obj isKindOfClass:[YYBuyerContactInfoModel class]])
        {
            YYBuyerContactInfoModel *value = (YYBuyerContactInfoModel *)obj;
            if(![YYBuyerInfoTool isNilOrEmptyWithContactValue:value.contactValue WithContactType:value.contactType])
            {
                [_contactTempArr addObject:value];
            }
        }
        
    }];
    
    [_homePageModel.userSocialInfos enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *value = (NSDictionary *)obj;
            if(![NSString isNilOrEmpty:[value objectForKey:@"socialName"]])
            {
                [_socialTempArr addObject:value];
            }
        }else if([obj isKindOfClass:[YYBuyerSocialInfoModel class]])
        {
            YYBuyerSocialInfoModel *value = (YYBuyerSocialInfoModel *)obj;
            if(![NSString isNilOrEmpty:value.socialName])
            {
                [_contactTempArr addObject:value];
            }
        }
    }];
    
    if(!_contactTempArr.count&&!_socialTempArr.count)
    {
        //        _noIntroductionDataView.hidden=NO;
        _noIntroductionDataView.hidden=YES;
    }else
    {
        _noIntroductionDataView.hidden=YES;
    }
}
-(void)CreateSubView
{
    //0 邮箱, 4 固定电话 3 微信号, 1 电话, 2 QQ
    //0 新浪微博，2 Facebook，1 微信公众号，3 Ins'
    //    NSLog(@"%@ %@",_contactArr,_socialArr);
    //    __block UIView *lastView=_lastView;
    __block UIView *lastContactView=nil;
    if(_contactArr.count)
    {
        if(!_contactTitleLabel)
        {
            _contactTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"商务联系方式",nil) WithFont:14.0f WithTextColor:[UIColor colorWithHex:kDefaultTitleColor_phone] WithSpacing:0];
        }
        [self.contentView addSubview:_contactTitleLabel];
        [_contactTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(11);
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
        }];
        //0 邮箱, 4 固定电话 3 微信号, 1 电话, 2 QQ
        [_contactArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIView *backView = [UIView getCustomViewWithColor:nil];
            [self.contentView addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                if(lastContactView)
                {
                    make.top.mas_equalTo(lastContactView.mas_bottom).with.offset(0);
                }else
                {
                    make.top.mas_equalTo(_contactTitleLabel.mas_bottom).with.offset(5);
                }
            }];
            NSInteger contactType = 0;
            id subview = nil;
            if([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *value = (NSDictionary *)obj;
                contactType = [[value objectForKey:@"contactType"] integerValue];
                subview = [value objectForKey:@"view"];
            }else if([obj isKindOfClass:[YYBuyerContactInfoModel class]])
            {
                YYBuyerContactInfoModel *value = (YYBuyerContactInfoModel *)obj;
                contactType = [value.contactType integerValue];
                subview = value.view;
            }
            NSString *type = contactType==0?@"email":contactType==1?@"phone":contactType==2?@"qq":contactType==3?@"weixin":contactType==4?@"telephone":@"";
            UIView *rightView = [self getTextFieldRightView:type];
            [backView addSubview:rightView];
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(18);
                make.top.bottom.mas_equalTo(backView);
                make.width.mas_equalTo(30);
            }];
            
            if([subview isKindOfClass:[YYTypeTextView class]])
            {
                YYTypeTextView *textview = (YYTypeTextView *)subview;
                [backView addSubview:textview];
                [textview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(rightView.mas_right).with.offset(0);
                    make.top.bottom.mas_equalTo(0);
                    make.right.right.mas_equalTo(-18);
                }];
            }else if([subview isKindOfClass:[YYTypeButton class]])
            {
                YYTypeButton *textview = (YYTypeButton *)subview;
                [backView addSubview:textview];
                [textview mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(rightView.mas_right).with.offset(5);
                    make.top.bottom.mas_equalTo(0);
                    make.right.right.mas_equalTo(-18);
                }];
            }
            
            lastContactView=backView;
            _lastView=backView;
        }];
    }
    
    __block UIView *lastSocialView=nil;
    if(_socialArr.count)
    {
        if(!_socialTitleLabel)
        {
            _socialTitleLabel=[UILabel getLabelWithAlignment:0 WithTitle:NSLocalizedString(@"社交账户",nil) WithFont:14.0f WithTextColor:[UIColor colorWithHex:kDefaultTitleColor_phone] WithSpacing:0];
        }
        [self.contentView addSubview:_socialTitleLabel];
        [_socialTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastContactView)
            {
                make.top.mas_equalTo(lastContactView.mas_bottom).with.offset(11);
            }else
            {
                make.top.mas_equalTo(11);
            }
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
        }];
        
        [_socialArr enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIView *backView = [UIView getCustomViewWithColor:nil];
            [self.contentView addSubview:backView];
            [backView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                if(lastSocialView)
                {
                    make.top.mas_equalTo(lastSocialView.mas_bottom).with.offset(0);
                }else
                {
                    make.top.mas_equalTo(_socialTitleLabel.mas_bottom).with.offset(5);
                }
            }];
            
            NSInteger socialType = 0;
            id subview = nil;
            if([obj isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *value = (NSDictionary *)obj;
                socialType = [[value objectForKey:@"socialType"] integerValue];
                subview = [value objectForKey:@"view"];
            }else if([obj isKindOfClass:[YYBuyerSocialInfoModel class]])
            {
                YYBuyerSocialInfoModel *value = (YYBuyerSocialInfoModel *)obj;
                socialType = [value.socialType integerValue];
                subview = value.view;
            }
            NSString *type = socialType==0?@"sina":socialType==1?@"weixin":socialType==2?@"facebook":socialType==3?@"instagram":@"";
            UIView *rightView = [self getTextFieldRightView:type];
            [backView addSubview:rightView];
            [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(18);
                make.top.bottom.mas_equalTo(backView);
                make.width.mas_equalTo(30);
            }];
            
            if(subview)
            {
                if([subview isKindOfClass:[YYTypeTextView class]])
                {
                    YYTypeTextView *textview = (YYTypeTextView *)subview;
                    [backView addSubview:textview];
                    
                    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(rightView.mas_right).with.offset(0);
                        make.right.top.bottom.mas_equalTo(0);
                    }];
                    
                }else if([subview isKindOfClass:[YYTypeButton class]])
                {
                    YYTypeButton *textview = (YYTypeButton *)subview;
                    [backView addSubview:textview];
                    
                    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(rightView.mas_right).with.offset(5);
                        make.right.top.bottom.mas_equalTo(0);
                    }];
                }
            }
            
            lastSocialView=backView;
            _lastView=backView;
        }];
    }
}
#pragma mark - Setter
-(void)setHomePageModel:(YYBuyerHomeInfoModel *)homePageModel
{
    _homePageModel=homePageModel;
    [self setData];
}
-(void)setData
{
    [self SomePrepare];
    [self UIConfig];
    [self CreateNoDataView];
}
#pragma mark - SomeAction
-(NSString *)getValueForObj:(id )obj
{
    if([obj isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *tempObj = (NSDictionary *)obj;
        if([[tempObj objectForKey:@"contactType"] integerValue] == 4)
        {
            //0 邮箱，1 电话，2 QQ，3 微信号'，4 固定电话
            NSString *contactValue = [tempObj objectForKey:@"contactValue"];
            if(![NSString isNilOrEmpty:contactValue])
            {
                NSArray *tempArr = [contactValue componentsSeparatedByString:@" "];
                if(tempArr.count>1)
                {
                    NSArray *phoneTempArr = [tempArr[1] componentsSeparatedByString:@"-"];
                    if(phoneTempArr.count>2)
                    {
                        if([NSString isNilOrEmpty:phoneTempArr[2]])
                        {
                            //为空
                            return [[NSString alloc] initWithFormat:@"%@ %@-%@",tempArr[0],phoneTempArr[0],phoneTempArr[1]];
                        }
                        return contactValue;
                    }
                    return contactValue;
                }
                return contactValue;
            }else
            {
                return @"";
            }
        }
        return [tempObj objectForKey:@"contactValue"];
    }else if([obj isKindOfClass:[YYBuyerContactInfoModel class]])
    {
        YYBuyerContactInfoModel *tempObj = (YYBuyerContactInfoModel *)obj;
        if([tempObj.contactType integerValue] == 4)
        {
            NSString *contactValue = tempObj.contactValue;
            if(![NSString isNilOrEmpty:contactValue])
            {
                NSArray *tempArr = [contactValue componentsSeparatedByString:@" "];
                if(tempArr.count>1)
                {
                    NSArray *phoneTempArr = [tempArr[1] componentsSeparatedByString:@"-"];
                    if(phoneTempArr.count>2)
                    {
                        if([NSString isNilOrEmpty:phoneTempArr[2]])
                        {
                            //为空
                            return [[NSString alloc] initWithFormat:@"%@ %@-%@",tempArr[0],phoneTempArr[0],phoneTempArr[1]];
                        }
                        return contactValue;
                    }
                    return contactValue;
                }
                return contactValue;
            }else
            {
                return @"";
            }
        }
        return tempObj.contactValue;
    }
    return @"";
}
-(void)socialAction:(YYTypeButton *)btn
{
    if(_cellblock){
        _cellblock(@"social",btn);
    }
}
-(void)contactAction:(YYTypeButton *)btn
{
    if(_cellblock){
        _cellblock(@"contact",btn);
    }
}
+(CGFloat )getHeightWithHomeInfoModel:(YYBuyerHomeInfoModel *)homePageModel IsHomePage:(BOOL )isHomePage
{
    YYBuyerInfoContactCell *contactCell = [[YYBuyerInfoContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"getheight" WithBlock:nil];
    contactCell.isHomePage = isHomePage;
    contactCell.homePageModel = homePageModel;
    [contactCell layoutIfNeeded];
    if(contactCell.lastView)
    {
        CGRect frame =  contactCell.lastView.frame;
        return frame.origin.y + frame.size.height + 14;
    }else
    {
        return 0;
    }
}
-(UIView *)getTextFieldRightView:(NSString *)type
{
    NSString *imageStr = [type isEqualToString:@"email"]?@"email_icon2":[type isEqualToString:@"phone"]?@"mobile_icon":[type isEqualToString:@"qq"]?@"qq_icon1":[type isEqualToString:@"weixin"]?@"weixin_icon1":[type isEqualToString:@"telephone"]?@"phone_icon1":[type isEqualToString:@"sina"]?@"sina_icon":[type isEqualToString:@"facebook"]?@"facebook_icon":[type isEqualToString:@"instagram"]?@"instagram_icon":@"";
    
    UIView *rightView = [UIView getCustomViewWithColor:_define_white_color];
    
    UIImageView *imageview = [[UIImageView alloc] init];
    [rightView addSubview:imageview];
    imageview.contentMode=UIViewContentModeCenter;
    if(![NSString isNilOrEmpty:imageStr])
    {
        imageview.image=[UIImage imageNamed:imageStr];
    }
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(rightView);
        make.width.height.mas_equalTo(20);
    }];
    return rightView;
}

#pragma mark - Other
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
