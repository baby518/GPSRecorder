//
// Created by zhangchao on 14/10/31.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackPoint.h"
#import "GPXLog.h"

@interface TrackSegment : NSObject {
//    NSMutableArray *mTrackPoints;
}

// children's countOfPoints
@property(nonatomic, assign, readonly) long countOfPoints;

// The total length, in meters, of this segment
@property(nonatomic, assign, readonly) double length;

// The total elevation gain, in meters, of this segment
@property(nonatomic, assign, readonly) double elevationGain;

// The total time cost , in second(s), of this segment
@property(nonatomic, assign, readonly) double totalTime;

// array of GPXTrackpoint objects
@property(nonatomic, copy) NSMutableArray *trackPoints;

- (void)addTrackpoint:(TrackPoint *)trackPoint;

@end