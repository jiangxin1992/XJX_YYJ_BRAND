//
//  ChatCell.h
//  AutoLayoutCellDemo
//
//  Created by siping ruan on 16/10/9.
//  Copyright © 2016年 Rasping. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYMessageChatModel;
@class YYMessageChatCell;

@protocol YYMessageChatCellDelegate<NSObject>
-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas;
@optional
/**
 图片加载完毕需要刷新UI
 */
- (void)YYMessageChatCellDelegate:(YYMessageChatCell *)cell;

- (void)YYMessageChatCellDelegateShowBigImage:(YYMessageChatCell *)cell;

- (void)YYMessageChatCellDelegateUploadAgain:(YYMessageChatCell *)cell;

- (void)YYMessageChatCellDelegateTapUrl:(YYMessageChatCell *)cell URL:(NSString *)url;

@end

/**
 *  聊天列表cell类型
 */
typedef NS_ENUM(NSInteger, ChatCellType) {
    /**
     *  别人发的
     */
    ChatCellTypeOther,
    /**
     *  自己发的
     */
    ChatCellTypeSelf
};

@interface YYMessageChatCell : UITableViewCell

@property (strong, nonatomic) YYMessageChatModel *model;

@property (weak,nonatomic) id<YYMessageChatCellDelegate> delegate;
/** indexpath */
@property (nonatomic, strong) NSIndexPath *indexPath;
/** 进度条 */
@property (nonatomic, assign) CGFloat progress;
/** 是否隐藏百分比 */
@property (nonatomic, assign) BOOL isHiddenProgress;

+ (instancetype)cellWithTableView:(UITableView *)tableView chatCellType:(ChatCellType)type;

/** showError */
@property (nonatomic, assign) BOOL isShowError;

@end

@interface ChatCellSelf : YYMessageChatCell

@end
