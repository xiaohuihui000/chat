//
//  UIResponder+Router.m
//  chat
//
//  Created by chenguanghui on 17/1/6.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "UIResponder+Router.h"





@implementation UIResponder (Router)


/// 发消息
- (void)routerEventWithType:(EventChatCellType)eventType userInfo:(NSDictionary *)userInfo{
    [[self nextResponder] routerEventWithType:eventType userInfo:userInfo];
}

@end
