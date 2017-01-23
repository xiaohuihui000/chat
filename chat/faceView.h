//
//  faceView.h
//  faceKeyboard
//
//  Created by chenguanghui on 17/1/16.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol faceViewDelegate <NSObject>

//-(void)sendAttributeContent:(NSAttributedString *)attributeString;

- (void)sendContent:(NSString *)content;


- (void)addOrDeleteString;

@end

@interface faceView : UIView

@property(nonatomic , assign)id<faceViewDelegate> delegate;
@property(nonatomic , strong)UITextView *textView;


- (void)textFieldDelete;

+(NSAttributedString *)getCustomEmojWithString:(NSString *)customEmojString withColor:(UIColor *)textColor;

@end
