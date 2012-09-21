//
//  LocationSearchFilePin.m
//  PullTest
//
//  Created by Sam Ku on 9/22/12.
//  Copyright (c) 2012 Sam Ku. All rights reserved.
//

#import "LocationSearchFilePin.h"

@implementation LocationSearchFilePin
@synthesize coordinate, title, subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coords {
  self = [super init];
  if (self != nil) coordinate = coords;
  
  return self;
}

@end
