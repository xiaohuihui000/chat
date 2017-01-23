//
//  faceCollectionViewCell.m
//  faceKeyboard
//
//  Created by chenguanghui on 17/1/16.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "faceCollectionViewCell.h"

@implementation faceCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imgView];
    }
    return self;
}



@end
