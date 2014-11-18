//
// Created by zhangchao on 14/10/31.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import "Track.h"

@implementation Track {

}

- (id)init {
    return [self initWithName:@""];
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _trackSegments = [NSMutableArray array];
        _trackName = name;
        _countOfPoints = 0;
        _elevationGain = 0;
    }
    return self;
}

- (void)addTrackSegment:(TrackSegment *)trkseg {
    [_trackSegments addObject:trkseg];
    _length += trkseg.length;
    _totalTime += trkseg.totalTime;
    _countOfPoints += trkseg.countOfPoints;
    _elevationGain += trkseg.elevationGain;
}

@end