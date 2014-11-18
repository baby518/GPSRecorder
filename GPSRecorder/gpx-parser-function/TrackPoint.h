//
// Created by zhangchao on 14/10/29.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface TrackPoint : NSObject {
}
// returns a CLLocation object representing this point
@property (nonatomic, strong, readonly) CLLocation *location;

// the latitude of the trackpoint
@property (nonatomic, assign) double latitude;

// the longitude of the trackpoint
@property (nonatomic, assign) double longitude;

// the elevation of the trackpoint
@property (nonatomic, assign) double elevation;

// the time the trackpoint was collected
@property (nonatomic, strong) NSDate *time;


- (TrackPoint *)initWithTrack:(double)latitude :(double)longitude :(double)elevation :(NSDate *)time;
- (CLLocation *)getLocation;

@end