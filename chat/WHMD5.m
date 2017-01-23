//
//  WHMD5.m
//  MD5
//
//  Created by smjl on 16/1/28.
//  Copyright © 2016年 wahool. All rights reserved.
//

#import "WHMD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation WHMD5

//字符串的md5
+ (NSString *)MD5OfNSString:(NSString *)string{
    const char *str = [string UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *stringMD5 = [NSString stringWithFormat:
                        @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                        r[11], r[12], r[13], r[14], r[15]
                        ];
    
    return stringMD5;
}
//二进制的数据MD5
+ (NSString *)MD5OfUIImage:(NSData *)imageData{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([imageData bytes],(CC_LONG)[imageData length], result);
    NSString *imageDataMD5 = [NSString stringWithFormat:
                        @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15]
                        ];
    return imageDataMD5;
}














+(NSString *)base64EncodeString:(NSString *)string

{
    
    //1.先把字符串转换为二进制数据
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    //2.对二进制数据进行base64编码，返回编码后的字符串
    
    return [data base64EncodedStringWithOptions:0];
    
}



//对base64编码后的字符串进行解码

+(NSString *)base64DecodeString:(NSString *)string

{
    
    //1.将base64编码后的字符串『解码』为二进制数据
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    
    
    
    //2.把二进制数据转换为字符串返回
    
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
}













@end
