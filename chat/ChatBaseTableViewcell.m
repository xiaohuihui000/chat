//
//  ChatBaseTableViewcell.m
//  chat
//
//  Created by chenguanghui on 17/1/6.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "ChatBaseTableViewcell.h"

@implementation ChatBaseTableViewcell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.mas_equalTo(0);
            make.height.mas_equalTo(14);
        }];
        
        [self.contentView addSubview:self.headImageView];
        
        
        [self.contentView addSubview:self.bubbleImageView];
        

        
    }
    return self;
}

- (void)setModel:(ChatModel *)model{
    NSLog(@"父类  model 的set方法");
}

#pragma mark - 手势点击


- (void)tap{
    NSLog(@"点击头像");
}

- (void)longPressTap:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"长按头像");
    }
   
}
- (void)longPress:(UILongPressGestureRecognizer *)press{
    NSLog(@"长按气泡");
}
#pragma mark - 懒加载

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_headImageView addGestureRecognizer:tap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
        [_headImageView addGestureRecognizer:longPress];
    }
    return _headImageView;
}


- (UIImageView *)bubbleImageView{
    if (!_bubbleImageView) {
        _bubbleImageView = [[UIImageView alloc] init];
        _bubbleImageView.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_bubbleImageView addGestureRecognizer:longPress];
    }
    return _bubbleImageView;
}

@end
