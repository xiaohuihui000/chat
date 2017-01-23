//
//  FMDBManager.h
//  chat
//
//  Created by chenguanghui on 17/1/12.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import <Foundation/Foundation.h>



#define KBasePath ([NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()])


@interface FMDBManager : NSObject

/// 单例初始化
+(instancetype)initialization;

/// 打开数据库 username 表名
- (BOOL)openFMDBSqliteWithUsername:(NSString *)username;


/// 增加一条数据
- (BOOL)increaseDataFromUserName:(NSString *)userName withModel:(ChatModel *)model;
/// 查找所有的数据
- (NSArray<ChatModel *> *)queryAllDataWithUsername:(NSString *)username;
/// 查找一条数据 根据numberID
- (ChatModel *)queryOneDataWithUsername:(NSString *)username byNumberID:(NSInteger)numberID;
/// 删除一条数据
- (BOOL)deleteOneDataWithUsername:(NSString *)username byNumberID:(NSInteger)numberID;
/// 更新一条数据
- (BOOL)updateOneDataWithUsername:(NSString *)username model:(ChatModel *)model byNumberID:(NSInteger)numberID;

/// 删除表
- (BOOL)deleteAllDataWithUsername:(NSString *)username;


@end
