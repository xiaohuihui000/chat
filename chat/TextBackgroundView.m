//
//  TextBackgroundView.m
//  chat
//
//  Created by chenguanghui on 17/1/6.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "TextBackgroundView.h"
#import "Masonry/Masonry.h"
#import "UIResponder+Router.h"
#import "ChatModel.h"
#import "RecordingView.h"
#import "AppDelegate.h"
#import "TouchDownGestureRecognizer.h"
#import "Recorder.h"
#import "faceView.h"

@interface TextBackgroundView ()<UITextViewDelegate,RecorderDelegate,faceViewDelegate>

@property(nonatomic , strong) UITextView *inputTextView;

@property(nonatomic , strong) UIButton *voiceButton;

@property(nonatomic , strong) UIButton *faceButton;

@property(nonatomic , strong) UIButton *moreButton;

@property(nonatomic , assign) CGFloat  heightOfTextView;

@property(nonatomic , strong) UIImageView *voiceImageView;

@property(nonatomic , strong) TouchDownGestureRecognizer *recognizer;

@property(nonatomic , strong) RecordingView *mRecordingView;

@property(nonatomic , strong) Recorder *mRecorder;

@property(nonatomic , strong) faceView *mfaceView;

@end

@implementation TextBackgroundView

- (instancetype)init{
    if (self = [super init]) {
        
        self.backgroundColor = kbackgroundcolor;
        _heightOfTextView = kminheight;
        
        [self addSubview:self.voiceButton];
        [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(5);
            make.width.mas_equalTo(34);
            make.height.mas_equalTo(34);
        }];
        
        [self addSubview:self.inputTextView];
        
        [self addSubview:self.faceButton];
        
        [self addSubview:self.moreButton];
        
        __weak TextBackgroundView *weakSelf = self;

        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.centerY.mas_equalTo(weakSelf.voiceButton.mas_centerY);
            make.width.mas_equalTo(34);
            make.height.mas_equalTo(34);
        }];
        
        [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.moreButton.mas_left).offset(0);
            make.centerY.mas_equalTo(weakSelf.voiceButton.mas_centerY);
            make.width.mas_equalTo(34);
            make.height.mas_equalTo(34);
        }];
        
        [self.inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(weakSelf.voiceButton.mas_right).offset(0);
            make.right.mas_equalTo(weakSelf.faceButton.mas_left).offset(0);
        }];
        
        
        /**
         *  @brief  监听键盘显示、隐藏变化，让自己伴随键盘移动
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


- (void)resignTextViewFirstResponder{
    [self.inputTextView resignFirstResponder];
}
#pragma mark - 录音代理

- (void)audioRecorderDidFinishSuccessfully:(BOOL)flag timeInterval:(NSTimeInterval)time string:(NSString *)path{
    if (time < 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mRecordingView setHidden:NO];
            [_mRecordingView setRecordingState:DDShowRecordTimeTooShort];
        });
        return;
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSLog(@"字节数 %ld",data.length);
    if (flag == NO || data.length < 5000) {
        NSLog(@"录制失败");
        [_mRecordingView setRecordingState:DDShowRecordTimeTooShort];
    }
    else{
        [self p_sendRecord:YES path:path time:time];
    }
}

#pragma mark - 声音相关逻辑
/// 按下
- (void)p_record{
    /// UI
    self.voiceImageView.image = [UIImage imageNamed:@"dd_record_release_end"];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if (![[delegate.window subviews] containsObject:self.mRecordingView]) {
        [delegate.window addSubview:self.mRecordingView];
    }
    [_mRecordingView setHidden:NO];
    [_mRecordingView setRecordingState:DDShowVolumnState];
    /// 业务
    [self.mRecorder startRecorder];
}
///在内部结束取消
- (void)p_endCancelRecord{
    [_mRecordingView setHidden:NO];
    [_mRecordingView setRecordingState:DDShowVolumnState];
}
/// 在外部即将取消
- (void)p_willCancelRecord{
    [_mRecordingView setHidden:NO];
    [_mRecordingView setRecordingState:DDShowCancelSendState];
}
///松手 发送
- (void)p_sendRecord:(BOOL)flag path:(NSString *)path time:(NSTimeInterval )time{
    /// UI
    self.voiceImageView.image = [UIImage imageNamed:@"dd_press_to_say_normal"];
    [_mRecordingView setHidden:YES];
    /// 业务
    if (flag == NO) {
        [self.mRecorder endRecorder];
    }
    else{
        /// 发消息
        NSLog(@"发消息");
        [[self nextResponder] routerEventWithType:EventChatCellTypeSendMsgEvent userInfo:@{@"timeLenth":[NSNumber numberWithInteger:time],@"type":@(ChatCellType_Audio),@"assetPath":path}];
    }
    

}
/// 松手不发送
- (void)p_cancelRecord{
    self.voiceImageView.image = [UIImage imageNamed:@"dd_press_to_say_normal"];
    [_mRecordingView setHidden:YES];
    self.mRecorder = nil;
}
#pragma mark - faceView代理

- (void)sendContent:(NSString *)content{
    _inputTextView.text = @"";
    [self textViewDidChange:_inputTextView];
    [[self nextResponder] routerEventWithType:EventChatCellTypeSendMsgEvent userInfo:@{@"type":@(ChatCellType_Face),@"content":content}];
}

- (void)addOrDeleteString{
    [self textViewDidChange:_inputTextView];
}
#pragma mark - textview代理
/// 点击发送
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (![textView.text isEqualToString:@""]) {
            
            if ([textView.text rangeOfString:@"]"].location != NSNotFound && _mfaceView != nil) {
                
                [self sendContent:textView.text];
                
                textView.text = @"";
                [self textViewDidChange:textView];
            }
            else{
                [self routerEventWithType:EventChatCellTypeSendMsgEvent userInfo:@{@"type":@(ChatCellType_Text),@"content":textView.text}];
                
                textView.text = @"";
                [self textViewDidChange:textView];
            }
            
        }
        return NO;
    }
    else if([text isEqualToString:@""]){
        if (_mfaceView) {
            [_mfaceView textFieldDelete];
            return NO;
        }
    }
    return YES;
}
/// 文字改变
- (void)textViewDidChange:(UITextView *)textView{
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.contentSize.width, 0)];
    
    CGFloat contentHeight;
    if (size.height > kmaxheight) {
        contentHeight = kmaxheight;
        textView.scrollEnabled = YES;
    }
    else{
        contentHeight = size.height;
        textView.scrollEnabled = NO;
    }
    if (_heightOfTextView != contentHeight) {
        _heightOfTextView = contentHeight;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentHeight+10);
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"frameChange" object:self];
        
    }
}

#pragma mark - 通知
- (void)keyboardChange:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    
    /// 时间
    NSTimeInterval animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    /// 动画曲线
    UIViewAnimationCurve animationCurve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    /// fame
    CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    if (notification.name == UIKeyboardWillShowNotification) {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-keyboardEndFrame.size.height);
        }];
    }
    else{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"frameChange" object:self];
    [self.superview layoutIfNeeded];
    [UIView commitAnimations];
    
}




#pragma mark - 按钮点击


- (void)voiceButtonClick:(UIButton *)sender{
    _voiceButton.selected = !_voiceButton.selected;
    if (_voiceButton.selected) {
        if (_faceButton.selected) {
            _faceButton.selected = NO;
            _inputTextView.inputView = nil;
            [_inputTextView reloadInputViews];
        }
        [_inputTextView resignFirstResponder];
        [self addSubview:self.voiceImageView];
        [_voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(self.voiceButton.mas_right).offset(0);
            make.right.mas_equalTo(self.faceButton.mas_left).offset(0);
        }];
        
    }
    else{

        [_voiceImageView removeFromSuperview];
        [_inputTextView becomeFirstResponder];
        
    }
}
- (void)faceButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        if (_voiceButton.selected) {
            _voiceButton.selected = NO;
            [_voiceImageView removeFromSuperview];
        }
        
        [_inputTextView becomeFirstResponder];
        
        _inputTextView.inputView = self.mfaceView;
        
        [_inputTextView reloadInputViews];
    }
    else{
        _inputTextView.inputView = nil;
        
        [_inputTextView reloadInputViews];
        [_inputTextView becomeFirstResponder];
    }
}
- (void)moreButtonClick:(UIButton *)sender{
    [self routerEventWithType:EventChatMoreViewPickerImage userInfo:nil];
}
#pragma mark - 懒加载
- (faceView *)mfaceView{
    if (!_mfaceView) {
        _mfaceView = [[faceView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 260)];
        _mfaceView.textView = _inputTextView;
        _mfaceView.delegate = self;
    }
    return _mfaceView;
}
- (Recorder *)mRecorder{
    if (!_mRecorder) {
        _mRecorder = [[Recorder alloc] init];
        _mRecorder.delegate = self;
    }
    return _mRecorder;
}
- (RecordingView *)mRecordingView{
    if (!_mRecordingView) {
        _mRecordingView = [[RecordingView alloc] initWithState:DDShowVolumnState];
        [_mRecordingView setHidden:YES];
        [_mRecordingView setCenter:CGPointMake(SCREENWIDTH/2.0, SCREENHEIGHT/2.0)];
    }
    return _mRecordingView;
}
- (TouchDownGestureRecognizer *)recognizer{
    if (!_recognizer) {
        _recognizer = [[TouchDownGestureRecognizer alloc] initWithTarget:self action:nil];
        __weak TextBackgroundView *weakSelf = self;
        _recognizer.touchDown = ^{
            NSLog(@"按下");
            [weakSelf p_record];
        };
        _recognizer.moveInside = ^{
            NSLog(@"结束取消");
            [weakSelf p_endCancelRecord];
        };
        _recognizer.moveOutside = ^{
            NSLog(@"即将取消");
            [weakSelf p_willCancelRecord];
        };
        _recognizer.touchEnd = ^(BOOL inside){
            if (inside) {
                NSLog(@"松手发送");
                [weakSelf p_sendRecord:NO path:nil time:0];
            }
            else{
                NSLog(@"松手 不发送");
                [weakSelf p_cancelRecord];
            }
        };
        
        
    }
    return _recognizer;
}

- (UIImageView *)voiceImageView{
    if (!_voiceImageView) {
        _voiceImageView = [[UIImageView alloc] init];
        _voiceImageView.image = [UIImage imageNamed:@"dd_press_to_say_normal"];
        _voiceImageView.userInteractionEnabled = YES;
        [_voiceImageView addGestureRecognizer:self.recognizer];
    }
    return _voiceImageView;
}

- (UIButton *)voiceButton{
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton addTarget:self action:@selector(voiceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
        [_voiceButton setImage:[UIImage imageNamed:@"chat_bottom_keyboard_press"] forState:UIControlStateSelected];
        _voiceButton.selected = NO;
    }
    return _voiceButton;
}

- (UITextView *)inputTextView{
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc] init];
        _inputTextView.delegate = self;
        _inputTextView.layer.cornerRadius = 4;
        _inputTextView.layer.masksToBounds = YES;
        _inputTextView.layer.borderWidth = 1;
        _inputTextView.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        _inputTextView.scrollIndicatorInsets = UIEdgeInsetsMake(10.f, 0.0f, 10.f, 4.f);
        _inputTextView.contentInset = UIEdgeInsetsZero;
        _inputTextView.scrollEnabled = NO;
        _inputTextView.scrollsToTop = NO;
        _inputTextView.font = [UIFont systemFontOfSize:14];
        _inputTextView.textColor = [UIColor blackColor];
        _inputTextView.returnKeyType = UIReturnKeySend;
    }
    return _inputTextView;
}

- (UIButton *)faceButton{
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_faceButton addTarget:self action:@selector(faceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_faceButton setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:@"chat_bottom_keyboard_press"] forState:UIControlStateSelected];

    }
    return _faceButton;
}

- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateNormal];
    }
    return _moreButton;
}
- (void)dealloc{
    NSLog(@"textbackground dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


















































