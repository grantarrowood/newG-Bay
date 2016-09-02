//
//  ItemMapViewController.m
//  newG-Bay
//
//  Created by Grant Arrowood on 8/26/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "ItemMapViewController.h"
#import "MyCustomAnnotation.h"
#import "DetailsViewController.h"

@interface ItemMapViewController ()
{
    FIRDatabaseHandle _refHandle;
    NSUInteger tapped;
    UIImage *theImage;
}
@end

@implementation ItemMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mappedView.delegate = self;
    _objects = [[NSMutableArray alloc] init];
    FIRDatabaseReference  *ref = [[FIRDatabase database] referenceWithPath:@"/objects"];
    _refHandle = [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot *snapshot) {
        [_objects addObject:snapshot];
        NSDictionary<NSString *, NSString *> *object = snapshot.value;
        NSString *latitudeString  = object[@"latitude"];
        NSString *longitudeString  = object[@"longitude"];

        double lat = latitudeString.floatValue;
        double lon = longitudeString.floatValue;
        CLLocationCoordinate2D pointCoordinates;
        pointCoordinates.latitude = lat;
        pointCoordinates.longitude = lon;
        NSString *title = object[@"title"];
        NSNumber *price = object[@"price"];
        NSUInteger tagInteger = [_objects count] -1;
        NSString *imageString = object[@"imageUrl"];
        if (imageString == nil) {
            MyCustomAnnotation *annotationView = [[MyCustomAnnotation alloc] initWithTitle:title location:pointCoordinates andSubTitle:(long)price WithTag:tagInteger andImage:[UIImage imageNamed:@"pinAnnotation"] withBool:false];
            [self.mappedView addAnnotation:annotationView];
            
        } else {
            FIRStorage *storage = [FIRStorage storage];
            // Create a storage reference from our storage service
            FIRStorageReference *storageRef = [storage referenceForURL:imageString];
            
            [storageRef dataWithMaxSize:100 * 1024 * 1024 completion:^(NSData *data, NSError *error){
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    NSLog(@"Error Downloading: %@", error);
                } else {
                    theImage = [UIImage imageWithData:data];
                    MyCustomAnnotation *annotationView = [[MyCustomAnnotation alloc] initWithTitle:title location:pointCoordinates andSubTitle:(long)price WithTag:tagInteger andImage:theImage  withBool:true];
                    [annotationView annotationView];
                    [self.mappedView addAnnotation:annotationView];
                }
            }];
        }
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mappedView setRegion:[self.mappedView regionThatFits:region] animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MyCustomAnnotation class]])
    {
        MyCustomAnnotation *myLoc = (MyCustomAnnotation *)annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyCustomAnnotation"];
        
        if (annotationView == nil) {
            annotationView = myLoc.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MyCustomAnnotation *myLoc = view.annotation;
    //tapped = myLoc.tags;
    FIRDataSnapshot *objectSnapshot = _objects[myLoc.tags];
    NSDictionary<NSString *, NSString *> *object = objectSnapshot.value;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailsViewController *destViewController = (DetailsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    destViewController.titled = object[@"title"];
    destViewController.dataDescription = object[@"description"];
    destViewController.condition = object[@"condition"];
    destViewController.price = object[@"price"];
    destViewController.category = object[@"category"];
    double lat = object[@"latitude"].doubleValue;
    double lon = object[@"longitude"].doubleValue;
    CLLocationCoordinate2D pointCoordinates;
    pointCoordinates.latitude = lat;
    pointCoordinates.longitude = lon;
    destViewController.locationLat = pointCoordinates.latitude;
    destViewController.locationLon = pointCoordinates.longitude;
    destViewController.ishidden = true;
    [[NSUserDefaults standardUserDefaults] setObject:@"ItemMapViewController"
                                              forKey:@"last_view"];
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:destViewController
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"infoDetails"]) {
//        FIRDataSnapshot *objectSnapshot = _objects[(long)tapped];
//        NSDictionary<NSString *, NSString *> *object = objectSnapshot.value;
//        DetailsViewController *destViewController = segue.destinationViewController;
//        destViewController.titled = object[@"title"];
//        destViewController.dataDescription = object[@"description"];
//        destViewController.condition = object[@"condition"];
//        destViewController.price = object[@"price"];
//        destViewController.category = object[@"category"];
//        double lat = object[@"latitude"].doubleValue;
//        double lon = object[@"longitude"].doubleValue;
//        CLLocationCoordinate2D pointCoordinates;
//        pointCoordinates.latitude = lat;
//        pointCoordinates.longitude = lon;
//        destViewController.locationLat = pointCoordinates.latitude;
//        destViewController.locationLon = pointCoordinates.longitude;
//        destViewController.ishidden = true;
//        [[NSUserDefaults standardUserDefaults] setObject:@"ItemMapViewController"
//                                                  forKey:@"last_view"];
//        
//    }

}


@end
