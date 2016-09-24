//
//  ContentManager.m
//  SOSimpleChatDemo
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//

#import "ContentManager.h"
#import "Message.h"
#import "SOMessageType.h"

@implementation ContentManager

+ (ContentManager *)sharedManager:(NSDictionary *)data
{
    static ContentManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

- (NSArray *)generateConversation:(NSDictionary *)messsageData
{
    NSMutableArray *result = [NSMutableArray new];
    //NSArray *data = messsageData;
    //NSArray *data = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Conversation" ofType:@"plist"]]];
//    for (NSDictionary *msg in data[0]) {
//        Message *message = [[Message alloc] init];
//        if ([msg[@"msgTo"] isEqualToString:[FIRAuth auth].currentUser.uid]) {
//            message.fromMe = YES;
//        } else {
//            message.fromMe = NO;
//        }
//       // message.fromMe = [msg[@"fromMe"] boolValue];
//        message.text = msg[@"title"];
//        //message.type = [self messageTypeFromString:msg[@"type"]];
//        message.type = SOMessageTypeText;
//        message.date = [NSDate date];
//        
//        int index = (int)[data indexOfObject:msg];
//        if (index > 0) {
//            Message *prevMesage = result.lastObject;
//            message.date = [NSDate dateWithTimeInterval:((index % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
//        }
//        
//        if (message.type == SOMessageTypePhoto) {
//            message.media = UIImageJPEGRepresentation([UIImage imageNamed:msg[@"image"]], 1);
//        } else if (message.type == SOMessageTypeVideo) {
//            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:msg[@"video"] ofType:@"mp4"]];
//            message.thumbnail = [UIImage imageNamed:msg[@"thumbnail"]];
//        }
//
//        [result addObject:message];
//    }
    for (int i = 0; i < messsageData.count; i++) {
        NSString *lastContent = [NSString stringWithFormat:@"msg%d",i];
        NSDictionary *contents = messsageData[lastContent];
        Message *message = [[Message alloc] init];
        if ([contents[@"msgTo"] isEqualToString:[FIRAuth auth].currentUser.uid]) {
            message.fromMe = YES;
        } else {
            message.fromMe = NO;
        }
        // message.fromMe = [msg[@"fromMe"] boolValue];
        message.text = contents[@"title"];
        //message.type = [self messageTypeFromString:msg[@"type"]];
        message.type = SOMessageTypeText;
        message.date = [NSDate date];
        
        if (i > 0) {
            Message *prevMesage = result.lastObject;
            message.date = [NSDate dateWithTimeInterval:((i % 2) ? 2 * 24 * 60 * 60 : 120) sinceDate:prevMesage.date];
        }
        
        if (message.type == SOMessageTypePhoto) {
            message.media = UIImageJPEGRepresentation([UIImage imageNamed:contents[@"image"]], 1);
        } else if (message.type == SOMessageTypeVideo) {
            message.media = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:contents[@"video"] ofType:@"mp4"]];
            message.thumbnail = [UIImage imageNamed:contents[@"thumbnail"]];
        }
        
        [result addObject:message];
    }
    
    return result;
}

- (SOMessageType)messageTypeFromString:(NSString *)string
{
    if ([string isEqualToString:@"SOMessageTypeText"]) {
        return SOMessageTypeText;
    } else if ([string isEqualToString:@"SOMessageTypePhoto"]) {
        return SOMessageTypePhoto;
    } else if ([string isEqualToString:@"SOMessageTypeVideo"]) {
        return SOMessageTypeVideo;
    }

    return SOMessageTypeOther;
}

@end