//
//  ChatAudioTableViewCell.m
//  chat
//
//  Created by chenguanghui on 17/1/11.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "ChatAudioTableViewCell.h"
#import "AudioPlayer.h"

@interface ChatAudioTableViewCell ()

@property(nonatomic , strong) AudioPlayer *player;

@property(nonatomic , copy) NSString *assetPath;

@end

@implementation ChatAudioTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        
        [self.bubbleImageView addSubview:self.audioImageView];
        
        [self.contentView addSubview:self.audioTimeLenthLable];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlay)];
        [self.bubbleImageView addGestureRecognizer:tap];
        
    }
    return self;
}




- (void)tapPlay{
    NSLog(@"点击播放 ");
    self.player = [AudioPlayer shareInstance];
    [_player setupPlayer:[NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),_assetPath]];
    [self.player player];
    
    /// 声音播放的时候 动画
}

- (void)setModel:(ChatModel *)model{
    self.timeLabel.text = model.time;
    BOOL isSender = model.isSender;
    
    CGFloat lenth = 0.0;
    if (model.timeLenth < 3) {
        lenth = 60.0;
    }
    else if(model.timeLenth < 10) {
        lenth = 60 + (model.timeLenth -3)*10;
    }
    else if(model.timeLenth < 20){
        lenth = 60 + (model.timeLenth - 3)*7;
    }
    else if(model.timeLenth < 30) {
        lenth = 60 + (model.timeLenth - 3)*5;
    }
    else if(model.timeLenth < 40) {
        lenth = 60 + (model.timeLenth - 3)*4;
    }
    else if (model.timeLenth < 50){
        lenth = 60 +(model.timeLenth -3)*3;
    }
    else{
        lenth = 200;
    }
    
    if (isSender) { /// 自己发的
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(19);
            make.right.mas_equalTo(-14);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [self.bubbleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(14);
            make.right.mas_equalTo(self.headImageView.mas_left).offset(0);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(lenth);
        }];
        self.bubbleImageView.image = [[UIImage imageNamed:@"chat_send_nor"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        
        [self.audioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.bottom.mas_equalTo(-18);
            make.width.mas_equalTo(28);
            make.right.mas_equalTo(-14);
        }];
        
        [self.audioTimeLenthLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.bubbleImageView.mas_left).offset(0);
            make.centerY.mas_equalTo(self.audioImageView.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        self.audioTimeLenthLable.textAlignment = NSTextAlignmentRight;
    }
    else{
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(19);
            make.left.mas_equalTo(14);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        [self.bubbleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(14);
            make.left.mas_equalTo(self.headImageView.mas_right).offset(0);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(lenth);
        }];
        self.bubbleImageView.image = [[UIImage imageNamed:@"chat_recive_nor"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        
        [self.audioImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.bottom.mas_equalTo(-18);
            make.width.mas_equalTo(28);
            make.left.mas_equalTo(14);
        }];
        
        [self.audioTimeLenthLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.bubbleImageView.mas_right).offset(0);
            make.centerY.mas_equalTo(self.audioImageView.mas_centerY);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        self.audioTimeLenthLable.textAlignment = NSTextAlignmentLeft;
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl]];
    self.audioTimeLenthLable.text = [NSString stringWithFormat:@"%ld\"",(NSInteger)(model.timeLenth)];
    
   /// 自己发的消息 别人发的消息 去下载

    _assetPath = model.assetPath;
    
    
    
  
    
}


- (UILabel *)audioTimeLenthLable{
    if (!_audioTimeLenthLable) {
        _audioTimeLenthLable = [[UILabel alloc] init];
        _audioTimeLenthLable.backgroundColor = [UIColor clearColor];
        _audioTimeLenthLable.textColor = [UIColor lightGrayColor];
        _audioTimeLenthLable.font = [UIFont systemFontOfSize:14];
    }
    return _audioTimeLenthLable;
}
- (UIImageView *)audioImageView{
    if (!_audioImageView) {
        _audioImageView = [[UIImageView alloc] init];
        _audioImageView.image = [UIImage imageNamed:@"dd_record_normal"];
        _audioImageView.userInteractionEnabled = YES;
    }
    return _audioImageView;
}

- (void)dealloc{
    [_player stopPlayer];
    NSLog(@"ChatAudioTableViewCell dealloc");
}

@end
