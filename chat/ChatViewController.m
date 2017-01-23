//
//  ChatViewController.m
//  chat
//
//  Created by chenguanghui on 17/1/6.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "ChatViewController.h"
#import "chatHeader.pch"
#import "TextBackgroundView.h"
#import "UIResponder+Router.h"
#import "ChatBaseTableViewcell.h"
#import "ChatTextTableViewCell.h"
#import <SooonerSocketPP/SooonerSocketPP.h>
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "ChatImageTableViewCell.h"
#import "ChatAudioTableViewCell.h"
#import "WHVideoController.h"
#import "ChatVideoTableViewCell.h"
#import "ChatFaceTableViewCell.h"
#import "FMDBManager.h"
#import "faceView.h"

#define KPath ([NSString stringWithFormat:@"%@/Documents/sqlite",NSHomeDirectory()])

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,WHVideoControllerDelegate>


@property(nonatomic , strong) UIView *navigationView;

@property(nonatomic , strong) UITableView *tableView;

@property(nonatomic , strong) TextBackgroundView *backgroundView;



@property(nonatomic , strong) NSMutableArray *array;



@property(nonatomic , strong) UILabel *titleLabel;

@property(nonatomic , assign) BOOL isSelf;


@property(nonatomic , strong) FMDBManager *dbManager;



