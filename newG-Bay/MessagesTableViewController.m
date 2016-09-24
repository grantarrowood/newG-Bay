//
//  MessagesTableViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 9/23/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "MessagesTableViewController.h"
#import "ConversationViewController.h"
#import "SlideNavigationController.h"
#import "ConversationTableViewCell.h"
#import "MessagingParticipantTableViewController.h"

@interface MessagesTableViewController ()
{
    FIRDatabaseHandle _refHandle;
    FIRDatabaseHandle _refHandle2;
    NSString *msgFrom;
    NSDictionary *contentsTotal;
    int messager;
}
@end

@implementation MessagesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController setNavigationBarHidden:NO];
    _objects = [[NSMutableArray alloc] init];
    _objects2 = [[NSMutableArray alloc] init];
    //[_clientTable registerClass:UITableViewCell.self forCellReuseIdentifier:@"tableViewCell"];
    [self configureDatabase];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(handleAddTap)];
    self.navigationItem.rightBarButtonItem = addItem;
    
}

- (void)handleAddTap
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessagingParticipantTableViewController *destViewController = (MessagingParticipantTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MessagingParticipantTableViewController"];
    [[NSUserDefaults standardUserDefaults] setObject:@"MessagingParticipantTableViewController"
                                              forKey:@"last_view"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:destViewController
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
}

- (void)configureDatabase {
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/messages"];
    _refHandle = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary<NSString *, NSString *> *object = snapshot.value;
        NSString *messageBetween = object[@"msgBT"];
        NSArray *items = [messageBetween componentsSeparatedByString:@","];
        
        if ([items[0] isEqualToString:[FIRAuth auth].currentUser.uid]) {
            [_objects addObject:snapshot];
            [_messagesTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
            messager = 1;
        } else if([items[1] isEqualToString:[FIRAuth auth].currentUser.uid]) {
            [_objects addObject:snapshot];
            [_messagesTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]] withRowAnimation: UITableViewRowAnimationAutomatic];
            messager = 0;
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_objects count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationTableViewCell *cell = (ConversationTableViewCell *)[_messagesTableView dequeueReusableCellWithIdentifier:@"messageCell" forIndexPath:indexPath];
    // Configure the cell...
    // Unpack message from Firebase DataSnapshot
    FIRDataSnapshot *objectSnapshot = _objects[indexPath.row];
    NSDictionary<NSString *, NSString *> *object = objectSnapshot.value;
    NSString *messageBetween = object[@"msgBT"];
    NSArray *items = [messageBetween componentsSeparatedByString:@","];
    
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/users"];
    _refHandle2 = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary<NSString *, NSString *> *object2 = snapshot.value;
        if ([snapshot.key isEqualToString:items[messager]]) {
            [_objects2 addObject:snapshot];
            cell.toLabel.text = object2[@"userName"];
        } else {
        }
    }];
    contentsTotal = object[@"contents"];
    NSString *lastContent = [NSString stringWithFormat:@"msg%lu",(unsigned long)contentsTotal.count-1];
    NSDictionary *contents = contentsTotal[lastContent];
    cell.latestMessageLabel.text = contents[@"title"];
    cell.dateLabel.text = contents[@"date"];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FIRDataSnapshot *objectSnapshot = _objects2[indexPath.row];
    NSDictionary<NSString *, NSString *> *object = objectSnapshot.value;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ConversationViewController *destViewController = (ConversationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ConversationViewController"];
    destViewController.msgData = contentsTotal;
    destViewController.title = object[@"userName"];
    destViewController.toString = objectSnapshot.key;
    [[NSUserDefaults standardUserDefaults] setObject:@"MessagesTableViewController"
                                              forKey:@"last_view"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:destViewController
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
