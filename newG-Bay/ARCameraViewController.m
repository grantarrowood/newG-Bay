//
//  ARCameraViewController.m
//  G-Bay
//
//  Created by Grant Arrowood on 8/20/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "ARCameraViewController.h"
#import "Constants.h"
#define NUMBER_OF_POINTS    10

@interface ARCameraViewController ()
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *tokens;

@end

@implementation ARCameraViewController
{
    CLLocationManager *locationManager;
    CLLocation *currentLocationNow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    _objects = [[NSMutableArray alloc] init];
    _tokens = [[NSMutableArray alloc] init];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    FIRDatabaseReference  *ref2 = [[FIRDatabase database] referenceWithPath:@"/tokens"];
    [ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        [_objects addObject:snapshot];
        [ref2 observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            [_tokens addObject:snapshot];
            [PRARManager sharedManagerWithSize:self.view.frame.size andDelegate:self];
            [[PRARManager sharedManager] startARWithData:[self getDummyData] forLocation:currentLocationNow.coordinate];
            
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];

    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [[PRARManager sharedManager] stopAR];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        currentLocationNow = currentLocation;
    }
}


-(NSArray*)getDummyData
{
    NSMutableArray *points = [NSMutableArray array];
    
    srand48(time(0));
    for (int i=0; i<_objects.count; i++)
    {
        FIRDataSnapshot *objectSnapshot = _objects[i];
        NSMutableDictionary *object = objectSnapshot.value;
        for (id key in object) {
            id anObject = [object objectForKey:key];
            /* Do something with anObject. */
            NSString *objectIdString = anObject[@"objectId"];
            NSMutableString *description = anObject[@"description"];
            NSString *condition = anObject[@"condition"];
            NSNumber *price = anObject[@"price"];
            NSString *category = anObject[@"category"];
            NSString *imageUrl = anObject[@"imageUrl"];
            NSString *title = anObject[ObjectFieldstitle];
            NSString *latitude = anObject[ObjectFieldslatitude];
            NSString *longitude = anObject[ObjectFieldslongitude];
            
            double lat = latitude.floatValue;
            double lon = longitude.floatValue;
            int objectId = objectIdString.intValue;
            CLLocationCoordinate2D pointCoordinates;
            pointCoordinates.latitude = lat;
            pointCoordinates.longitude = lon;
            NSDictionary *point = [self createPointWithId:objectId at:pointCoordinates andTitle:title descrition:description condidtion:condition price:price category:category imageUrl:imageUrl];
            [points addObject:point];
        }
    }
    for (int i=0; i<_tokens.count; i++) {
        FIRDataSnapshot *tokenSnapshot = _tokens[i];
        NSMutableDictionary *token = tokenSnapshot.value;
        for (id key in token) {
            id anObject = [token objectForKey:key];
            /* Do something with anObject. */
            NSString *objectIdString = anObject[@"objectId"];
            NSString *didFind = anObject[@"didFind"];
            NSString *latitude = anObject[ObjectFieldslatitude];
            NSString *longitude = anObject[ObjectFieldslongitude];
            
            double lat = latitude.floatValue;
            double lon = longitude.floatValue;
            int objectId = objectIdString.intValue;
            CLLocationCoordinate2D pointCoordinates;
            pointCoordinates.latitude = lat;
            pointCoordinates.longitude = lon;
            NSDictionary *point = [self createPointWithId:objectId at:pointCoordinates andTitle:nil descrition:nil condidtion:nil price:nil category:nil imageUrl:nil];
            [points addObject:point];
        }
    }
    
    return [NSArray arrayWithArray:points];
}

// Returns a random location
-(CLLocationCoordinate2D)getRandomLocation
{
    double latRand = drand48() * 90.0;
    double lonRand = drand48() * 180.0;
    double latSign = drand48();
    double lonSign = drand48();
    
    CLLocationCoordinate2D locCoordinates = CLLocationCoordinate2DMake(latSign > 0.5 ? latRand : -latRand,
                                                                       lonSign > 0.5 ? lonRand*2 : -lonRand*2);
    return locCoordinates;
}

// Creates the Data for an AR Object at a given location
-(NSDictionary*)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates andTitle:(NSString *)title descrition:(NSMutableString *)description condidtion:(NSString *)condition price:(NSNumber *)price category:(NSString *)category imageUrl:(NSString *)imageUrl
{
    NSDictionary *point;
    if ((imageUrl == nil) && ((title != nil))) {
        point = @{
                                @"id" : @(the_id),
                                @"description" : description,
                                @"condition" : condition,
                                @"price" : price,
                                @"category" : category,
                                @"title" : title,
                                @"imageUrl" : @"",
                                @"lon" : @(locCoordinates.longitude),
                                @"lat" : @(locCoordinates.latitude)
                                };
    } else if (title == nil) {
        point = @{
                                @"id" : @(the_id),
                                @"didFind" : @"false",
                                @"lon" : @(locCoordinates.longitude),
                                @"lat" : @(locCoordinates.latitude)
                                };
    } else {
        point = @{
                  @"id" : @(the_id),
                  @"description" : description,
                  @"condition" : condition,
                  @"price" : price,
                  @"category" : category,
                  @"title" : title,
                  @"imageUrl" : imageUrl,
                  @"lon" : @(locCoordinates.longitude),
                  @"lat" : @(locCoordinates.latitude)
                  };
    }
    
    return point;
}



-(void)prarDidSetupAR:(UIView *)arView withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer
{
    [self.view.layer addSublayer:cameraLayer];
    [self.view addSubview:arView];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:AR_VIEW_TAG]];
    [self.view bringSubviewToFront:self.backButton];
    
    
}

-(void)prarUpdateFrame:(CGRect)arViewFrame
{
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
    
}

-(void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails
{
    
}


@end
