//
//  YYMenuPopView.m
//  YunejianBuyer
//
//  Created by Apple on 16/1/8.
//  Copyright © 2016年 Apple. All rights reserved.
//


#import "YYMenuPopView.h"

#import "YYConnApi.h"
#import "YYConnBuyerListModel.h"

@interface  YYMenuPopView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,copy) NSArray *selectData;
@property (nonatomic,copy) void(^action)(NSInteger index);
@property (nonatomic,copy) NSArray * imagesData;
@property (nonatomic,copy) NSDictionary * displayData;

@property (nonatomic,assign) NSTextAlignment textAlignment;

@end



YYMenuPopView * backgroundView;
UITableView * tableView;
UIImageView *menuArrow;

@implementation YYMenuPopView


- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       images:(NSArray *)images
                                textAlignment:(NSTextAlignment)textAlignment
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate arrowImage:(BOOL)need arrowPositionInfo:(NSArray*)arrowPositionInfo
{
    if (backgroundView != nil) {
        [YYMenuPopView hiden:YES];
    }
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    
    backgroundView = [[YYMenuPopView alloc] initWithFrame:win.bounds];
    backgroundView.textAlignment = textAlignment;
    backgroundView.action = action;
    backgroundView.imagesData = images ;
    backgroundView.selectData = selectData;
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.1];
    [win addSubview:backgroundView];
    // TAB
    NSInteger rowHeight = CGRectGetHeight(frame)/[selectData count];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x , frame.origin.y -rowHeight * selectData.count/2 , frame.size.width, rowHeight * selectData.count) style:0];
    tableView.dataSource = backgroundView;
    tableView.delegate = backgroundView;
    tableView.layer.cornerRadius = 4.0f;
    tableView.separatorColor = [UIColor blackColor];
    
    // 定点
    tableView.layer.anchorPoint = CGPointMake(0.5, 0);
    //tableView.transform =CGAffineTransformMakeScale(1.0, 0.0001);
    tableView.layer.borderColor =[UIColor blackColor].CGColor;
    tableView.layer.borderWidth = 4;
    tableView.layer.masksToBounds = YES;
    //tableView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    
    tableView.rowHeight = rowHeight;
    [win addSubview:tableView];
    
    if(need){
        CGFloat locationX = CGRectGetMaxX(tableView.frame);
        CGFloat locationY = CGRectGetMinY(tableView.frame);
        CGFloat menuArrowLeft = 18;
        if(arrowPositionInfo){
            menuArrowLeft = [[arrowPositionInfo objectAtIndex:0] integerValue];
        }
        menuArrow = [[UIImageView alloc] initWithFrame:CGRectMake(locationX-menuArrowLeft+8 -16, locationY -7, 16, 16)];
        menuArrow.image = [UIImage imageNamed:@"menuarrow_img"];//;[backgroundView getArrowImage:CGSizeMake(2*LeftView, TopToView)];
        [win addSubview:menuArrow];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick:)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    // tableView.layer.anchorPoint = CGPointMake(100, 64);
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        //        tableView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 70, frame.size.width, 40 * selectData.count);
        //tableView.alpha = 0.5;
        //menuArrow.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 0.5;
            // tableView.alpha = 1;
            // menuArrow.alpha = 1;
            //tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        }];
    }
}

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       images:(NSArray *)images
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate arrowImage:(BOOL)need arrowPositionInfo:(NSArray*)arrowPositionInfo
{
    if (backgroundView != nil) {
        [YYMenuPopView hiden:YES];
    }
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    
    backgroundView = [[YYMenuPopView alloc] initWithFrame:win.bounds];
    backgroundView.textAlignment = NSTextAlignmentCenter;
    backgroundView.action = action;
    backgroundView.imagesData = images ;
    backgroundView.selectData = selectData;
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.1];
    [win addSubview:backgroundView];
    
    // TAB
    NSInteger rowHeight = CGRectGetHeight(frame)/[selectData count];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x , frame.origin.y -rowHeight * selectData.count/2 , frame.size.width, rowHeight * selectData.count) style:0];
    tableView.dataSource = backgroundView;
    tableView.delegate = backgroundView;
    tableView.layer.cornerRadius = 4.0f;
    tableView.separatorColor = [UIColor blackColor];
    
    // 定点
    tableView.layer.anchorPoint = CGPointMake(0.5, 0);
    //tableView.transform =CGAffineTransformMakeScale(1.0, 0.0001);
    tableView.layer.borderColor =[UIColor blackColor].CGColor;
    tableView.layer.borderWidth = 4;
    tableView.layer.masksToBounds = YES;
    //tableView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    
    tableView.rowHeight = rowHeight;
    [win addSubview:tableView];
    
    if(need){
        CGFloat locationX = CGRectGetMaxX(tableView.frame);
        CGFloat locationY = CGRectGetMinY(tableView.frame);
        CGFloat menuArrowLeft = 18;
        if(arrowPositionInfo){
            menuArrowLeft = [[arrowPositionInfo objectAtIndex:0] integerValue];
        }
        menuArrow = [[UIImageView alloc] initWithFrame:CGRectMake(locationX-menuArrowLeft+8 -16, locationY -7, 16, 16)];
        menuArrow.image = [UIImage imageNamed:@"menuarrow_img"];//;[backgroundView getArrowImage:CGSizeMake(2*LeftView, TopToView)];
        [win addSubview:menuArrow];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick:)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    // tableView.layer.anchorPoint = CGPointMake(100, 64);
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        //        tableView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 70, frame.size.width, 40 * selectData.count);
        //tableView.alpha = 0.5;
        //menuArrow.alpha = 1;
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 0.5;
           // tableView.alpha = 1;
           // menuArrow.alpha = 1;
            //tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        }];
    }
}

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                       images:(NSArray *)images
                                  displayData:(NSDictionary *)displayData
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate parentView:(UIView*)view{

    if (backgroundView != nil) {
        [YYMenuPopView hiden:YES];
    }
    UIView *win = view;
 
    
    backgroundView = [[YYMenuPopView alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    backgroundView.imagesData = images ;
    backgroundView.selectData = selectData;
    backgroundView.displayData = displayData;
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:0.6];
    backgroundView.layer.cornerRadius = win.layer.cornerRadius;
    [win addSubview:backgroundView];
    
    // TAB
    NSInteger rowHeight = CGRectGetHeight(frame)/[selectData count];
    tableView = [[UITableView alloc] initWithFrame:frame style:0];//CGRectMake(frame.origin.x , frame.origin.y -rowHeight * selectData.count/2 , frame.size.width, rowHeight * selectData.count)
    tableView.dataSource = backgroundView;
    tableView.delegate = backgroundView;
    tableView.layer.cornerRadius = 5.0f;
    tableView.separatorColor = [UIColor colorWithHex:@"efefef"];
    
    // 定点
    //tableView.layer.anchorPoint = CGPointMake(0.5, 0);
    //tableView.transform =CGAffineTransformMakeScale(1.0, 0.0001);
    tableView.layer.borderColor =[UIColor clearColor].CGColor;
    tableView.layer.borderWidth = 4;
    tableView.layer.masksToBounds = YES;
    
    tableView.rowHeight = rowHeight;
    [win addSubview:tableView];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick:)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    // tableView.layer.anchorPoint = CGPointMake(100, 64);
    
    if (animate == YES) {
        backgroundView.alpha = 0.5;
        tableView.frame = CGRectMake(CGRectGetMinX(frame),CGRectGetMinY(frame)+CGRectGetHeight(frame),CGRectGetWidth(frame),CGRectGetHeight(frame));
        //tableView.alpha = 0.5;
        //menuArrow.alpha = 1;
        __block UITableView *blockTableView = tableView;
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 0.5;
            blockTableView.frame = frame;
            // tableView.alpha = 1;
            // menuArrow.alpha = 1;
            //tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        }];
    }
    
    
}

