//
//  Recorder.h
//  audio
//
//  Created by chenguanghui on 17/1/10.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol RecorderDelegate <NSObject>

- (void)audioRecorderDidFinishSuccessfully:(BOOL)flag timeInterval:(NSTimeInterval)time string:(NSString *)path;




@end

@interface Recorder : NSObject

@property(nonatomic , assign) id<RecorderDelegate>delegate;


- (void)startRecorder;
- (void)endRecorder;







@end
