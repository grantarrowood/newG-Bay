//
//  ConversationViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 9/22/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SOMessagingViewController.h"
@import Firebase;

@interface ConversationViewController : SOMessagingViewController
@property (strong, nonatomic) NSDictionary *msgData;
@property (strong, nonatomic) NSString *toString;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects2;

@end