+ (void)tapBackgroundClick:(UITapGestureRecognizer *)sender
{
    if([sender.view isKindOfClass:[YYMenuPopView class]]){
        YYMenuPopView *backgroundView = (YYMenuPopView *)sender.view;
        if(backgroundView && backgroundView.action){
            backgroundView.action(-1);
        }
    }
    [YYMenuPopView hiden:NO];
}
+ (void)hiden:(BOOL)force;
{
    if (backgroundView != nil) {
        if(force){
            [backgroundView removeFromSuperview];
            [tableView removeFromSuperview];
            [menuArrow removeFromSuperview];
            tableView = nil;
            backgroundView = nil;
            menuArrow = nil;
        }else{
        [UIView animateWithDuration:0.3 animations:^{
            //            UIWindow * win = [[[UIApplication sharedApplication] windows] firstObject];
            //            tableView.frame = CGRectMake(win.bounds.size.width - 35 , 64, 0, 0);
            //tableView.transform = CGAffineTransformMakeScale(1.0, 0.0001);
            //tableView.alpha = 0.5;
            //menuArrow.alpha = 1;
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            [tableView removeFromSuperview];
            [menuArrow removeFromSuperview];
            tableView = nil;
            backgroundView = nil;
            menuArrow = nil;
        }];
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"PellTableViewSelectIdentifier";
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:Identifier];
    }
    cell.imageView.image = (self.imagesData?[UIImage imageNamed:self.imagesData[indexPath.row]]:nil);
    cell.textLabel.text = _selectData[indexPath.row];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    if(_displayData && [_displayData objectForKey:@"fontSize"]){
        if([LanguageManager isEnglishLanguage]){
            cell.textLabel.font = [UIFont systemFontOfSize:[[_displayData objectForKey:@"fontSize"] integerValue]-2];
        }else{
            cell.textLabel.font = [UIFont systemFontOfSize:[[_displayData objectForKey:@"fontSize"] integerValue]];
        }
    }else{
        
        if([LanguageManager isEnglishLanguage]){
            cell.textLabel.font = [UIFont systemFontOfSize:12];
        }else{
            cell.textLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    if(_displayData && [_displayData objectForKey:@"textAlignment"]){
        cell.textLabel.textAlignment = (NSTextAlignment)[UIFont systemFontOfSize:[[_displayData objectForKey:@"textAlignment"] integerValue]];
    }else{
        cell.textLabel.textAlignment = _textAlignment;
    }
    return cell;
}

//设置cell的分割线居左
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger linespace = 0;
    if(_displayData && [_displayData objectForKey:@"separatorInset"]){
        linespace =  [[_displayData objectForKey:@"separatorInset"] integerValue];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(-5,linespace,1,linespace)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(-5,linespace,1,linespace)];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(-5,linespace,1,linespace)];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(-5,linespace,1,linespace)];
    }
    //check selectenable
    if(_displayData && [_displayData objectForKey:@"checkSelectEnable"]){
        NSArray *info = [_displayData objectForKey:@"checkSelectEnable"];
        NSInteger row = [[info objectAtIndex:1] integerValue];
        NSString *type = [info objectAtIndex:0];
        if(row == indexPath.row && [type isEqualToString:@"connBuyers"]){
            __block UITableViewCell *blockcell = cell;
            cell.userInteractionEnabled = NO;
            //cell.alpha = 0.5;
            cell.textLabel.textColor = [UIColor colorWithHex:@"919191"];
            
            [YYConnApi getConnBuyers:1 pageIndex:1 pageSize:1 andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYConnBuyerListModel *listModel, NSError *error) {
                if(rspStatusAndMessage.status == YYReqStatusCode100){
                    if(listModel && [listModel.result count] > 0){
                        blockcell.userInteractionEnabled = YES;
                        //blockcell.alpha = 1;
                        cell.textLabel.textColor = [UIColor colorWithHex:@"000000"];
                    }
                }
            }];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.action) {
        self.action(indexPath.row);
    }
    [YYMenuPopView hiden:NO];
}

