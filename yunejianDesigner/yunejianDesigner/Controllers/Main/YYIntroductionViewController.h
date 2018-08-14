//
//  YYIntroductionViewController.h
//  Yunejian
//
//  Created by Apple on 15/10/15.
//  Copyright © 2015年 yyj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectedEnter)();
@interface YYIntroductionViewController : UIViewController<UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *pagingScrollView;
@property (nonatomic, strong) UIButton *enterButton;

@property (nonatomic, copy) DidSelectedEnter didSelectedEnter;

/**
 @[@"image1", @"image2"]
 */
@property (nonatomic, strong) NSArray *backgroundImageNames;

/**
 @[@"coverImage1", @"coverImage2"]
 */
@property (nonatomic, strong) NSArray *coverImageNames;


- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames;


- (id)initWithCoverImageNames:(NSArray*)coverNames backgroundImageNames:(NSArray*)bgNames button:(UIButton*)button;


@end
