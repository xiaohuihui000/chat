//
//  FMDBManager.m
//  chat
//
//  Created by chenguanghui on 17/1/12.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "FMDBManager.h"
#import <UIKit/UIKit.h>
#import "WHMD5.h"
#import "faceView.h"



@interface FMDBManager ()

@property(nonatomic , strong) FMDatabase *db;




@end



@implementation FMDBManager


+(instancetype)initialization{
    static dispatch_once_t onceToken;
    static FMDBManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[FMDBManager alloc] init];
    });
    return manager;
}
/// 删除表
- (BOOL)deleteAllDataWithUsername:(NSString *)username{
    BOOL success = [_db executeUpdateWithFormat:@"DELETE FROM %@",username];
    if (!success) {
        NSLog(@"删除表失败");
    }
    return success;
}
- (BOOL)updateOneDataWithUsername:(NSString *)username model:(ChatModel *)model byNumberID:(NSInteger)numberID{
    BOOL success = [_db executeUpdateWithFormat:@"UPDATE %@ SET messageType=%ld ,headImageUrl=%@ ,time=%@ ,userName=%@ ,isSender=%d ,content=%@ ,url=%@ ,height=%f ,width=%f ,timeLenth=%f ,assetUrl=%@ ,assetPath=%@ WHERE numberID=%ld",username,model.messageType,model.headImageUrl,model.time,model.userName,model.isSender,model.content,model.url,model.height,model.width,model.timeLenth,model.assetUrl,model.assetPath,numberID];
    if (!success) {
        NSLog(@"更新失败");
    }
    return success;
}

/// 删除一条数据
- (BOOL)deleteOneDataWithUsername:(NSString *)username byNumberID:(NSInteger)numberID{
    BOOL success = [_db executeUpdate:[NSString stringWithFormat:@"DELETE  FROM %@ WHERE numberID = %ld",username,numberID]];
    if (!success) {
        NSLog(@"删除一条数据失败");
    }
    return success;
}

/// 增加一条数据
- (BOOL)increaseDataFromUserName:(NSString *)userName withModel:(ChatModel *)model{
    
    
    model = [self changeWithoutNil:model];

    
    NSString *sqlite = [NSString stringWithFormat:@"INSERT INTO %@(messageType,headImageUrl,time,userName,isSender,content,url,height,width,timeLenth,assetUrl,assetPath) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",userName];
    
    NSArray *array = @[@(model.messageType),model.headImageUrl,model.time,model.userName,@(model.isSender),model.content,model.url,@(model.height),@(model.width),@(model.timeLenth),model.assetUrl,model.assetPath];
    
    BOOL success = [_db executeUpdate:sqlite withArgumentsInArray:array];
    if (!success) {
        NSLog(@"插入数据失败");
    }
    return success;
}

- (ChatModel *)changeWithoutNil:(ChatModel *)model{
    if (model.headImageUrl == nil) {
        model.headImageUrl = @"";
    }
    if (model.time == nil) {
        model.time = @"";
    }
    if (model.userName == nil) {
        model.userName = @"";
    }
    if (model.content == nil) {
        model.content = @"";
    }
    if (model.url == nil) {
        model.url = @"";
    }
    if (model.assetUrl == nil) {
        model.assetUrl = @"";
    }
    if (model.assetPath == nil) {
        model.assetPath = @"";
    }

    return model;
}


/// 查找一条数据 根据numberID
- (ChatModel *)queryOneDataWithUsername:(NSString *)username byNumberID:(NSInteger)numberID{
    NSString *sqliteSentence = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE numberID = %ld",username,numberID];
    FMResultSet *sesultSet = [_db executeQuery:sqliteSentence];
    ChatModel *model = [[ChatModel alloc] init];
    while ([sesultSet next]) {
        NSInteger messageType = [sesultSet intForColumn:@"messageType"];
        NSString *headImageUrl = [sesultSet stringForColumn:@"headImageUrl"];
        NSString *time = [sesultSet stringForColumn:@"time"];
        NSString *username = [sesultSet stringForColumn:@"username"];
        BOOL isSender = [sesultSet boolForColumn:@"issender"];
        NSString *content = [sesultSet stringForColumn:@"content"];
        NSString *url = [sesultSet stringForColumn:@"url"];
        double height = [sesultSet doubleForColumn:@"height"];
        double width = [sesultSet doubleForColumn:@"width"];
        NSTimeInterval timeLenth =[sesultSet doubleForColumn:@"timeLenth"];
        NSString *assetUrl = [sesultSet stringForColumn:@"assetUrl"];
        NSString *assetPath = [sesultSet stringForColumn:@"assetPath"];
        
        ChatModel *model = [[ChatModel alloc] init];
        model.messageType = messageType;
        model.headImageUrl = headImageUrl;
        model.time = time;
        model.userName = username;
        model.isSender = isSender;
        model.content = content;
        model.url = url;
        model.width = width;
        model.height = height;
        model.timeLenth = timeLenth;
        model.assetUrl = assetUrl;
        model.assetPath = assetPath;

    }
    return model;

}

/// 查找所有的数据
- (NSArray *)queryAllDataWithUsername:(NSString *)username{
    NSMutableArray *array = [NSMutableArray array];
    NSString *sqliteSentence = [NSString stringWithFormat:@"SELECT * FROM %@",username];
    FMResultSet *sesultSet = [_db executeQuery:sqliteSentence];
    while ([sesultSet next]) {
        NSInteger messageType = [sesultSet intForColumn:@"messageType"];
        NSString *headImageUrl = [sesultSet stringForColumn:@"headImageUrl"];
        NSString *time = [sesultSet stringForColumn:@"time"];
        NSString *username = [sesultSet stringForColumn:@"username"];
        BOOL isSender = [sesultSet boolForColumn:@"issender"];
        NSString *content = [sesultSet stringForColumn:@"content"];
        NSString *url = [sesultSet stringForColumn:@"url"];
        double height = [sesultSet doubleForColumn:@"height"];
        double width = [sesultSet doubleForColumn:@"width"];
        NSTimeInterval timeLenth =[sesultSet doubleForColumn:@"timeLenth"];
        NSString *assetUrl = [sesultSet stringForColumn:@"assetUrl"];
        NSString *assetPath = [sesultSet stringForColumn:@"assetPath"];
        
        ChatModel *model = [[ChatModel alloc] init];
        model.messageType = messageType;
        model.headImageUrl = headImageUrl;
        model.time = time;
        model.userName = username;
        model.isSender = isSender;
        model.content = content;
        model.url = url;
        model.width = width;
        model.height = height;
        model.timeLenth = timeLenth;
        model.assetUrl = assetUrl;
        model.assetPath = assetPath;
        [array addObject:model];
    }
    return array;
}

/// 打开数据库 username 表名
- (BOOL)openFMDBSqliteWithUsername:(NSString *)username{
    
    _db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@sqlite",KBasePath]];
    NSLog(@"路径 %@",KBasePath);
    if (![_db open]) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    NSString *sqliteSentence = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(numberID integer PRIMARY KEY AUTOINCREMENT ,messageType integer ,headImageUrl text , time text ,username text ,isSender bool ,content text ,url text ,height double ,width double ,timeLenth double ,assetUrl text,assetPath text)",username];
    BOOL success = [_db executeUpdate:sqliteSentence];
    if (!success) {
        NSLog(@"创建表失败");
    }
    return success;
}

- (void)dealloc{
    [_db close];
    _db = nil;
    NSLog(@"FMDBManager dealloc");
}

@end
