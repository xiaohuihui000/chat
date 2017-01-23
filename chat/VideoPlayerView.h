//
//  VideoPlayerView.h
//  chat
//
//  Created by chenguanghui on 17/1/11.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayerView : UIView


@property(nonatomic , strong) UIImageView *thumbImageView;

/// 视频时长
@property(nonatomic , assign) NSTimeInterval videoInterval;
/// 视频路径
@property(nonatomic , strong) NSURL *videoUrl;

/// 封面URL
@property(nonatomic , copy) NSString *thumbImageUrl;

- (void)playVideo;




@end
