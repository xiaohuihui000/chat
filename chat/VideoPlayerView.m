//
//  VideoPlayerView.m
//  chat
//
//  Created by chenguanghui on 17/1/11.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "VideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayerView ()

@property(nonatomic , assign) CGRect originFrame;

@property(nonatomic , strong) UIButton *backButton;

@property(nonatomic , strong)AVPlayer *player;

@property(nonatomic , strong)AVPlayerItem *playerItem;

@property(nonatomic , strong)AVPlayerLayer *playerLayer;

@property(nonatomic , assign) id playTimeObserver;

@end

@implementation VideoPlayerView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.thumbImageView];
      
    }
    return self;
}

- (void)playVideo{
    
    /// UI 改变
    _originFrame = self.frame;
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.frame = [UIScreen mainScreen].bounds;
        self.thumbImageView.frame = [UIScreen mainScreen].bounds;
        
    } completion:^(BOOL finished) {

        [self createPlayer];
    }];
    /// 播放视频
    
    
}



- (void)createPlayer{
    
    _player = [[AVPlayer alloc] init];
    _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = [UIScreen mainScreen].bounds;
    [self.layer addSublayer:_playerLayer];
    
    
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:_videoUrl];
    if (!asset) {
        return;
    }
    
    _playerItem = [AVPlayerItem playerItemWithAsset:asset];
     [_player replaceCurrentItemWithPlayerItem:_playerItem];
    
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听缓冲进度
     [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    
    
    _playTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float currentTime = _playerItem.currentTime.value / _playerItem.currentTime.timescale;
        /// 改变滑块位置
    }];
    
    [_player play];
    
}






/// kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) { /// 状态
        if (item.status == AVPlayerStatusReadyToPlay) {
            /// 准备播放
            NSLog(@"准备播放");
                   }
        else if (item.status == AVPlayerStatusFailed){
            //// 失败
            NSLog(@"失败");
            NSLog(@"%@",item.error);
        }
        else{
            /// 未知
            NSLog(@"未知");
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]){ ///缓冲
       
    }
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        if (_playerItem.playbackBufferEmpty) { /// 网络较差
            NSLog(@"缓冲为空");
           
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_player play];
               
            });
        }
    }
    
}






- (void)setThumbImageUrl:(NSString *)thumbImageUrl{
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:thumbImageUrl]];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.thumbImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

}

- (void)toback:(id)sender{
    

    
    [self  removeSelfPlayer];
    
    [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.frame = _originFrame;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
}



- (void)removeSelfPlayer{
    
    [self.backButton removeFromSuperview];
    
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    
    [self.player removeTimeObserver:_playTimeObserver];
    
    [_playerLayer removeFromSuperlayer];
    [_player replaceCurrentItemWithPlayerItem:nil];
    _player = nil;
    _playerItem = nil;
    _playerLayer = nil;
}




- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton addTarget:self action:@selector(toback:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.backgroundColor = [UIColor redColor];
    }
    return _backButton;
}

- (UIImageView *)thumbImageView{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _thumbImageView;
}



- (void)dealloc{
    NSLog(@"videoplayerview dealloc");
}

@end




































