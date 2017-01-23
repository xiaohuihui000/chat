//
//  SooonerSocketUtils.h
//  SNSocket
//
//  Created by 吴贤德 on 2016/12/8.
//  Copyright © 2016年 Soooner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SooonerSocketUtils : NSObject

+ (NSString*)getmd5WithString:(NSString *)string;

+ (NSString*)getMD5WithData:(NSData *)data;

+(NSString*)getFileMD5WithPath:(NSString*)path;

@end
