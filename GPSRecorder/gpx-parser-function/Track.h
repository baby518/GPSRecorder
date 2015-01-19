//
// Created by zhangchao on 14/10/31.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackSegment.h"

@interface Track : NSObject {
//    NSMutableArray *mTrackSegments;
}

// the name of the track
@property (nonatomic, copy) NSString * trackName;

// array of GPXTrackSegment objects
@property (nonatomic, copy, readonly) NSMutableArray* trackSegments;

// children's countOfPoints
@property (nonatomic, assign, readonly) long countOfPoints;

// total length, in meters, of the track
@property (nonatomic, assign, readonly) double length;

// total gain, in meters
@property (nonatomic, assign, readonly) double elevationGain;

// The total time cost , in second(s)
@property (nonatomic, assign, readonly) double totalTime;

- (instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;
- (void)addTrackSegment:(TrackSegment *)trkseg;

@end