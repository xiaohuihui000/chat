//
//  AudioPlayer.m
//  chat
//
//  Created by chenguanghui on 17/1/11.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer ()<AVAudioPlayerDelegate>

@property(nonatomic , strong) AVAudioPlayer *avPlayer;

@end

@implementation AudioPlayer

+ (instancetype)shareInstance{
    static AudioPlayer *mPlayer = nil;
    if (!mPlayer) {
        mPlayer = [[AudioPlayer alloc] init];
    }
 
    return mPlayer;
}

- (void)setupPlayer:(NSString *)path{
    [self setup];
    
    BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:path];
    NSLog(@"文件是否存在%d",success);
    
    self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
    self.avPlayer.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActiveNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)player{
    [_avPlayer play];
}
- (void)stopPlayer{
    [_avPlayer stop];
}

- (BOOL)isPlaying{
    return [_avPlayer isPlaying];
}

- (void)setup{
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    NSError* err = nil;
    [audioSession setCategory: AVAudioSessionCategoryPlayback error: &err];
    
    if(err){
        NSLog(@"audioSession: %@ %ld %@",
              [err domain], [err code], [[err userInfo] description]);
        return;
    }
    err = nil;
    [audioSession setActive:YES error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@",
              [err domain], [err code], [[err userInfo] description]);
        return;
    }
}
- (void)resignActiveNotification{
    [_avPlayer stop];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
