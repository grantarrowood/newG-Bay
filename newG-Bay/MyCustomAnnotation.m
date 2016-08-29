//
//  MyCustomAnnotation.m
//  newG-Bay
//
//  Created by Grant Arrowood on 8/28/16.
//  Copyright © 2016 Grant Arrowood. All rights reserved.
//

#import "MyCustomAnnotation.h"

@implementation MyCustomAnnotation

-(id)initWithTitle:(NSString *)newTitle location:(CLLocationCoordinate2D)location andSubTitle:(NSInteger *)newSubTitle WithTag:(NSUInteger)tag andImage:(UIImage *)newImage withBool:(bool)theBool
{
    self = [super init];
    
    if(self)
    {
        _title = newTitle;
        _subtitle = [NSString stringWithFormat:@"%@",newSubTitle];
        _coordinate = location;
        _tags = tag;
        _myBool = theBool;
        _theImage = [self imageWithImage:newImage convertToSize:CGSizeMake(50, 50)];
    }
    return self;
}

-(MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"MyCustomAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = _theImage;
    if(_myBool)
    {
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:_theImage];
    } else {
        
    }
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}




@end
