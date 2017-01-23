//
//  SooonerSocketConstantObject.h
//  SooonerSocketPPDemo
//  消息通知 常量定义
//  Created by 吴贤德 on 2016/12/26.
//  Copyright © 2016年 Soooner. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Notifications

#ifdef __cplusplus
#define SOOONER_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define SOOONER_EXTERN extern __attribute__((visibility ("default")))
#endif

//kRealReachabilityChangedNotification 监听网络状态变化（可用于APP网络变化监听，使用方式与Reachablility差不多）
SOOONER_EXTERN NSString *const kSooonerSocketManagerConnectedCallbackNotifiCation;//连接成功通知
SOOONER_EXTERN NSString *const kSooonerSocketManagerReconnectCallbackNotifiCation;//自动重连中通知
SOOONER_EXTERN NSString *const kSooonerSocketManagerConnectErrorCallbackNotifiCation;//连接错误通知(暂时没用)
SOOONER_EXTERN NSString *const kSooonerSocketManagerJoinCallbackNotifiCation;//接收进入房间通知
SOOONER_EXTERN NSString *const kSooonerSocketManagerLeaveCallbackNotifiCation;//接收离开房间通知
SOOONER_EXTERN NSString *const kSooonerSocketManagerRoomMessageCallbackNotifiCation;//接收房间消息通知
SOOONER_EXTERN NSString *const kSooonerSocketManagerPrivateMessageCallbackNotifiCation;//接收私聊消息通知
SOOONER_EXTERN NSString *const kSooonerSocketManagerOfflineMessageCallbackNotifiCation;//接收离线消息通知
SOOONER_EXTERN NSString *const kSooonerSocketManagerSystemMessageCallbackNotifiCation;//接收系统消息通知

@interface SooonerSocketConstantObject : NSObject

@end