@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isSelf = NO;
    
    [self setupFMDBData];

    
    self.view.backgroundColor = [UIColor colorWithRed:0.773 green:0.855 blue:0.824 alpha:1];
    [self.view addSubview:self.navigationView];
    
    [self.view addSubview:self.tableView];

    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.bottom.mas_equalTo(_backgroundView.mas_top).offset(-20);
    }];
    if (_array.count >= 1) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
 
    
    [self addNotification];

    [self reconnect];

    
    
    [[RealReachability sharedInstance] startNotifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark - 数据库
- (void)setupFMDBData{
    
    _dbManager = [FMDBManager initialization];
    BOOL success = [_dbManager openFMDBSqliteWithUsername:_username];
    if (!success) {
        return;
    }
    _array = [NSMutableArray arrayWithArray:[_dbManager queryAllDataWithUsername:_username]];
}



- (void)insertFMDBData:(ChatModel *)model{
    
    BOOL success = [_dbManager increaseDataFromUserName:_username withModel:model];
    if (success) {
        NSLog(@"插入成功");
    }
}


#pragma mark - 通知添加
/// 添加通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ConnectedCallback:) name:kSooonerSocketManagerConnectedCallbackNotifiCation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReconnectCallback:) name:kSooonerSocketManagerReconnectCallbackNotifiCation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ConnectErrorCallback:) name:kSooonerSocketManagerConnectErrorCallbackNotifiCation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JoinCallback:) name:kSooonerSocketManagerJoinCallbackNotifiCation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeaveCallback:) name:kSooonerSocketManagerLeaveCallbackNotifiCation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RoomMessageCallback:) name:kSooonerSocketManagerRoomMessageCallbackNotifiCation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PrivateMessageCallback:) name:kSooonerSocketManagerPrivateMessageCallbackNotifiCation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OfflineMessageCallback:) name:kSooonerSocketManagerOfflineMessageCallbackNotifiCation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SystemMessageCallback:) name:kSooonerSocketManagerSystemMessageCallbackNotifiCation object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(reachabilityChanged:)
     
                                                 name:kRealReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameChange) name:@"frameChange" object:nil];
}
/// 移除通知
- (void)removeNotification{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/// 网络状况监听
- (void)reachabilityChanged:(NSNotification *)notification{
    NSLog(@"%@",notification.object);
    ReachabilityStatus status = [[RealReachability sharedInstance] currentReachabilityStatus];
    switch (status) {
        case -1:
            break;
        case 0:
            NSLog(@"网络断了");
            break;
        case 1:
            NSLog(@"2g 或3g 4g");
            [self reconnect];
            break;
        case 2:
            NSLog(@"WFIF");
            [self reconnect];
            break;
        default:
            break;
    }
}
#pragma mark - 即时通讯

- (void)reconnect{
    NSString *url = @"ws://117.122.220.72:39002";
    [[SooonerSocketManager shareInstance] connect:url];

}
/// 加入房间
- (void)joinRoom:(NSString *)roomId{
    [[SooonerSocketManager shareInstance] joinRoom:@"room1" withACK:^(NSArray *data) {
        NSLog(@"加入房间 %@",data);
    }];
}
/// 注册
- (void)regist{
    NSDictionary *dict = @{@"sp":@"fblife",@"user":@{@"id":@"chatIos",@"name":@"chat"}};
    if (![SooonerSocketManager shareInstance].registInfo) {
       [[SooonerSocketManager shareInstance] regist:dict withACK:^(NSArray *data) {
            NSLog(@"注册 %@",data);
           if (data.count && [[data firstObject] isEqualToString:@"ok"]) {
               [self joinRoom:@"room1"];
           }
        }];
    }
}
/// 链接成功
- (void)ConnectedCallback:(NSNotification *)notification{
    NSLog(@"链接成功");
    [self regist];
}
/// 发送消息到服务器
- (void)sendPrivateMessageToServer:(NSDictionary *)dict{
    [[SooonerSocketManager shareInstance] sendRoomMessage:dict withACK:^(NSArray *data) {
        NSLog(@"发送消息到服务器 %@" ,data);
    }];
}
/// 自动重连中通知
- (void)ReconnectCallback:(NSNotification *)notification{
     NSLog(@"自动重连中通知");
}
/// 链接错误
- (void)ConnectErrorCallback:(NSNotification *)notification{
    NSLog(@"链接错误");
}
/// 接收进入房间通知
- (void)JoinCallback:(NSNotification *)notification{
    NSLog(@"接收进入房间通知");
    NSArray *array = notification.object;
    NSLog(@"%@",array);
}
/// 接收离开房间通知
- (void)LeaveCallback:(NSNotification *)notification{
    NSLog(@"接收离开房间通知");
    NSArray *array = notification.object;
    NSLog(@"%@",array);
}
/// 接收房间消息通知
- (void)RoomMessageCallback:(NSNotification *)notification{
    NSLog(@"接收房间消息通知");
    NSArray *array = notification.object;
   
    NSLog(@"%@",array);
}
///接收私聊消息通知
- (void)PrivateMessageCallback:(NSNotification *)notification{
    NSLog(@"接收私聊消息通知");
    NSArray *array = notification.object;
    /// 数组每一项都是json字符串
    for (NSString  *jsonString in array) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        ChatModel *model = [[ChatModel alloc] init];
        model.headImageUrl = @"http://i.zeze.com/attachment/forum/201608/21/083953yktqrpalrfl4r4a0.jpg";
        NSLog(@"%@",dict[@"msg"]);
        model.userName = dict[@"user"][@"name"];
        model.isSender = NO;
        model.messageType = [dict[@"msg"][@"type"] integerValue];
        model.content = dict[@"msg"][@"content"];
        model.time = @"从服务器 时间暂时没有";
        /// 更新UI
        [_array addObject:model];
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_array.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        /// 更新数据库
        [self insertFMDBData:model];

    }
    
}
///接收离线消息通知
- (void)OfflineMessageCallback:(NSNotification *)notification{
    NSLog(@"接收离线消息通知");
    NSArray *array = notification.object;
    NSLog(@"%@",array);
}
///接收系统消息通知
- (void)SystemMessageCallback:(NSNotification *)notification{
    NSLog(@"接收系统消息通知");
    NSArray *array = notification.object;
    NSLog(@"%@",array);
}

/// 输入框frame改变通知
- (void)frameChange{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_array.count >= 1) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    });
}


