//
//  ARObject.m
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

#import "ARObject.h"



@interface ARObject ()
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *users;


@end


@implementation ARObject

@synthesize arTitle, distance;

- (IBAction)didTouchObject:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsViewController *viewController = (DetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    if (arDescription == nil) {
        
        //User database add .25 to their balance
        FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/users"];
        [[ref child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSMutableDictionary *user = snapshot.value;
            NSString *balance = user[@"Gbalance"];
            NSString *firstName = user[@"firstName"];
            double balanceNum = balance.doubleValue + .25;
            viewController.GBalanceText = [NSString stringWithFormat:@"Your total G-Money Balance is now $%.2f.", balanceNum];
            viewController.ishidden = false;
            [self addObject:@{@"Gbalance": [NSString stringWithFormat:@"%.2f", balanceNum], @"firstName": firstName} withUserId:[FIRAuth auth].currentUser];
            [self addObject:@{}];
            
            [self presentViewController:viewController animated:YES completion:nil];
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    } else {
        viewController.ishidden = true;
        viewController.theid = arId;
        viewController.titled = arTitle;
        viewController.locationLat = lat;
        viewController.locationLon = lon;
        viewController.dataDescription = arDescription;
        viewController.price = arPrice;
        viewController.category = arCategory;
        viewController.condition = arCondition;
        [self presentViewController:viewController animated:YES completion:nil];

    }
    

}

- (void)addObject:(NSDictionary *)data withUserId:(FIRUser *)user{
    NSMutableDictionary *mdata = [data mutableCopy];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/users"];
    [[ref child:user.uid] setValue:mdata];
}
- (void)addObject:(NSDictionary *)data{
    NSMutableDictionary *mdata = [data mutableCopy];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/tokens"];
   [[ref child:stringId] setValue:mdata];
}

- (id)initWithId:(int)newId
           title:(NSString*)newTitle
     coordinates:(CLLocationCoordinate2D)newCoordinates
 currentLocation:(CLLocationCoordinate2D)currLoc
      descrption:(NSString*)newDescrition
condition:(NSString*)newCondition
price:(NSNumber*)newPrice
imageUrl:(NSString *)newImageUrl
andCategory:(NSString*)newCategory
{
    self = [super init];
    if (self) {
        
        
        if (newDescrition == nil) {
            arId = newId;
            arTitle = [[NSString alloc] initWithString:newTitle];
            lat = newCoordinates.latitude;
            lon = newCoordinates.longitude;
        } else {
            arId = newId;
            
            arTitle = [[NSString alloc] initWithString:newTitle];
            
            lat = newCoordinates.latitude;
            lon = newCoordinates.longitude;
            arDescription = [[NSMutableString alloc] initWithString:newDescrition];
            arCondition = [[NSString alloc] initWithString:newCondition];
            arCategory = [[NSString alloc] initWithString:newCategory];
            arPrice = newPrice;
            
            if (newImageUrl == @"") {
                
            } else {
                FIRStorage *storage = [FIRStorage storage];
                // Create a storage reference from our storage service
                FIRStorageReference *storageRef = [storage referenceForURL:newImageUrl];
                
                [storageRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                        NSLog(@"Error Downloading: %@", error);
                    } else {
                        _arImage.image = [UIImage imageWithData:data];
                    }
                }];
            }

        }
        
        
        
        
        // Get a reference to the storage service, using the default Firebase App
        distance = @([self calculateDistanceFrom:currLoc]);
        
        [self.view setTag:newId];
    }
    return self;
}

- (id)initWithId:(NSString *)newId
           title:(NSString*)newTitle
     coordinates:(CLLocationCoordinate2D)newCoordinates
 currentLocation:(CLLocationCoordinate2D)currLoc
{
    self = [super init];
    if (self) {
        
            stringId = newId;
            arTitle = [[NSString alloc] initWithString:newTitle];
            lat = newCoordinates.latitude;
            lon = newCoordinates.longitude;
        
        // Get a reference to the storage service, using the default Firebase App
        distance = @([self calculateDistanceFrom:currLoc]);
        
        [self.view setTag:newId];
    }
    return self;

}




-(double)calculateDistanceFrom:(CLLocationCoordinate2D)user_loc_coord
{
    CLLocationCoordinate2D object_loc_coord = CLLocationCoordinate2DMake(lat, lon);
    
    CLLocation *object_location = [[CLLocation alloc] initWithLatitude:object_loc_coord.latitude
                                                              longitude:object_loc_coord.longitude];
    CLLocation *user_location = [[CLLocation alloc] initWithLatitude:user_loc_coord.latitude
                                                            longitude:user_loc_coord.longitude];
    
    return [object_location distanceFromLocation:user_location];
}
-(NSString*)getDistanceLabelText
{
    if (distance.doubleValue > POINT_ONE_MILE_METERS)
         return [NSString stringWithFormat:@"%.2f mi", distance.doubleValue*METERS_TO_MILES];
    else return [NSString stringWithFormat:@"%.0f ft", distance.doubleValue*METERS_TO_FEET];
}

- (NSDictionary*)getARObjectData
{
    NSArray *keys = @[@"id",@"title", @"latitude", @"longitude", @"distance"];
    
    NSArray *values = @[@(arId),
                       arTitle,
                       @(lat),
                       @(lon),
                       distance];
    return [NSDictionary dictionaryWithObjects:values forKeys:keys];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [titleL setText:arTitle];
    
    [distanceL setText:[self getDistanceLabelText]];
}


#pragma mark -- OO Methods

- (NSString *)description {
    return [NSString stringWithFormat:@"ARObject %d - %@ - lat: %f - lon: %f - distance: %@",
            arId, arTitle, lat, lon, distance];
}

@end
