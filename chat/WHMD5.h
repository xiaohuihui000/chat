//
//  WHMD5.h
//  MD5
//
//  Created by smjl on 16/1/28.
//  Copyright © 2016年 wahool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WHMD5 : NSObject

//字符串的md5
+ (NSString *)MD5OfNSString:(NSString *)string;
//二进制的数据MD5
+ (NSString *)MD5OfUIImage:(NSData *)imageData;




//// base64
+(NSString *)base64EncodeString:(NSString *)string;
+(NSString *)base64DecodeString:(NSString *)string;

@end
