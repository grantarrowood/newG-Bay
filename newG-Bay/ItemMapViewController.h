//
//  ItemMapViewController.h
//  newG-Bay
//
//  Created by Grant Arrowood on 8/26/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@import Firebase;
#import "CCHMapClusterController.h"



@interface ItemMapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) CCHMapClusterController *mapClusterController;


@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *objects;

@end