#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatModel *model = _array[indexPath.row];
    switch (model.messageType) {
        case ChatCellType_time:
            
            break;
        case ChatCellType_Text:
            {
                ChatTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatTextTableViewCell"];
                if (!cell) {
                    cell = [[ChatTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatTextTableViewCell"];
                }
                cell.model = model;
                return cell;
            }
            break;
        case ChatCellType_Image:
            {
                ChatImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatImageTableViewCell"];
                if (!cell) {
                    cell = [[ChatImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatImageTableViewCell"];
                }
                cell.model = model;
                return cell;
            }
            break;
        case ChatCellType_Audio:
            {
                ChatAudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatAudioyuyinTableViewCell"];
                if (!cell) {
                    cell = [[ChatAudioTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatAudioyuyinTableViewCell"];
                }
                cell.model = model;
                return cell;

            }
            break;
        case ChatCellType_Video:
        {
            ChatVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatVideoTableViewCell"];
            if (!cell) {
                cell = [[ChatVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatVideoTableViewCell"];
            }
            cell.model = model;
            return cell;
        }
            break;
        case ChatCellType_Face:
        {
            ChatFaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatFaceTableViewCell"];
            if (!cell) {
                cell = [[ChatFaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatFaceTableViewCell"];
            }
            cell.model = model;
            return cell;
        }
        default:
            break;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatModel *model = _array[indexPath.row];
    
    
    if (model.messageType == ChatCellType_Text) {
        
        CGSize size = [model.content boundingRectWithSize:CGSizeMake(SCREENWIDTH-140, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
        return size.height+54;
    }
    else if (model.messageType == ChatCellType_Image){
        return 154;
    }
    else if(model.messageType == ChatCellType_Audio) {
        return 83;
    }
    else if (model.messageType == ChatCellType_Video){
        return 154;
    }
    else if (model.messageType == ChatCellType_Face){
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:[faceView getCustomEmojWithString:model.content withColor:[UIColor blackColor]]];
        
        [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, attributeString.length)];
        CGSize size =    [attributeString boundingRectWithSize:CGSizeMake(SCREENWIDTH-140, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        return size.height+54;
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - 接受消息 

- (void)routerEventWithType:(EventChatCellType)eventType userInfo:(NSDictionary *)userInfo{
    
    switch (eventType) {
        case EventChatCellRemoveEvent:
            
            break;
        case EventChatCellImageTapedEvent:
            break;
        case EventChatCellHeadTapedEvent:
            break;
        case EventChatCellTypeSendMsgEvent:
            NSLog(@"消息来了");
            NSInteger type = [userInfo[@"type"] integerValue];
            if (type == ChatCellType_Text) {
                [self sendTextMessage:userInfo];
            }
            else if (type == ChatCellType_Audio){
                [self sendAudioMessage:userInfo];
            }
            else if (type == ChatCellType_Face){
                [self sendFaceMessage:userInfo];
            }
            break;
        case EventChatMoreViewPickerImage:
        {
            __weak typeof(self) weakSelf = self;
            UIAlertController *controller = [[UIAlertController alloc] init];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:cancle];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf sendImageMessage];
            }];
            [controller addAction:action];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf sendVideoMessage];
            }];
            [controller addAction:action2];
            [self.navigationController presentViewController:controller animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 选视频代理
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil] ;
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    //取帧
    CGImageRef thumbTemp = NULL;
    CMTime actualTime ;
    //    int32_t time = asset.duration.timescale;
    NSError *error = nil;
    thumbTemp = [assetImageGenerator copyCGImageAtTime:CMTimeMake(time, asset.duration.timescale) actualTime:&actualTime error:&error];
    NSLog(@"%lld",actualTime.value);
    UIImage *thumb = nil;
    if (!error)
    {
        thumb = [[UIImage alloc] initWithCGImage:thumbTemp];
    }
    CGImageRelease(thumbTemp);
    return thumb;
}

- (void)finishWriter:(NSURL *)url controller:(WHVideoController *)viewcontroller{
    [viewcontroller dismissViewControllerAnimated:YES completion:nil];
    
    ChatModel *model = [[ChatModel alloc] init];
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    /// 视频时长
    CGFloat duration = asset.duration.value / asset.duration.timescale;
    /// 视频缩略图
    UIImage *thumbImage = [self thumbnailImageForVideo:url atTime:0];
    
    static int j = 0;
    if (j == 0) {
        j = 1;
        model.headImageUrl = @"http://up.qqjia.com/z/25/tu32695_14.jpg";
        model.userName = @"self";
        model.isSender = YES;
    }
    else{
        j = 0;
        model.headImageUrl = @"http://i.zeze.com/attachment/forum/201608/21/083953yktqrpalrfl4r4a0.jpg";
        model.userName = @"other";
        model.isSender = NO;
    }
    model.messageType = ChatCellType_Video;
    model.time = [self getCurrentTime];
    model.url = @"http://img10.360buyimg.com/imgzone/jfs/t1657/189/205188340/215968/eddc2d8a/557e94abN205fdd7b.jpg";
    model.height = 100;
    model.width = thumbImage.size.width * 100.0 / thumbImage.size.height;
    model.timeLenth = duration;
    model.assetPath = (NSString *)url;
    
    NSLog(@"%@",model.assetPath);
    
    [_array addObject:model];
    
//    [_tableView reloadData];
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_array.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    /// 加入数据库
    
    
}
#pragma mark - 消息方法

- (void)sendVideoMessage{

    WHVideoController *controller = [[WHVideoController alloc] init];
    
    controller.delegate = self;
    
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

- (void)sendAudioMessage:(NSDictionary *)userInfo{
    NSString *path = userInfo[@"assetPath"];
    NSString *time = [self getCurrentTime];
    
    NSString *newPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),_username];

    if (![[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
        NSError *error;
       BOOL success= [[NSFileManager defaultManager] createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:NULL error:&error];
        if (!success) {
            return;
        }
    }
    
    [[NSFileManager defaultManager] moveItemAtPath:path toPath:[NSString stringWithFormat:@"%@/%@.caf",newPath,time] error:nil];
    
    
    
    
    
    NSTimeInterval timeLenth = [userInfo[@"timeLenth"] integerValue];
    
    
    ChatModel *model = [[ChatModel alloc] init];
    model.messageType = ChatCellType_Audio;

    
    static int i = 0;
    
    if (i==0) {
        model.headImageUrl = @"http://up.qqjia.com/z/25/tu32695_14.jpg";
        model.userName = @"self";
        model.isSender = YES;
        i = 1;
    }
    else{
        i = 0;
        model.headImageUrl = @"http://i.zeze.com/attachment/forum/201608/21/083953yktqrpalrfl4r4a0.jpg";
        model.userName = @"other";
        model.isSender = NO;
    }
    model.time = time;
    model.timeLenth = timeLenth;
    model.assetPath = [NSString stringWithFormat:@"%@/%@.caf",_username,time];
    
    [_array addObject:model];
//    [_tableView reloadData];
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_array.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    /// 更新数据库
    [self insertFMDBData:model];
    
}

/// 发图片消息
- (void)sendImageMessage{
    
    static int k = 0;
    
    NSString *time = [self getCurrentTime];
    
    MLSelectPhotoPickerViewController *picker = [[MLSelectPhotoPickerViewController alloc] init];
    picker.status = PickerViewShowStatusCameraRoll;
    [picker showPickerVc:self];
    __weak ChatViewController *weakSelf = self;
    picker.callBack = ^(NSArray *assets){
        for (MLSelectPhotoAssets *image in assets) {
            /// 发给服务器
            ChatModel *model = [[ChatModel alloc] init];
            model.messageType = ChatCellType_Image;
            if (k == 0) {
                model.headImageUrl = @"http://up.qqjia.com/z/25/tu32695_14.jpg";
                model.userName = @"self";
                model.isSender = YES;
                k = 1;
            }
            else{
                k = 0;
                model.headImageUrl = @"http://i.zeze.com/attachment/forum/201608/21/083953yktqrpalrfl4r4a0.jpg";
                model.userName = @"other";
                model.isSender = NO;
            }
            model.time = time;
           
            UIImage *newImage = [image originImage];
            model.url = @"http://img10.360buyimg.com/imgzone/jfs/t1657/189/205188340/215968/eddc2d8a/557e94abN205fdd7b.jpg";
            model.height = 100;
            model.width = newImage.size.width*100.0/newImage.size.height;
            
            [weakSelf.array addObject:model];
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_array.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [_tableView endUpdates];
            
            [weakSelf insertFMDBData:model];
        }
//        [_tableView reloadData];
//        if (_array.count >= 1) {
//            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    };
}

/// 发文本消息
- (void)sendTextMessage:(NSDictionary *)userInfo{
    
    NSString *time = [self getCurrentTime];
    NSString *headImageUrl = nil;
    ChatModel *model = [[ChatModel alloc] init];
    _isSelf = !_isSelf;
    if (_isSelf) {
        headImageUrl = @"http://up.qqjia.com/z/25/tu32695_14.jpg";
        model.userName = @"self";
    }
    else{
        headImageUrl = @"http://i.zeze.com/attachment/forum/201608/21/083953yktqrpalrfl4r4a0.jpg";
        model.userName = @"other";
    }
    model.isSender = _isSelf;
    model.headImageUrl = headImageUrl;
    model.messageType = [userInfo[@"type"] integerValue];
    model.content = userInfo[@"content"];
    model.time = time;
    
    /// 放入数组 更新界面
//    [_array addObject:model];
    
//    [_tableView reloadData];
//
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
   
    [_array addObject:model];
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_array.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    /// 更新数据库
    [self insertFMDBData:model];
    
    /// 发送到服务器
    NSDictionary *dict = @{@"user":@{@"id":@"ios",@"name":@"ios"},@"msg":@{@"type":@(ChatCellType_Text),@"content":model.content}};
    [self sendPrivateMessageToServer:dict];

}
- (void)sendFaceMessage:(NSDictionary *)userInfo{
    
    NSString *time = [self getCurrentTime];
    NSString *headImageUrl = nil;
    ChatModel *model = [[ChatModel alloc] init];
    _isSelf = !_isSelf;
    if (_isSelf) {
        headImageUrl = @"http://up.qqjia.com/z/25/tu32695_14.jpg";
        model.userName = @"self";
    }
    else{
        headImageUrl = @"http://i.zeze.com/attachment/forum/201608/21/083953yktqrpalrfl4r4a0.jpg";
        model.userName = @"other";
    }
    model.isSender = _isSelf;
    model.headImageUrl = headImageUrl;
    model.messageType = [userInfo[@"type"] integerValue];
    model.content = userInfo[@"content"];
    model.time = time;
    
    /// 放入数组 更新界面
    [_array addObject:model];
    
//    [_tableView reloadData];
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_array.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_array.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self insertFMDBData:model];
    
}


#pragma mark - 私有方法

/// 获得当前时间 格式是2017-05-06-12-14-23
- (NSString *)getCurrentTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
    NSString *time = [dateFormatter stringFromDate:date];
    return time;
}

- (TextBackgroundView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[TextBackgroundView alloc] init];
    }
    return _backgroundView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = ([UIColor colorWithRed:0.773 green:0.855 blue:0.824 alpha:1]);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_tableView addGestureRecognizer:tap];
        
    }
    return _tableView;
}
- (void)tap{
    [_backgroundView resignTextViewFirstResponder];
}

#pragma mark - 导航条
- (UIView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.text = _username;
        [_navigationView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(300);
            make.bottom.mas_equalTo(-5);
            make.height.mas_equalTo(30);
        }];
        
        
        _navigationView.backgroundColor = [UIColor lightGrayColor];
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"common_btn_fanhui"] forState:UIControlStateNormal];
        backButton.titleLabel.textColor = [UIColor blackColor];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(24);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
    }
    return _navigationView;
}



- (void)back{
    
//    ChatModel *model = [_dbManager queryOneDataWithUsername:@"username" byNumberID:3];
//    if (model.content) {
//        NSLog(@"查出成功 %@",model.content);
//    }
//    
//    model.content = @"这是更新的内容";
//    BOOL success = [_dbManager updateOneDataWithUsername:@"username" model:model byNumberID:3];
//    if(success){
//        NSLog(@"更新成功");
//    }
//
//   BOOL success = [_dbManager deleteOneDataWithUsername:@"username" byNumberID:1];
//    if (success) {
//        NSLog(@"删除成功");
//    }
//    
//   ChatModel * newmodel = [_dbManager queryOneDataWithUsername:@"username" byNumberID:3];
//    if (newmodel.content) {
//        NSLog(@"查出成功 %@",newmodel.content);
//    }

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc{
    [self removeNotification];
    NSLog(@"viewcontroller dealloc");
}




@end
