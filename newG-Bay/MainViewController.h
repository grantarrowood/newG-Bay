//
//  MainViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 8/21/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"
@import Firebase;



@interface MainViewController : UIViewController <SlideNavigationControllerDelegate, UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;


@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)pageChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *trendingImageViewOne;
@property (weak, nonatomic) IBOutlet UILabel *trendingLabelOne;
@property (weak, nonatomic) IBOutlet UIImageView *trendingImageViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *trendingLabelTwo;
@property (weak, nonatomic) IBOutlet UIImageView *trendingImageViewThree;
@property (weak, nonatomic) IBOutlet UILabel *trendingLabelThree;
- (IBAction)trendingActionOne:(id)sender;
- (IBAction)trendingActionTwo:(id)sender;
- (IBAction)trendingActionThree:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *feedbackOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackThreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackOnePersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackTwoPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackThreePersonLabel;
- (IBAction)feedbackActionOne:(id)sender;
- (IBAction)feedbackActionTwo:(id)sender;
- (IBAction)feedbackActionThree:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *tokenPersonOne;
@property (weak, nonatomic) IBOutlet UILabel *tokenPersonTwo;
@property (weak, nonatomic) IBOutlet UILabel *tokenPersonThree;
@property (weak, nonatomic) IBOutlet UILabel *tokenCountOne;
@property (weak, nonatomic) IBOutlet UILabel *tokenCountTwo;
@property (weak, nonatomic) IBOutlet UILabel *tokenCountThree;
- (IBAction)tokenActionOne:(id)sender;
- (IBAction)tokenActionTwo:(id)sender;
- (IBAction)tokenActionThree:(id)sender;


@end
