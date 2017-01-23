//
//  NSTimer+Block.h
//  SooonerSocketPPDemo
//
//  Created by 吴贤德 on 2017/1/17.
//  Copyright © 2017年 Soooner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Block)


- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(void))block;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(void))block;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(void))block;

@end
