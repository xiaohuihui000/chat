//
//  SooonerSocket.h
//  SooonerSocketPPDemo
//  代理方式监听消息
//  Created by 吴贤德 on 2017/1/16.
//  Copyright © 2017年 Soooner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SooonerSocketEventType)
{
    SooonerSocketEventTypeOfUnknow          = 1,        //未知事件
    SooonerSocketEventTypeOfConnected       = 2,        //连接成功
    SooonerSocketEventTypeOfReconnect       = 3,        //重连中
    SooonerSocketEventTypeOfConnectError    = 4,        //连接错误
    SooonerSocketEventTypeOfRoomMessage     = 5,        //直播间消息
    SooonerSocketEventTypeOfJoinMessage     = 6,        //用户加入房间消息
    SooonerSocketEventTypeOfLeaveMessage    = 7,        //用户离开房间消息
    SooonerSocketEventTypeOfPrivateMesaage  = 8,        //私聊消息
    SooonerSocketEventTypeOfSystemMessage   = 9,        //系统消息
    SooonerSocketEventTypeOfOfflineMessage  =10,        //离线消息
};

@protocol SooonerSocketDelegate <NSObject>

@optional
/**
 *  @brief  消息事件监听代理
 *  @param  eventType   :   事件类型
 *  @param  data        :   数组对象（一般取数组第一个对象进行json解析即可，注意数组是否为空情况）
 **/
-(void) sooonerSocket:(SooonerSocketEventType) eventType withData:(NSArray *)data;

@end

/************  使用注意事项  ***************
 *  1.SooonerSocketListener对象定义的作用域，否则影响消息监听
 *  2.初始化调用：initWithDelegate
 *  3.注意对象销毁（sooonerSocketListener=nil）,否则影响父容器的内存释放等问题
 ****************************************/
@interface SooonerSocketListener : NSObject

-(id) initWithDelegate:(id<SooonerSocketDelegate>) delegate;

@end
