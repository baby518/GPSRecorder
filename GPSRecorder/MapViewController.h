//
//  MapViewController.h
//  GPSRecorder
//
//  Created by zhangchao on 14/11/14.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GPXParser.h"
#import "NSGPXParser.h"
#import "GPSLocationHelper.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, GPXParserDelegate, NSGPXParserDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mTrackMapView;

@property (nonatomic, assign) int xmlParseMode;
@property (strong, nonatomic) NSData *gpxData;
@property (strong, nonatomic, readonly) GPXParser *gpxParser;
@property (strong, nonatomic, readonly) NSGPXParser *nsGpxParser;
/** show gpx file's track OR show user's track in real time.
*   default is true. */
@property (nonatomic, assign) bool isRealTimeMode;
@property (nonatomic, assign, readonly) int countOfPoints;
@property (nonatomic, copy, readonly) NSMutableArray *currentTrackPoints;

@property (nonatomic, assign, readonly) CGRect boundsRect;
@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView * routeLineView;

- (void)displayRegionInMapView:(NSArray *)trackPoints fixCenter:(bool)fixCenter;
- (void)showCenterFromTrackPoints:(double)maxLatitude :(double)minLatitude :(double)maxLongitude :(double)minLongitude;
- (void)showCenterFromTrackPoints:(NSArray *)trackPoints;
- (void)showPolylineFromTrack;
@end
