//
//  ContentManager.h
//  SOSimpleChatDemo
//
// Created by : arturdev
// Copyright (c) 2014 SocialObjects Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface ContentManager : NSObject

+ (ContentManager *)sharedManager:(NSDictionary *)data;

- (NSArray *)generateConversation:(NSDictionary *)messageData;

@end
