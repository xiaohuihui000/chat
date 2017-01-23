//
//  ViewController.m
//  ALAsset
//
//  Created by Jiafei on 16/4/19.
//  Copyright © 2016年 com.wahool. All rights reserved.
//

#import "WHVideoController.h"
#import "WHVideoCell.h"
#import "MBProgressHUD.h"

//#define MP4 @"public.mpeg-4"
//#define M4V @"com.apple.m4v-video"

@interface WHVideoController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation WHVideoController
{
    
    NSMutableArray *mutableArray;
    
    ALAssetsGroup  * assetGroup;
    
    UICollectionView *_collectionView;
    ALAssetsLibrary *library;
    MBProgressHUD *hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigation];
    [self createCollectionView];
    [self getAllVideo];
}

-(void)buttonAction:(UIButton*)button{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/// 取视频
-(void)getAllVideo
{
    library = [[ALAssetsLibrary alloc] init];
    //监测是否可用
    ALAssetsLibraryAccessFailureBlock failureblock =
    ^(NSError *myerror)
    {
        NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
        if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
            NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
        }else{
            NSLog(@"相册访问失败.");
        }
        [self createNotAllowView];
        return ;
    };
    mutableArray =[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock
    libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
        if (group != nil)
        {
            [group setAssetsFilter:[ALAssetsFilter allVideos]];
            [group enumerateAssetsWithOptions:NSEnumerationConcurrent usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [mutableArray addObject:result];
                }
            }];
        }
        else
        {
            NSLog(@"%ld",mutableArray.count);
            [_collectionView reloadData];
        }
    };
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                                         usingBlock:libraryGroupsEnumeration
                                                       failureBlock:failureblock];
}
#pragma mark-集合视图的代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return mutableArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WHVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    ALAsset *asset = mutableArray[indexPath.row];
    CGImageRef imgRef = asset.thumbnail;
    UIImage *img = [UIImage imageWithCGImage:imgRef];
    cell.coverImgView.image = img;
    NSString *time = [asset valueForProperty:ALAssetPropertyDuration];
    int t = [time  intValue];
    time = [self timeFormatted:t];
    cell.timeLbl.text = time;
    return cell;
}
/// 点击写入
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = mutableArray[indexPath.row];
//    ALAssetRepresentation *represent = [asset defaultRepresentation];
//    NSString *UTI = [represent UTI];
//    if (UTI == NULL) {
//        return;
//    }
//    if (![UTI isEqualToString:MP4] && ![UTI isEqualToString:M4V]) {
//        [WHInitial prompt:@"抱歉，请选择mp4文件" controller:self];
//        return;
//    }
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud show:YES];
    hud.labelText = @"正在加载...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self handleWrittenFile:asset];
    });
}
#pragma mark-辅助方法
/// 转化为时间格式
- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if(hours == 0){
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];;
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
/// 写入本地
-(void)handleWrittenFile:(ALAsset*) videoAsset
{
    if (!videoAsset) {
        NSLog(@"nil");
        return;
    }
    NSString *fileName = [self getVideoMergeFilePathString];
    ALAssetRepresentation *represent = [videoAsset defaultRepresentation];
    NSUInteger size = [represent size];
    const int bufferSize = 65636;
    NSLog(@"written to : %@", fileName);
    FILE *fileOpen = fopen([fileName cStringUsingEncoding:1], "wb+");
    if (fileOpen == NULL) {
        return;
    }
    Byte *buffer =(Byte*)malloc(bufferSize);
    NSUInteger read =0, offset = 0;
    NSError *error;
    if (size != 0) {
        do {
            read = [represent getBytes:buffer
                      fromOffset:offset
                          length:bufferSize
                           error:&error];
            fwrite(buffer, sizeof(char), read, fileOpen);
            offset += read;
        } while (read != 0);
    }
    free(buffer);
    buffer = NULL;
    fclose(fileOpen);
    fileOpen= NULL;
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.hidden = YES;
        [hud removeFromSuperview];
        if (_delegate) {
            [_delegate finishWriter:[[NSURL alloc] initFileURLWithPath:fileName] controller:self];
        }
    });
}
///得到要存储的文件名
-  (NSString *)getVideoMergeFilePathString
{
    NSString * path = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSString *fileName = [[path stringByAppendingPathComponent:nowTimeStr] stringByAppendingString:@".mp4"];
    return fileName;
}
#pragma mark-UI
/// 不允许访问
- (void)createNotAllowView{
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = @"没有权限访问您的相册";
    label1.textAlignment = NSTextAlignmentCenter;
//    label1.textColor = [UIColor colorWithHexString:@"#717171"];
    label1.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"您可以在“隐私设置”中启用访问";
    label2.textAlignment = NSTextAlignmentCenter;
//    label2.textColor = [UIColor colorWithHexString:@"#717171"];
    label2.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0).offset(13);
        make.height.mas_equalTo(18);
    }];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0).offset(-13);
        make.height.mas_equalTo(18);
    }];
}
/// 创建collectionView
- (void)createCollectionView {
    float x = (SCREENWIDTH-3)/4.0;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(x, x);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 74, SCREENWIDTH, SCREENHEIGHT-74) collectionViewLayout:flowLayout];
    [_collectionView registerClass:[WHVideoCell class] forCellWithReuseIdentifier:@"videoCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(74);
    }];
}
/// 导航栏
- (void)createNavigation {
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.773 green:0.855 blue:0.824 alpha:1];
//    view.backgroundColor = [UIColor colorWithHexString:@"#579454"];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    UIImageView *backImgView = [[UIImageView alloc] init];
    backImgView.image = [UIImage imageNamed:@"common_btn_fanhui"];
    [self.view addSubview:backImgView];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(33);
        make.width.mas_equalTo(9.5);
        make.height.mas_equalTo(16.5);
    }];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(backImgView.mas_right).offset(15);
        make.top.mas_equalTo(backImgView.mas_top).offset(-10);
        make.bottom.mas_equalTo(backImgView.mas_bottom).offset(10);
    }];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.font = [UIFont systemFontOfSize:17];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.text = @"视频";
    [self.view addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backImgView.mas_centerY);
        make.height.mas_equalTo(17);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
    }];
}
- (void)toBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dealloc{
    [mutableArray removeAllObjects];
    library=nil;
}
@end
