//
// Created by zhangchao on 14/11/27.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GPSLocationHelper : NSObject

+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
@end