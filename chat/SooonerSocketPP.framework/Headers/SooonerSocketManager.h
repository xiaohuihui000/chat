//
//  SooonerSocketManager.h
//  SooonerSocketPPDemo
//
//  Created by 吴贤德 on 2016/12/24.
//  Copyright © 2016年 Soooner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CallBack) (NSArray* data);
typedef void (^ACKCallBack) (NSArray* data);

@interface SooonerSocketManager : NSObject

@property (nonatomic,copy) NSDictionary *registInfo;  //用户注册信息
@property (nonatomic,copy) NSString *currentRoomid;   //用户当前所处的房间号

@property (nonatomic,assign) NSTimeInterval ackTimeoutSeconds; //ack回调超时时间（默认7秒）如：7.0f

+(SooonerSocketManager *)shareInstance;

/**
 *  @brief  断开连接（暂时弃用）
 **/
-(void)disconnect;

/**
 *  @brief  连接状态    yes：已连接 no：未连接
 **/
-(bool)isConnected;

/**
 *  @brief  连接实时通讯服务（通知方式接收回调请调用该方法）
 *      1.消息接收以通知中心通知方式回调（通知名称使用SooonerSocketConstantObject）
 *      2.消息返回格式与Block方式一致
 *  @param  url :   实时通讯服务
 **/
-(void)connect:(NSString *)url;


/**
 *  @brief  创建连接并注册用户信息
 *      注：重连间隔3秒
 *  @param  url :   连接url
 *  @param  connectedCallback   :   连接成功回调（告知用户连接成功,需进行注册，接收到该回调如果用户正在聊天室需调用joinRoom方法重新加入聊天室）
 *  @param  reconnectCallback   :   自动重连中回调（用于提示用户连接断开正在自动重连）
 *  @param  connectErrorCallback   :   连接错误回调
 *  @param  joinCallback  //接收进入房间通知json:{user:{id,name}}
 *  @param  leaveCallback    //接收离开房间通知json:{user:{id,name}}
 *  @param  roomMessageCallback    //接收房间消息json:{user:{id,name},msg:{t,c}}
 *  @param  privateMessageCallback  //接收私聊消息json:{user:{id,name},msg:{t,c}}
 *  @param  offlineMessageCallback  //接收离线消息json:[{user:{id,name},msg:{t,c}},,,]
 *  @param  systemMessageCallback    //接收系统消息json:{code,desc}
 **/
//-(void)connect:(NSString *)url
//   onConnected:(CallBack) connectedCallback
//onReconnecting:(CallBack) reconnectCallback
//onConnectError:(CallBack) connectErrorCallback
//        onJoin:(CallBack) joinCallback
//       onLeave:(CallBack) leaveCallback
// onRoomMessage:(CallBack) roomMessageCallback
//onPrivateMessage:(CallBack) privateMessageCallback
//onOfflineMessage:(CallBack) offlineMessageCallback
//onSystemMessage:(CallBack) systemMessageCallback
//;
#pragma mark -- 注册连接
/**
 *  @brief  连接注册
 *      注：该方法一般不需要单独调用，connect时连接成功会自动调用，公开该方法仅用于当自动调用失败时手动触发
 *  @param  registInfo  :   json:{sp:"soooner",user:{}}
 *  @param  ackCallback 消息确认回调
 *  @return bool :  返回值仅表示当前连接是否存在（不存在直接return no，不执行发送逻辑），消息发送状态请在ack回调方法中处理
 **/
-(bool)regist:(NSDictionary *)registInfo withACK:(ACKCallBack) ackCallback;

#pragma mark -- 客户端操作方法（进房间、离开房间、发送消息）
/**
 *  @brief  加入房间
 *  @param  roomid  :   房间id
 *  @param  ackCallback 消息确认回调
 *  @return bool :  返回值仅表示当前连接是否存在（不存在直接return no，不执行发送逻辑），消息发送状态请在ack回调方法中处理
 **/
-(bool)joinRoom:(NSString *) roomid withACK:(ACKCallBack) ackCallback;

/**
 *  @brief  离开房间
 *  @param  roomid  :   房间id
 *  @param  ackCallback 消息确认回调
 *  @return bool :  返回值仅表示当前连接是否存在（不存在直接return no，不执行发送逻辑），消息发送状态请在ack回调方法中处理
 **/
-(bool)leaveRoom:(NSString *) roomid withACK:(ACKCallBack) ackCallback;

/**
 *   @brief  发送房间公聊消息
 *   @param  message :   json: {"t":"wz","c":"消息内容"}
 *      t:消息类型 wz-文字，tp-图片，yy-语音，gb-广播（文字）
 *      c:消息内容（文件类型此字段可以传url）
 *   @param  ackCallback 消息确认回调
 *  @return bool :  返回值仅表示当前连接是否存在（不存在直接return no，不执行发送逻辑），消息发送状态请在ack回调方法中处理
 **/
-(bool)sendRoomMessage:(NSDictionary *)message withACK:(ACKCallBack) ackCallback;

#pragma mark -- 私聊方法（发送私聊消息、监听私聊消息）

/**
 *   @brief  发送私聊消息
 *   @param  message :   json: {user:{},msg:{"t":"消息类型","c":"消息内容"}}
 *      user:接收方用户信息
 *      msg:消息体
 *          t:消息类型 wz-文字，tp-图片，yy-语音
 *          c:消息内容
 *   @param  ackCallback 消息确认回调
 *  @return bool :  返回值仅表示当前连接是否存在（不存在直接return no，不执行发送逻辑），消息发送状态请在ack回调方法中处理
 **/
-(bool)sendPrivateMessage:(NSDictionary *)message withACK:(ACKCallBack) ackCallback;

#pragma mark -- 管理员操作方法:禁言 等（暂时只想到禁言的实现）
typedef NS_ENUM(NSInteger, SocketOperatingType) {
    SocketOperatingTypeOfJY          =0,//禁言 {user:{},room:""}
};

/**
 *  @brief  发送管理员操作，如：禁言等...(后端逻辑会进行信息加签)
 *  @param  opType  操作类型，暂时只有禁言
 *  @param  mdic    操作对象，如禁言：json：{user:{},room:""}
 *  @param  ackCallback 消息确认回调
 *  @return bool :  返回值仅表示当前连接是否存在（不存在直接return no，不执行发送逻辑），消息发送状态请在ack回调方法中处理
 **/
-(bool) sendAdminOperator:(SocketOperatingType)opType withDic:(NSMutableDictionary *) mdic withACK:(ACKCallBack) ackCallback;




@end
