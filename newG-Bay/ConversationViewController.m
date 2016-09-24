//
//  ConversationViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 9/22/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "ConversationViewController.h"
#import "ContentManager.h"
#import "Message.h"

@interface ConversationViewController () 
{
    FIRDatabaseHandle _refHandle;
    FIRDatabaseHandle _refHandle2;
    NSString *msgFrom;
    NSDictionary *contentsTotal;
    int messager;
}
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ConversationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMessages];

}
- (void)loadMessages
{
    self.dataSource = [[[ContentManager sharedManager:_msgData] generateConversation:_msgData] mutableCopy];
}

#pragma mark - SOMessaging data source
- (NSMutableArray *)messages
{
    return self.dataSource;
    
}

- (NSTimeInterval)intervalForMessagesGrouping
{
    // Return 0 for disableing grouping
    return 0;
}

- (void)configureMessageCell:(SOMessageCell *)cell forMessageAtIndex:(NSInteger)index
{
    Message *message = self.dataSource[index];
    
    // Adjusting content for 3pt. (In this demo the width of bubble's tail is 6pt)
    if (!message.fromMe) {
        cell.contentInsets = UIEdgeInsetsMake(0, 3.0f, 0, 0); //Move content for 3 pt. to right
        cell.textView.textColor = [UIColor blackColor];
    } else {
        cell.contentInsets = UIEdgeInsetsMake(0, 0, 0, 3.0f); //Move content for 3 pt. to left
        cell.textView.textColor = [UIColor whiteColor];
    }
}

#pragma mark - SOMessaging delegate
- (void)didSelectMedia:(NSData *)media inMessageCell:(SOMessageCell *)cell
{
    // Show selected media in fullscreen
    [super didSelectMedia:media inMessageCell:cell];
}

- (void)messageInputView:(SOMessageInputView *)inputView didSendMessage:(NSString *)message
{
    if (![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return;
    }
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/messages"];
    NSString *lastContent = [NSString stringWithFormat:@"msg%lu",(unsigned long)_msgData.count];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *inside = [[NSMutableDictionary alloc]init];
    [inside setObject:@"9/17/16" forKey:@"date"];
    [inside setObject:[FIRAuth auth].currentUser.uid forKey:@"msgTo"];
    [inside setObject:@"915" forKey:@"time"];
    [inside setObject:message forKey:@"title"];
    if (_msgData == nil) {
        [[ref childByAutoId] setValue:@{@"msgBT": [NSString stringWithFormat:@"%@,%@",[FIRAuth auth].currentUser.uid,_toString], @"contents": @{@"msg0":inside}}];
        //_msgData = @{@"contents": @{@"msg0":inside}};
        NSMutableDictionary *m = [[NSMutableDictionary alloc]init];
        [m setObject:inside forKey:@"msg0"];
        _msgData = m;
       // dict = _msgData;
    } else {
        dict = _msgData;
    }
    [dict setObject:inside forKey:lastContent];
    
    Message *msg = [[Message alloc] init];
    msg.text = message;
    msg.fromMe = YES;
    _refHandle = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        if(_msgData == nil){
        } else {
            NSDictionary<NSString *, NSString *> *object = snapshot.value;
            NSString *messageBetween = object[@"msgBT"];
            NSArray *items = [messageBetween componentsSeparatedByString:@","];
            NSString *key = snapshot.key;
            if ([items[0] isEqualToString:[FIRAuth auth].currentUser.uid] && [items[1] isEqualToString:_toString]) {
                [_objects addObject:snapshot];
                NSDictionary *childUpdates = @{[[@"/" stringByAppendingString:key] stringByAppendingString:@"/contents/"]: dict};
                [ref updateChildValues:childUpdates];
            } else if([items[1] isEqualToString:[FIRAuth auth].currentUser.uid] && [items[0] isEqualToString:_toString]) {
                [_objects addObject:snapshot];
                NSDictionary *childUpdates = @{[[@"/" stringByAppendingString:key] stringByAppendingString:@"/contents/"]: dict};
                [ref updateChildValues:childUpdates];
            }
        }

    }];
    
    
    [self sendMessage:msg];
}

- (void)messageInputViewDidSelectMediaButton:(SOMessageInputView *)inputView
{
    // Take a photo/video or choose from gallery
}

@end
