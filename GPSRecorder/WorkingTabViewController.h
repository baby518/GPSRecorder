//
//  FirstViewController.h
//  GPSRecorder
//
//  Created by zhangchao on 14/11/3.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SimpleViewController.h"
#import "MapViewController.h"
#import "GPXCreator.h"

@protocol MyLocationManagerDelegate <NSObject>
- (bool)locationManagerRunning;
- (bool)startLocation;
- (bool)stopLocation;
@end

@interface WorkingTabViewController : UIViewController <CLLocationManagerDelegate, MyLocationManagerDelegate> {
}

@property(weak, nonatomic) IBOutlet UISegmentedControl *mSegmentedControl;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, assign, readonly) int distanceFilter;
@property(nonatomic, retain) CLGeocoder *geocoder;
@property(nonatomic, retain) SimpleViewController *mSimpleViewController;
@property(nonatomic, retain) MapViewController *mMapViewController;
@property(nonatomic, retain, readonly) GPXCreator *gpxCreator;
@property(nonatomic, retain, readonly) NSString *filePathForGPXFile;
@property(nonatomic, retain, readonly) NSURL *fileUrlForGPXFile;
@property(nonatomic, retain, readonly) CLPlacemark *placemarkForStore;
/** bounds for metadata to save file. */
@property(nonatomic, retain, readonly) GPXBounds *metadataBounds;
/** this Locations' array is based on WGS84, used to save gpx file.
*   and post it to MapView to show.*/
@property(nonatomic, copy, readonly) NSMutableArray *currentLocationArray;
@property(nonatomic, assign, readonly) bool isLocationManagerRunning;
/** Geocode location */
@property(nonatomic, assign, readonly) bool needGeocode;
/** store first geocode to generate filename */
@property(nonatomic, assign, readonly) bool needStoreFirstGeocode;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *mRefreshButton;

- (IBAction)segmentChangedValue:(UISegmentedControl *)sender;
- (IBAction)onRefreshClick:(UIBarButtonItem *)sender;

- (void)showSimpleView;
- (void)showMapView;
- (void)startLocationManager;
- (void)stopLocationManager;
- (void)geocodeLocation:(CLLocation *)location;

@end