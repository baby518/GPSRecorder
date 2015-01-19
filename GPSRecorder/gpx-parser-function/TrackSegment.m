//
// Created by zhangchao on 14/10/31.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import "TrackSegment.h"


@implementation TrackSegment {
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _trackPoints = [NSMutableArray array];
//        mTrackPoints = [@[] mutableCopy];
//        mTrackPoints = [NSMutableArray arrayWithCapacity:5];
        _countOfPoints = 0;
    }
    return self;
}

- (void)addTrackpoint:(TrackPoint *)trackPoint {
    [_trackPoints addObject:trackPoint];
    if ([_trackPoints count] > 1) {
        TrackPoint *last = _trackPoints[[_trackPoints count] - 2];
        // figure out distance from last point
        _length += [[last getLocation] distanceFromLocation:[trackPoint getLocation]];

        _totalTime += [[[trackPoint getLocation] timestamp] timeIntervalSince1970]
                - [[[last getLocation] timestamp] timeIntervalSince1970];

        // figure out if we climbed at all since last point
        double climb = trackPoint.elevation - last.elevation;
        if (climb > 0) {
            _elevationGain += climb;
        }
    }
    _countOfPoints = [_trackPoints count];
}

@end