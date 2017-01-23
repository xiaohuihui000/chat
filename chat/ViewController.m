//
//  ViewController.m
//  chat
//
//  Created by chenguanghui on 17/1/6.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "ViewController.h"
#import "chatHeader.pch"
#import "ChatViewController.h"
#import "WHMD5.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController
{
    UITableView *_tableView;
    
    CGFloat bottom ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREENWIDTH , SCREENHEIGHT)];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURL *URL = [NSURL URLWithString:@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSString *md5Path = [WHMD5 MD5OfNSString:@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg"];
//    
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        
//        return [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"/Users/cgh/Desktop/%@.jpg",md5Path]];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: %@", filePath);
//    }];
//    //开始下载
//    [downloadTask resume];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/sqlite",NSHomeDirectory()] error:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableview"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableview"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"聊天 %ld",indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *controller = [[ChatViewController alloc] init];
    controller.username = @"ios";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
