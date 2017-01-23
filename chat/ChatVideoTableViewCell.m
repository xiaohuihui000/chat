//
//  ChatVideoTableViewCell.m
//  chat
//
//  Created by chenguanghui on 17/1/11.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "ChatVideoTableViewCell.h"
#import "VideoPlayerView.h"


@interface ChatVideoTableViewCell ()

@property(nonatomic , strong) UIButton *playBbtton;

@property(nonatomic , strong) UILabel *durationLabel;

@property(nonatomic , strong) UIImageView *thumbImageView;

@property(nonatomic , strong)VideoPlayerView *playerView;

@property(nonatomic , strong) NSURL *url;

@property(nonatomic , assign) NSTimeInterval videoInterval;

@property(nonatomic , copy) NSString *thumbImageUrl;
@end



@implementation ChatVideoTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.bubbleImageView addSubview:self.thumbImageView];
        
        [self.bubbleImageView addSubview:self.playBbtton];
        
        [self.bubbleImageView addSubview:self.durationLabel];
    }
    return self;
}



/// 播放视频
- (void)playVideo{
    
    CGRect rect = [self.thumbImageView convertRect:self.thumbImageView.bounds toView:nil];
    NSLog(@"%f %f %f %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.playerView];
    self.playerView.frame = rect;
    

    _playerView.videoUrl = _url;
    _playerView.videoInterval = _videoInterval;
    _playerView.thumbImageUrl = _thumbImageUrl;
    
    
    
    [_playerView playVideo];
    
    
}


- (void)setModel:(ChatModel *)model{
    BOOL isSender = model.isSender;
    
    if (isSender) { /// 自己发的视频
        
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(19);
            make.right.mas_equalTo(-14);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        [self.bubbleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(14);
            make.right.mas_equalTo(self.headImageView.mas_left).offset(0);
            make.width.mas_equalTo(model.width+40);
            make.height.mas_equalTo(model.height+40);
        }];
        self.bubbleImageView.image = [[UIImage imageNamed:@"chat_send_nor"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        

        [self.thumbImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.bottom.mas_equalTo(-18);
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
        }];
        
        [self.playBbtton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        
        [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
            make.right.mas_equalTo(-20);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(20);
        }];
        
    }
    else{
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(19);
            make.left.mas_equalTo(14);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        [self.bubbleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(0);
            make.left.mas_equalTo(self.headImageView.mas_right).offset(0);
            make.width.mas_equalTo(model.width+40);
            make.height.mas_equalTo(model.height+40);
        }];
        self.bubbleImageView.image = [[UIImage imageNamed:@"chat_recive_nor"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        
        [self.thumbImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.bottom.mas_equalTo(-18);
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
        }];
        
        [self.playBbtton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [self.durationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
            make.right.mas_equalTo(-20);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(20);
        }];
    }
    self.timeLabel.text = model.time;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl]];
    [self.thumbImageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
    
    self.durationLabel.text = [NSString stringWithFormat:@"%ld",(NSInteger)model.timeLenth];
    
    _url = (NSURL *)(model.assetPath);
    _videoInterval = model.timeLenth;
    
    _thumbImageUrl = model.url;
}






- (VideoPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[VideoPlayerView alloc] init];
    }
    return _playerView;
}


- (UIImageView *)thumbImageView{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.userInteractionEnabled = YES;
    }
    return _thumbImageView;
}
- (UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = [UIFont systemFontOfSize:14];
        _durationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _durationLabel;
}

- (UIButton *)playBbtton{
    if (!_playBbtton) {
        _playBbtton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBbtton setImage:[UIImage imageNamed:@"MoviePlayer_Stop"] forState:UIControlStateNormal];
        [_playBbtton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _playBbtton;
}

@end
