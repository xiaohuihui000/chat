//
//  ChatTextTableViewCell.m
//  chat
//
//  Created by chenguanghui on 17/1/6.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "ChatTextTableViewCell.h"

@implementation ChatTextTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.bubbleImageView addSubview:self.contentLable];
    }
    return self;
}



- (UILabel *)contentLable{
    if (!_contentLable) {
        _contentLable = [[UILabel alloc] init];
        _contentLable.numberOfLines = 0;
        _contentLable.font = [UIFont systemFontOfSize:17];
    }
    return _contentLable;
}


- (void)longPress:(UILongPressGestureRecognizer *)press{
    
}
- (void)setModel:(ChatModel *)model{
    BOOL isSender = model.isSender;
    
    
    NSString *content = model.content;
    CGSize size = [content boundingRectWithSize:CGSizeMake(SCREENWIDTH-140, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    self.timeLabel.text = model.time;
    
    if (isSender == YES) { /// 自己发的文本
        
        [self.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(19);
            make.right.mas_equalTo(-14);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];

        [self.bubbleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(self.headImageView.mas_left).offset(0);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(0);
            make.width.mas_equalTo(size.width+40);
            make.bottom.mas_equalTo(0);
            
        }];
        
        self.bubbleImageView.image = [[UIImage imageNamed:@"chat_send_nor"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        
        
        [self.contentLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
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
            make.left.mas_equalTo(self.headImageView.mas_right).offset(0);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(0);
            make.width.mas_equalTo(size.width+40);
            make.bottom.mas_equalTo(0);
        }];
        self.bubbleImageView.image = [[UIImage imageNamed:@"chat_recive_nor"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        [self.contentLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.right.mas_equalTo(-18);
            make.top.mas_equalTo(15);
            make.bottom.mas_equalTo(-15);
        }];
    }
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl]];
    
    self.contentLable.text = model.content;

    
}
@end










































