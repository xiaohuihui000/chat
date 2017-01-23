//
//  WHVideoCell.m
//  wahool
//
//  Created by smjl on 16/4/21.
//  Copyright © 2016年 wahool. All rights reserved.
//

#import "WHVideoCell.h"

@implementation WHVideoCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _coverImgView = [[UIImageView alloc] init];
        [self addSubview:_coverImgView];
        [_coverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.and.bottom.mas_equalTo(0);
        }];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"common_img_shipinmengban"];
        [self addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.mas_equalTo(0);
            make.height.mas_equalTo(75/2.0);
        }];
        UIImageView *imgView2 = [[UIImageView alloc] init];
        imgView2.image = [UIImage imageNamed:@"common_img_shipinbiaozhi"];
        [self addSubview:imgView2];
        [imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(8);
        }];
        
        _timeLbl = [[UILabel alloc] init];
        _timeLbl.textColor = [UIColor whiteColor];
        _timeLbl.font = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
        _timeLbl.textAlignment = NSTextAlignmentRight;
        [self addSubview:_timeLbl];
        [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-9);
            make.bottom.mas_equalTo(-3);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(frame.size.width-20);
        }];
    }
    return self;
}
@end