#pragma mark 绘制三角形
//- (void)drawRect:(CGRect)rect
//
//{
//    //return;
//    
//    //    [colors[serie] setFill];
//    // 设置背景色
//    [[UIColor whiteColor] setFill];
//    //拿到当前视图准备好的画板
//    
//    CGContextRef  context = UIGraphicsGetCurrentContext();
//    
//    //利用path进行绘制三角形
//    
//    CGContextBeginPath(context);//标记
//    CGFloat locationX = CGRectGetMaxX(tableView.frame);
//    CGFloat locationY = CGRectGetMinY(tableView.frame);
//    CGContextMoveToPoint(context,
//                         locationX -  LeftView , locationY);//设置起点
//    
//    CGContextAddLineToPoint(context,
//                            locationX - 2*LeftView  ,  locationY-TopToView);
//    
//    CGContextAddLineToPoint(context,
//                            locationX - TopToView * 3 , locationY);
//    
//    CGContextClosePath(context);//路径结束标志，不写默认封闭
//    
//    [[UIColor blackColor] setFill];  //设置填充色
//    
//    [[UIColor blackColor] setStroke]; //设置边框颜色
//    
//    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径path
//    
//    //[self setNeedsDisplay];
//}

- (UIImage *)getArrowImage:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

    // 绘制改变大小的图片
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context,size.width , size.height);//设置起点
    
    CGContextAddLineToPoint(context,size.width/2,  0);
    
    CGContextAddLineToPoint(context, 0,  size.height);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor blackColor] setFill];  //设置填充色
    
    [[UIColor blackColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context, kCGPathFillStroke);//绘制路径pa
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

@end

