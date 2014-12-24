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

@interface WorkingTabViewController : UIViewController <CLLocationManagerDelegate, SimpleViewControllerDelegate> {
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *mSegmentedControl;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) SimpleViewController *mSimpleViewController;
@property(nonatomic, retain) MapViewController *mMapViewController;
@property(nonatomic, retain, readonly) GPXCreator *gpxCreator;
@property(nonatomic, retain, readonly) NSString *filePathForGPXFile;
/** this Locations' array is based on WGS84, used to save gpx file.
*   and post it to MapView to show.*/
@property (nonatomic, copy, readonly) NSMutableArray *currentLocationArray;
@property (nonatomic, assign, readonly) bool isLocationManagerRunning;

- (IBAction)segmentChangedValue:(UISegmentedControl *)sender;

- (void)startLocationManager;
- (void)stopLocationManager;

@end

