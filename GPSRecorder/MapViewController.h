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
#import "GPSLocationHelper.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, GPXParserDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mTrackMapView;

@property (strong, nonatomic) NSData *gpxData;
@property (strong, nonatomic, readonly) GPXParser *gpxParser;
/** show gpx file's track OR show user's track in real time.
*   default is true. */
@property (nonatomic, assign) bool isRealTimeMode;
@property (nonatomic, assign, readonly) int countOfPoints;
@property (nonatomic, copy, readonly) NSMutableArray *currentTrackPoints;

@property (strong, nonatomic) MKPolyline *routeLine;
@property (strong, nonatomic) MKPolylineView * routeLineView;

@end
