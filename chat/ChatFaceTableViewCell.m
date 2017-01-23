

//
//  ChatFaceTableViewCell.m
//  chat
//
//  Created by chenguanghui on 17/1/16.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "ChatFaceTableViewCell.h"
#import "faceView.h"
@implementation ChatFaceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.bubbleImageView addSubview:self.contentLable];
    }
    return self;
}



- (UILabel *)contentLable{
    if (!_attributeLabel) {
        _attributeLabel = [[UILabel alloc] init];
        _attributeLabel.numberOfLines = 0;
        _attributeLabel.font = [UIFont systemFontOfSize:17];
    }
    return _attributeLabel;
}


- (void)longPress:(UILongPressGestureRecognizer *)press{
    
}
- (void)setModel:(ChatModel *)model{
    BOOL isSender = model.isSender;
    

    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:[faceView getCustomEmojWithString:model.content withColor:[UIColor blackColor]]];
    
    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, attributeString.length)];
    CGSize size =    [attributeString boundingRectWithSize:CGSizeMake(SCREENWIDTH-140, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;


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
    
    self.attributeLabel.attributedText = attributeString;
    
    
}

@end
