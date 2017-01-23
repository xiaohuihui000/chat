//
//  faceView.m
//  faceKeyboard
//
//  Created by chenguanghui on 17/1/16.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "faceView.h"
#import "Masonry/Masonry.h"
#import "faceCollectionViewCell.h"

/// 整体高度
#define kHeight (200)
/// 几页
#define KIndex (2)

/// 每一项大小
#define itemWidth (40)
#define itemHeight (40)
/// 每一项距离左右 上下
#define spaceWidth (8)
#define spaceHeight (30)

/// 距离上下左右
#define KTop (10)
#define KBottom (10)
#define KLeft (20)
#define KRight (20)
/// 一页多少个
#define KCount (21)

@interface faceView ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic , strong)NSMutableArray *emojsArray;
@property(nonatomic , assign)CGFloat keyboardHeight;
@property(nonatomic , strong)NSArray *emojsTextArray;

@property(nonatomic , strong)UIButton *sendButton;

@property(nonatomic , strong)UIScrollView *emojsScrollView;

@end


@implementation faceView
+(NSAttributedString *)getCustomEmojWithString:(NSString *)customEmojString withColor:(UIColor *)textColor{
    return [[self new] getCustomEmojWithString:customEmojString withColor:[UIColor blackColor]];
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}


- (void)configUI{
    _keyboardHeight = 0;
    self.backgroundColor = [UIColor lightGrayColor];
    _emojsArray = [NSMutableArray array];
    for (int i=1; i<36; i++) {
        NSString *imgName = [NSString stringWithFormat:@"ee_%d",i];
        [_emojsArray addObject:imgName];
    }

    
      _emojsTextArray = @[@"[sey]",@"[pie]",@"[yun]",@"[dng]",@"[tse]",@"[lvy]",@"[coo]",@"[amz]",@"[kis]",@"[sml]",@"[tsh]",@"[pzl]",@"[drn]",@"[ust]",@"[spz]",@"[hnx]",@"[shy]",@"[hxn]",@"[kxn]",@"[god]",@"[bad]",@"[nwd]",@"[gls]",@"[sht]",@"[waz]",@"[agy]",@"[cry]",@"[evl]",@"[fgt]",@"[sck]",@"[qpi]",@"[tul]",@"[jjj]",@"[ddd]",@"[kkk]"];
    
 
    [self addSubview:self.emojsScrollView];
    
    [self addSubview:self.sendButton];
    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
}

- (void)sendMessage{
    if (_textView.text > 0) {
        if(_delegate && [_delegate respondsToSelector:@selector(sendContent:)])
            [_delegate sendContent:_textView.text];
    }
    
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.backgroundColor = [UIColor greenColor];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    }
    return _sendButton;
}


- (UIScrollView *)emojsScrollView{
    if (!_emojsScrollView) {
        
        _emojsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kHeight)];
        _emojsScrollView.delegate = self;
        _emojsScrollView.pagingEnabled = YES;
        _emojsScrollView.contentSize = CGSizeMake(KIndex*[UIScreen mainScreen].bounds.size.width, kHeight);
        for (int i=0; i<KIndex; i++) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.itemSize = CGSizeMake(itemWidth, itemHeight);
            layout.minimumInteritemSpacing = spaceWidth;
            layout.minimumLineSpacing = spaceHeight;
            layout.sectionInset = UIEdgeInsetsMake(KTop, KBottom, KLeft, KRight);
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
            UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, kHeight) collectionViewLayout:layout];
            collection.backgroundColor = [UIColor whiteColor];
            [collection registerClass:[faceCollectionViewCell class] forCellWithReuseIdentifier:@"faceCollectionViewCell"];
            collection.tag = 100+i;
            collection.delegate = self;
            collection.dataSource = self;
            [_emojsScrollView addSubview:collection];
            
        }
    }
    return _emojsScrollView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag-100 == KIndex-1) {
        return _emojsArray.count-(KIndex-1)*(KCount-1)+1;
    }
    return KCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    faceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"faceCollectionViewCell" forIndexPath:indexPath];
    if (collectionView.tag-100 == KIndex-1 ) {/// 最后一页
        if (indexPath.row == (_emojsArray.count - (KIndex-1)*(KCount-1))) {
            cell.imgView.image = [UIImage imageNamed:@"common_btn_shanbiaoqing"];
        }
        else{
            NSInteger index =  (collectionView.tag-100)*(KCount-1)+indexPath.row;
            cell.imgView.image = [UIImage imageNamed:_emojsArray[index]];
        }
    }
    else{
        if (indexPath.row == KCount-1) {
            cell.imgView.image = [UIImage imageNamed:@"common_btn_shanbiaoqing"];
        }
        else{
            NSInteger index =  (collectionView.tag-100)*(KCount-1)+indexPath.row;
            cell.imgView.image = [UIImage imageNamed:_emojsArray[index]];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag-100 == KIndex-1) { /// 最后一页
        if (indexPath.row == (_emojsArray.count - (KIndex-1)*(KCount-1))) { /// 最后一个 删除
            [self textFieldDelete];
        }
        else{
           NSInteger index =  (collectionView.tag-100)*(KCount-1)+indexPath.row;
            NSString *emojStr = _emojsTextArray[index];
            [self textFieldAddString:emojStr];
        }
    }
    else{
        if (indexPath.row ==  (KCount-1)) { /// 最后一个 删除
            [self textFieldDelete];
        }
        else{
            NSInteger index =  (collectionView.tag-100)*(KCount-1)+indexPath.row;
            NSString *emojStr = _emojsTextArray[index];
            [self textFieldAddString:emojStr];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(addOrDeleteString)]) {
        [_delegate addOrDeleteString];
    }
}

