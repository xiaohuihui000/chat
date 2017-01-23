//
//  ChatBaseTableViewcell.h
//  chat
//
//  Created by chenguanghui on 17/1/6.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatBaseTableViewcell : UITableViewCell


@property(nonatomic , strong) UIImageView *headImageView;

@property(nonatomic , strong) UIImageView *bubbleImageView;

@property(nonatomic , strong) UILabel *timeLabel;

@property(nonatomic , strong) ChatModel *model;


- (void)longPress:(UILongPressGestureRecognizer *)press;

@end
