//
//  MyCustomAnnotation.h
//  newG-Bay
//
//  Created by Grant Arrowood on 8/28/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyCustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (nonatomic, readonly) NSUInteger tags;
@property (nonatomic, readonly) UIImage *theImage;
@property (nonatomic, readonly) bool myBool;


-(id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location andSubTitle:(NSInteger *)newSubTitle WithTag:(NSUInteger)tag andImage:(UIImage *)newImage withBool:(bool)theBool;
-(MKAnnotationView *)annotationView;

@end
