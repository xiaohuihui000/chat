//
//  ViewController.h
//  ALAsset
//
//  Created by Jiafei on 16/4/19.
//  Copyright © 2016年 com.wahool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
@class WHVideoController;
@protocol WHVideoControllerDelegate

- (void)finishWriter:(NSURL *)url controller:(WHVideoController *)viewcontroller;

@end

@interface WHVideoController : UIViewController

@property(nonatomic,weak)id<WHVideoControllerDelegate>delegate;



@end

