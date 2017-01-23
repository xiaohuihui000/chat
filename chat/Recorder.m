
//
//  Recorder.m
//  audio
//
//  Created by chenguanghui on 17/1/10.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "Recorder.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface Recorder ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@property(nonatomic , strong) NSMutableDictionary *recorderSetting;

@property(nonatomic , strong) AVAudioRecorder *recorder;

@property(nonatomic , copy) NSString *path;


@property(nonatomic , strong) NSDate *startTime;
@property(nonatomic , strong) NSDate *endTime;

@end

@implementation Recorder


- (instancetype)init{
    if (self = [super init]) {
        [self requestAccessForAudio];
        [self setupSetting];
        [self setupRecorder];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActiveNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
    return self;
}


- (void)startRecorder{
    NSLog(@"开始录制");

    _startTime = [NSDate date];
    
    /// 设置为录音状态
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    NSError* err = nil;
    [audioSession setCategory: AVAudioSessionCategoryRecord error: &err];
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
    
    
    [_recorder record];
}
- (void)endRecorder{
    NSLog(@"结束录制");
    
    [_recorder stop];
}




- (void)requestAccessForAudio {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                            }];
            break;
        }
        case AVAuthorizationStatusAuthorized: {
            NSLog(@"启动了麦");

            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}



- (void)setupRecorder{

    _path = [NSString stringWithFormat:@"%@/Documents/recorder.caf",NSHomeDirectory()];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_path]) {
        [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
    }

    /// 设置为录音状态
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    NSError* err = nil;
    [audioSession setCategory: AVAudioSessionCategoryRecord error: &err];
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
    
    NSError *error;
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:_path] settings:_recorderSetting error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
    }
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
}

- (void)setupSetting{
    _recorderSetting = [[NSMutableDictionary alloc] init];
    
    [_recorderSetting setValue:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [_recorderSetting setValue:@44100.0 forKey:AVSampleRateKey];
    [_recorderSetting setValue:@1 forKey:AVNumberOfChannelsKey];
    [_recorderSetting setValue:@16 forKey:AVLinearPCMBitDepthKey];
    [_recorderSetting setValue:@(NO) forKey:AVLinearPCMIsBigEndianKey];
    [_recorderSetting setValue:@(NO) forKey:AVLinearPCMIsFloatKey];
    [_recorderSetting setValue:@(AVAudioQualityHigh) forKey:AVEncoderAudioQualityKey];
    
}
#pragma mark - 通知
- (void)resignActiveNotification{
    if ([_recorder isRecording]) {
        [self endRecorder];
    }
}

#pragma mark - 录制代理
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
    _endTime = [NSDate date];
    NSTimeInterval atimer = [_endTime timeIntervalSinceDate:_startTime];
    [_delegate audioRecorderDidFinishSuccessfully:flag timeInterval:atimer string:_path];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"recorder dealloc");
}
@end























































