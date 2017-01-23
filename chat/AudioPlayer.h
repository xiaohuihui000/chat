//
//  AudioPlayer.h
//  chat
//
//  Created by chenguanghui on 17/1/11.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayer : NSObject


+ (instancetype)shareInstance;

- (void)setupPlayer:(NSString *)path;

- (void)player;
- (void)stopPlayer;

- (BOOL)isPlaying;



@end
