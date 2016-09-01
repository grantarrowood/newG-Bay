//
//  MainViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 8/21/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "MainViewController.h"
#import "LeftMenuViewController.h"
@import FirebaseAuth;

@interface MainViewController ()
{
    FIRDatabaseHandle _refHandle;
    UIImage *theImage;
    int viewValue1;
    int viewValue2;
    int viewValue3;
    int feedbackValue1;
    int feedbackValue2;
    int feedbackValue3;
    int tokenValue1;
    int tokenValue2;
    int tokenValue3;
}
@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.scrollview.delegate=self;

    [self.scrollview setContentSize:CGSizeMake(self.scrollview.frame.size.width*3, self.scrollview.frame.size.height-88)];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    _objects = [[NSMutableArray alloc] init];
    
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    _refHandle = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [_objects addObject:snapshot];
        NSDictionary<NSString *, NSString *> *object = snapshot.value;
        
        NSString *viewValues = object[@"views"];
        NSString *imageString = object[@"imageUrl"];
        
        // ******************************************************VIEWS****************************************************************
        
        
        
        if (viewValues.intValue > viewValue1) {
            if (self.trendingLabelTwo.text == nil) {
                self.trendingLabelTwo.text = self.trendingLabelOne.text;
                viewValue2 = viewValue1;
            } else {
                self.trendingLabelThree.text = self.trendingLabelTwo.text;
                viewValue3 = viewValue2;
                self.trendingLabelTwo.text = self.trendingLabelOne.text;
                viewValue2 = viewValue1;
            }
            
            NSString *title = object[@"title"];
            self.trendingLabelOne.text = title;
            
            
            //            if (imageString == nil) {
            //            } else {
            //                FIRStorage *storage = [FIRStorage storage];
            //                // Create a storage reference from our storage service
            //                FIRStorageReference *storageRef = [storage referenceForURL:imageString];
            //
            //                [storageRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
            //                    if (error != nil) {
            //                        // Uh-oh, an error occurred!
            //                        NSLog(@"Error Downloading: %@", error);
            //                    } else {
            //                            theImage = [UIImage imageWithData:data];
            //                            self.trendingImageViewOne.image = theImage;
            //                    }
            //                }];
            //            }
            viewValue1 = viewValues.intValue;
            
            
            
        } else if (viewValues.intValue > viewValue2) {
            self.trendingLabelThree.text = self.trendingLabelTwo.text;
            viewValue3 = viewValue2;
            NSString *title = object[@"title"];
            self.trendingLabelTwo.text = title;
            
            
            //            if (imageString == nil) {
            //            } else {
            //                FIRStorage *storage = [FIRStorage storage];
            //                // Create a storage reference from our storage service
            //                FIRStorageReference *storageRef = [storage referenceForURL:imageString];
            //
            //                [storageRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
            //                    if (error != nil) {
            //                        // Uh-oh, an error occurred!
            //                        NSLog(@"Error Downloading: %@", error);
            //                    } else {
            //                        theImage = [UIImage imageWithData:data];
            //                        self.trendingImageViewTwo.image = theImage;
            //                    }
            //                }];
            //            }
            viewValue2 = viewValues.intValue;
            
        } else if (viewValues.intValue > viewValue3) {
            NSString *title = object[@"title"];
            self.trendingLabelThree.text = title;
            
            
            //            if (imageString == nil) {
            //            } else {
            //                FIRStorage *storage = [FIRStorage storage];
            //                // Create a storage reference from our storage service
            //                FIRStorageReference *storageRef = [storage referenceForURL:imageString];
            //
            //                [storageRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
            //                    if (error != nil) {
            //                        // Uh-oh, an error occurred!
            //                        NSLog(@"Error Downloading: %@", error);
            //                    } else {
            //                        theImage = [UIImage imageWithData:data];
            //                        self.trendingImageViewThree.image = theImage;
            //                    }
            //                }];
            //            }
            viewValue3 = viewValues.intValue;
            
            
        }
    }];
    
    
    ref = [[FIRDatabase database] referenceWithPath:@"/users"];
    _refHandle = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [_objects addObject:snapshot];
        NSDictionary<NSString *, NSString *> *object = snapshot.value;
        NSString *feedbackPositive = object[@"feedbackPositive"];
        NSString *feedbackNegative = object[@"feedbackNegative"];
        NSString *tokenCount = object[@"tokenCount"];
        
        float feedbackFloat = (feedbackPositive.intValue + feedbackNegative.intValue);
        float feedbackPercent = ((feedbackPositive.intValue)/feedbackFloat)*100;
        
        // ******************************************************FEEDBACK!!****************************************************************
        
        
        if (feedbackPercent > feedbackValue1) {
            if (self.feedbackTwoPersonLabel.text == nil) {
                self.feedbackTwoPersonLabel.text = self.feedbackOnePersonLabel.text;
                self.feedbackTwoLabel.text = self.feedbackOneLabel.text;
                feedbackValue2 = feedbackValue1;
            } else {
                self.feedbackThreePersonLabel.text = self.feedbackTwoPersonLabel.text;
                self.feedbackThreeLabel.text = self.feedbackTwoLabel.text;
                feedbackValue1 = feedbackValue2;
                self.feedbackTwoPersonLabel.text = self.feedbackOnePersonLabel.text;
                self.feedbackTwoLabel.text = self.feedbackOneLabel.text;
                feedbackValue2 = feedbackValue1;
            }
            
            
            
            NSString *title = object[@"firstName"];
            self.feedbackOnePersonLabel.text = title;
            self.feedbackOneLabel.text = [NSString stringWithFormat:@"%.0f%%", feedbackPercent];
            feedbackValue1 = feedbackPercent;
            
            
            
        } else if (feedbackPercent > feedbackValue2) {
            self.feedbackThreePersonLabel.text = self.feedbackTwoPersonLabel.text;
            self.feedbackThreeLabel.text = self.feedbackTwoLabel.text;
            feedbackValue3 = feedbackValue2;
            
            
            
            NSString *title = object[@"firstName"];
            self.feedbackTwoPersonLabel.text = title;
            self.feedbackTwoLabel.text = [NSString stringWithFormat:@"%.0f%%", feedbackPercent];
            
            feedbackValue2 = feedbackPercent;
            
        } else if (feedbackPercent > feedbackValue3) {
            NSString *title = object[@"firstName"];
            self.feedbackThreePersonLabel.text = title;
            self.feedbackThreeLabel.text = [NSString stringWithFormat:@"%.0f%%", feedbackPercent];
            
            feedbackValue3 = feedbackPercent;
            
            
        }
        
        
        // ******************************************************TOKENS****************************************************************
        
        
        
        if (tokenCount.intValue > tokenValue1) {
            if (self.tokenPersonTwo.text == nil) {
                self.tokenPersonTwo.text = self.tokenPersonOne.text;
                self.tokenCountTwo.text = self.tokenCountOne.text;
                tokenValue2 = tokenValue1;
            } else {
                self.tokenPersonThree.text = self.tokenPersonTwo.text;
                self.tokenCountThree.text = self.tokenCountTwo.text;
                tokenValue3 = tokenValue2;
                self.tokenPersonTwo.text = self.tokenPersonOne.text;
                self.tokenCountTwo.text = self.tokenCountOne.text;
                tokenValue2 = tokenValue1;
            }
            
            
            
            NSString *title = object[@"firstName"];
            self.tokenPersonOne.text = title;
            self.tokenCountOne.text = [NSString stringWithFormat:@"%d", tokenCount.intValue];
            tokenValue1 = tokenCount.intValue;
            
            
            
        } else if (tokenCount.intValue > tokenValue2) {
            self.tokenPersonThree.text = self.tokenPersonTwo.text;
            self.tokenCountThree.text = self.tokenCountTwo.text;
            tokenValue3 = tokenValue2;
            
            
            
            NSString *title = object[@"firstName"];
            self.tokenPersonTwo.text = title;
            self.tokenCountTwo.text = [NSString stringWithFormat:@"%d", tokenCount.intValue];
            
            tokenValue2 = tokenCount.intValue;
            
        } else if (tokenCount.intValue > tokenValue3) {
            NSString *title = object[@"firstName"];
            self.tokenPersonThree.text = title;
            self.tokenCountThree.text = [NSString stringWithFormat:@"%d", tokenCount.intValue];
            
            tokenValue3 = tokenCount.intValue;
            
            
        }
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView{
    
    CGFloat viewWidth = _scrollView.frame.size.width;
    // content offset - tells by how much the scroll view has scrolled.
    
    int pageNumber = floor((_scrollView.contentOffset.x - viewWidth/50) / viewWidth) +1;
    
    self.pageControl.currentPage=pageNumber;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}


- (IBAction)pageChanged:(id)sender
{
    int pageNumber = self.pageControl.currentPage;
    
    CGRect frame = self.scrollview.frame;
    frame.origin.x = frame.size.width*pageNumber;
    frame.origin.y=0;
    
    [self.scrollview scrollRectToVisible:frame animated:YES];
}
- (IBAction)trendingActionOne:(id)sender {
}

- (IBAction)trendingActionTwo:(id)sender {
}

- (IBAction)trendingActionThree:(id)sender {
}
- (IBAction)feedbackActionOne:(id)sender {
}

- (IBAction)feedbackActionTwo:(id)sender {
}

- (IBAction)feedbackActionThree:(id)sender {
}
- (IBAction)tokenActionOne:(id)sender {
}

- (IBAction)tokenActionTwo:(id)sender {
}

- (IBAction)tokenActionThree:(id)sender {
}
@end
