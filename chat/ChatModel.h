//
//  ChatModel.h
//  chat
//
//  Created by chenguanghui on 17/1/6.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSInteger, ChatCellType) {
    /// 时间
    ChatCellType_time = 0,
    /// 文本
    ChatCellType_Text = 1,
    /// 图片
    ChatCellType_Image = 2,
    /// 语音
    ChatCellType_Audio = 3,
    /// 视频
    ChatCellType_Video = 4,
    /// 表情
    ChatCellType_Face = 5
};

@interface ChatModel : NSObject

/// 发消息的类型
@property(nonatomic , assign) ChatCellType messageType;

/// 发消息的人头像
@property(nonatomic , copy) NSString *headImageUrl;

/// 发消息的时间
@property(nonatomic , copy) NSString *time;

/// 发消息的人名
@property(nonatomic , copy) NSString *userName;

///是否是自己发的消息
@property(nonatomic , assign) BOOL isSender;




/// 文本cell下

/// 消息内容
@property(nonatomic , copy) NSString *content;


/// 图片cell下

///图片url 视频缩略图url
@property(nonatomic , copy) NSString *url;
/// 图片高度 视频高度
@property(nonatomic , assign) CGFloat height;

/// 图片宽度 视频宽度
@property(nonatomic , assign) CGFloat width;


/// 声音cell下


///时长
@property(nonatomic , assign) NSTimeInterval timeLenth;

/// 网络url
@property(nonatomic , copy) NSString *assetUrl;
/// 视频路径
@property(nonatomic , copy) NSString *assetPath;




@end
