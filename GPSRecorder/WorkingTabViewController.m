//
//  FirstViewController.m
//  GPSRecorder
//
//  Created by zhangchao on 14/11/3.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import "WorkingTabViewController.h"

@interface WorkingTabViewController ()

@end

@implementation WorkingTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // load "Main" storyboard from NSBundle
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    // load viewController from storyboard.
    _mSimpleViewController = [story instantiateViewControllerWithIdentifier:@"simpleViewController"];
    _mMapViewController = [story instantiateViewControllerWithIdentifier:@"mapViewController"];
    _mMapViewController.isRealTimeMode = true;

    [self.view addSubview:_mSimpleViewController.view];
    [self.view addSubview:_mMapViewController.view];

    _mSimpleViewController.view.hidden = NO;
    _mMapViewController.view.hidden = YES;

    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = 5;//the minimum update distance in meters.
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    // requestAlwaysAuthorization or requestWhenInUseAuthorization in IOS 8;
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentChangedValue:(UISegmentedControl *)sender {
    long index = [sender selectedSegmentIndex];

    switch (index) {
        case 0:
            _mSimpleViewController.view.hidden = NO;
            _mMapViewController.view.hidden = YES;
            break;
        case 1:
            _mSimpleViewController.view.hidden = YES;
            _mMapViewController.view.hidden = NO;
            break;
        default:
            break;
    }
}

#pragma mark - CLLocationManagerDelegate

/** this Location is based on WGS84, different from TrackMapView.
*   we must convert to GCJ-02 if want show it on the chinese map.
*   so just save it to GPX, use TrackMapView to show track. */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 800, 800);
//    [_mMapViewController.mTrackMapView setCenterCoordinate:newLocation.coordinate animated:YES];
//    [_mMapViewController.mTrackMapView setRegion:[_mMapViewController.mTrackMapView regionThatFits:region] animated:YES];
    //refresh SimpleView
    [_mSimpleViewController didUpdateToLocation:newLocation fromLocation:oldLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
}
@end
