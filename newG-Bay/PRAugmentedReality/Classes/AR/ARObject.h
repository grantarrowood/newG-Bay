//
//  ARObject.h
//  PrometAR
//
// Created by Geoffroy Lesage on 4/24/13.
// Copyright (c) 2013 Promet Solutions Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "ARSettings.h"
#import "DetailsViewController.h"
#import <Firebase/Firebase.h>
@import FirebaseDatabase;
@import FirebaseAuth;


@interface ARObject : UIViewController
{
    
    // ARObject main components
    NSString *arTitle;
    NSMutableString *arDescription;
    NSString *arCondition;
    NSNumber *arPrice;
    NSString *arCategory;
    
    int arId;
    NSString *stringId;
    double lat;
    double lon;
    NSNumber *distance;
    
    // Overlay View Objects
    IBOutlet UILabel *titleL;
    IBOutlet UILabel *distanceL;
}

@property (nonatomic, strong) NSString *arTitle;
@property (nonatomic, strong) NSNumber *distance;
@property (weak, nonatomic) IBOutlet UIImageView *arImage;


- (IBAction)didTouchObject:(id)sender;

- (id)initWithId:(int)newId
           title:(NSString*)newTitle
     coordinates:(CLLocationCoordinate2D)newCoordinates
 currentLocation:(CLLocationCoordinate2D)currLoc
      descrption:(NSString*)newDescrition
       condition:(NSString*)newCondition
           price:(NSNumber*)newPrice
        imageUrl:(NSString *)newImageUrl
     andCategory:(NSString*)newCategory;

- (id)initWithId:(NSString *)newId
           title:(NSString*)newTitle
     coordinates:(CLLocationCoordinate2D)newCoordinates
 currentLocation:(CLLocationCoordinate2D)currLoc;

- (NSDictionary*)getARObjectData;

@end
