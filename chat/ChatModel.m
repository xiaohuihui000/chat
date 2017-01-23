//
//  ChatModel.m
//  chat
//
//  Created by chenguanghui on 17/1/6.
//  Copyright © 2017年 chenguanghui. All rights reserved.
//

#import "ChatModel.h"

@interface ChatModel ()<NSCoding>

@end

@implementation ChatModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:[NSNumber numberWithInteger:self.messageType] forKey:@"messageType"];
    
    [aCoder encodeObject:self.headImageUrl forKey:@"headImageUrl"];
    
    [aCoder encodeObject:self.time forKey:@"time"];
    
    [aCoder encodeObject:[NSNumber numberWithBool:self.isSender] forKey:@"isSender"];
    
    [aCoder encodeObject:self.userName forKey:@"userName"];
    
    
    [aCoder encodeObject:self.content forKey:@"content"];
    
    [aCoder encodeObject:self.url forKey:@"imageUrl"];
    
    [aCoder encodeObject:[NSNumber numberWithFloat:self.height] forKey:@"weight"];
    
    [aCoder encodeObject:[NSNumber numberWithFloat:self.width] forKey:@"width"];
    
   
    
    [aCoder encodeObject:[NSNumber numberWithDouble:(self.timeLenth)] forKey:@"timeLenth"];
    
    
    [aCoder encodeObject:self.assetUrl forKey:@"assetUrl"];
    
    [aCoder encodeObject:self.assetPath forKey:@"assetPath"];
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.messageType = [[aDecoder decodeObjectForKey:@"messageType"] integerValue];
        
        self.headImageUrl = [aDecoder decodeObjectForKey:@"headImageUrl"];
        
        self.time = [aDecoder decodeObjectForKey:@"time"];
        
        self.isSender = [[aDecoder decodeObjectForKey:@"isSender"] boolValue];

        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        
        
        self.content = [aDecoder decodeObjectForKey:@"content"];
        
        self.url = [aDecoder decodeObjectForKey:@"url"];
        
        self.height =[[aDecoder decodeObjectForKey:@"height"] floatValue];
        
        self.width = [[aDecoder decodeObjectForKey:@"width"] floatValue];
        
        
        
        self.timeLenth = [[aDecoder decodeObjectForKey:@"timeLenth"] doubleValue];
        
        self.assetUrl = [aDecoder decodeObjectForKey:@"assetUrl"];
        
        self.assetPath = [aDecoder decodeObjectForKey:@"assetPath"];
        
        
    }
    return self;
}

@end



















