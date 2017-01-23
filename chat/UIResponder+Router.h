//
//  UIResponder+Router.h
//  chat
//
//  Created by chenguanghui on 17/1/6.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSInteger, EventChatCellType) {
    /// 删除事件
    EventChatCellRemoveEvent,
    
    /// 图片点击事件
    EventChatCellImageTapedEvent,
    
    /// 头像点击事件
    EventChatCellHeadTapedEvent,
    
    /// 输入框点击发消息事件
    EventChatCellTypeSendMsgEvent,
    
    /// 输入界面，更多界面，选择图片
    EventChatMoreViewPickerImage
};

@interface UIResponder (Router)

- (void)routerEventWithType:(EventChatCellType)eventType userInfo:(NSDictionary *)userInfo;


@end
