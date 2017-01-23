

//
//  ChatImageTableViewCell.m
//  chat
//
//  Created by chenguanghui on 17/1/9.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "ChatImageTableViewCell.h"
@implementation ChatImageTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.bubbleImageView addSubview:self.imgView];
    }
    return self;
}






- (void)setModel:(ChatModel *)model{
    
    BOOL isSender = model.isSender;
    
    if (isSender) { /// 自己发的图
        
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
        
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.bottom.mas_equalTo(-18);
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
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
        
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(18);
            make.bottom.mas_equalTo(-18);
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
        }];

    }
    self.timeLabel.text = model.time;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.url]];
}











- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}



- (void)longPress:(UILongPressGestureRecognizer *)press{}

@end