- (void)textFieldAddString:(NSString *)str{
    NSString *string = _textView.text;
    string = [NSString stringWithFormat:@"%@%@",string,str];
    _textView.text = string;
    
}
- (void)textFieldDelete{
    NSString *contentText = _textView.text;
    if ([contentText hasSuffix:@"]"]) {
        NSRange range = [contentText rangeOfString:@"[" options:NSBackwardsSearch];
        [_textView setText:[contentText substringToIndex:range.location]];
    }
    else{
        if (contentText.length > 0) {
            _textView.text = [contentText substringToIndex:contentText.length-1];
        }
    }
}
-(NSAttributedString *)getCustomEmojWithString:(NSString *)customEmojString withColor:(UIColor *)textColor{
    if(!customEmojString)
        return nil;
    
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5\\-\\123~!@#$%^&*()_+<>?:,./;'，。、‘：“《》？~！@#￥%……（）|]+\\]";
    NSError * error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
    }
    NSArray *resultArray = [re matchesInString:customEmojString options:0 range:NSMakeRange(0, customEmojString.length)];
    
    NSMutableAttributedString * string = [[ NSMutableAttributedString alloc ] initWithString:customEmojString  attributes:nil];
    
    /// 行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10];
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    /// 字间距
//    [string addAttribute:NSKernAttributeName value:@(10) range:NSMakeRange(0, string.length)];
    
    
    /// 颜色
    [string addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, string.length)];

    NSMutableArray * tempImgArray = [NSMutableArray array];
    
    for (int i = 0; i < resultArray.count; i ++) {
        NSTextCheckingResult * result = [resultArray objectAtIndex:i];
        NSString * faceText = [customEmojString substringWithRange:result.range];
        if ([_emojsTextArray containsObject:faceText]) {
            NSInteger index = [_emojsTextArray indexOfObject:faceText];
            NSTextAttachment * textAttachment = [[ NSTextAttachment alloc ] initWithData:nil ofType:nil ] ;
            UIImage * smileImage = [UIImage imageNamed: [_emojsArray objectAtIndex:index]];
            textAttachment.image = [self imageWithImage:smileImage scaledToSize:CGSizeMake(20, 20)];
            NSAttributedString * textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment] ;
            NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:textAttachmentString,@"image",[NSValue valueWithRange:result.range],@"range", nil];
            [tempImgArray addObject:tempDic];
        }
    }
    
    while (YES) {
        if (tempImgArray.count == 0) {
            break;
        }
        NSDictionary * dic = [tempImgArray lastObject];
        [string replaceCharactersInRange:[[dic objectForKey:@"range"] rangeValue] withAttributedString:[dic objectForKey:@"image"]];
        [tempImgArray removeLastObject];
    }
    return string;
}
-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end





























































