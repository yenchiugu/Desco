//
//  LocationSearchFilePin.h
//  PullTest
//
//  Created by Sam Ku on 9/22/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface LocationSearchFilePin : NSObject<MKAnnotation> {
  CLLocationCoordinate2D coordinate;
  NSString *title;
  NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coords;

@end
