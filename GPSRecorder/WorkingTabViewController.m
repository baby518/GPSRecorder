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

    _currentLocationArray = [NSMutableArray array];

    // load "Main" storyboard from NSBundle
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    // load viewController from storyboard.
    _mSimpleViewController = [story instantiateViewControllerWithIdentifier:@"simpleViewController"];
    _mMapViewController = [story instantiateViewControllerWithIdentifier:@"mapViewController"];
    _mMapViewController.isRealTimeMode = true;
    _mSimpleViewController.delegate = self;

    [self.view addSubview:_mSimpleViewController.view];
    [self.view addSubview:_mMapViewController.view];

    [self showSimpleView];
    _distanceFilter = 5;
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = _distanceFilter;//the minimum update distance in meters.
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _isLocationManagerRunning = false;

    _geocoder = [[CLGeocoder alloc] init];
    _needGeocode = true;
    _needStoreFirstGeocode = true;
    _metadataBounds = [[GPXBounds alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSimpleView {
    _mSimpleViewController.view.hidden = NO;
    _mMapViewController.view.hidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)showMapView {
    _mSimpleViewController.view.hidden = YES;
    _mMapViewController.view.hidden = NO;
    self.navigationItem.leftBarButtonItem = _mRefreshButton;
}

- (IBAction)segmentChangedValue:(UISegmentedControl *)sender {
    long index = [sender selectedSegmentIndex];

    switch (index) {
        case 0:
            [self showSimpleView];
            break;
        case 1:
            [self showMapView];
            break;
        default:
            break;
    }
}

- (IBAction)onRefreshClick:(UIBarButtonItem *)sender {
    [_mMapViewController reLocateUserPoint];
}

- (void)startLocationManager {
    [_currentLocationArray removeAllObjects];

    _locationManager.delegate = self;
    // requestAlwaysAuthorization or requestWhenInUseAuthorization in IOS 8;
    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    _needStoreFirstGeocode = true;
}

- (void)stopLocationManager {
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingLocation];
    _isLocationManagerRunning = false;
}

- (void)geocodeLocation:(CLLocation *)location {
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *result = placemarks[0];
            [_mSimpleViewController didUpdatePlacemark:result];
            if (_needStoreFirstGeocode) {
                //Store first location;
                _placemarkForStore = result;
                _needStoreFirstGeocode = false;
            }
        } else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

#pragma mark - CLLocationManagerDelegate

/** this Location is based on WGS84, different from MKMapView.
*   we must convert to GCJ-02 if want show it on the chinese map.
*   so just save it to GPX, use TrackMapView to show track. */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    _isLocationManagerRunning = true;
    _mSimpleViewController.locationManagerError = nil;
    //refresh SimpleView
    [_mSimpleViewController didUpdateToLocation:newLocation fromLocation:oldLocation];
    NSLog(@"didUpdateUserLocation newLocation from locationManager : %.6f, %.6f, %.2f, %.2f",
            newLocation.coordinate.longitude, newLocation.coordinate.latitude,
            newLocation.horizontalAccuracy, newLocation.verticalAccuracy);
    if (newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50) {
        return;
    }

    CLLocation *lastLocation = _currentLocationArray.lastObject;
    if (lastLocation == nil || [newLocation distanceFromLocation:lastLocation] > _distanceFilter) {
        [_currentLocationArray addObject:newLocation];
        [_mMapViewController showPolylineFromLocation:_currentLocationArray];
    } else {
        NSLog(@"didUpdateUserLocation distance from lastLocation : %.3f, distanceFilter : %d",
                [newLocation distanceFromLocation:lastLocation], _distanceFilter);
    }

    if (_needGeocode) {
        //Geocode first location;
        CLLocationCoordinate2D coordinate = [GPSLocationHelper transformFromWGSToGCJ:newLocation.coordinate];
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate
                                                             altitude:newLocation.altitude
                                                   horizontalAccuracy:newLocation.horizontalAccuracy
                                                     verticalAccuracy:newLocation.verticalAccuracy
                                                            timestamp:newLocation.timestamp];
        [self geocodeLocation:location];
    }

    // compare every location, calc the GPX metadata's bounds element.
    if (newLocation.coordinate.latitude > _metadataBounds.maxLatitude) {
        _metadataBounds.maxLatitude = newLocation.coordinate.latitude;
    }
    if (newLocation.coordinate.latitude < _metadataBounds.minLatitude) {
        _metadataBounds.minLatitude = newLocation.coordinate.latitude;
    }
    if (newLocation.coordinate.longitude > _metadataBounds.maxLongitude) {
        _metadataBounds.maxLongitude = newLocation.coordinate.longitude;
    }
    if (newLocation.coordinate.longitude < _metadataBounds.minLongitude) {
        _metadataBounds.minLongitude = newLocation.coordinate.longitude;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError : %@", error);
    _isLocationManagerRunning = false;
    _mSimpleViewController.locationManagerError = error;
    [self stopLocationManager];
}

#pragma mark - MyLocationManagerDelegate
- (bool)locationManagerRunning {
    return _isLocationManagerRunning;
}

- (bool)startLocation {
    [self startLocationManager];
    // if start failed, return false.
    _gpxCreator = [[GPXCreator alloc] initWithName:@"ZhangChao"];

    return true;
}

- (bool)stopLocation {
    [self stopLocationManager];
    // if stop failed, return false.
    // add metadata here
    [_gpxCreator addMetadataBounds:_metadataBounds];
    // add all locations
    [_gpxCreator addLocations:_currentLocationArray];
    [_gpxCreator stop];

    NSString *state = _placemarkForStore.administrativeArea;
    NSString *thoroughfare = _placemarkForStore.thoroughfare;
    if (state == nil || [state isEqualToString:@""]) {
        _filePathForGPXFile = [FileHelper generateFilePathFromDate];
//        _fileUrlForGPXFile = [FileHelper generateFileUrlFromDate];
    } else if (thoroughfare == nil || [thoroughfare isEqualToString:@""]) {
        NSString *string = [NSString stringWithFormat:@"-%@", state];
        _filePathForGPXFile = [FileHelper generateFilePathFromDateWithString:string];
//        _fileUrlForGPXFile = [FileHelper generateFileUrlFromDateWithString:string];
    } else {
        NSString *string = [NSString stringWithFormat:@"-%@_%@", state, thoroughfare];
        _filePathForGPXFile = [FileHelper generateFilePathFromDateWithString:string];
//        _fileUrlForGPXFile = [FileHelper generateFileUrlFromDateWithString:string];
    }

    [_gpxCreator saveFilePath:_filePathForGPXFile];
//    [_gpxCreator saveFileUrl:_fileUrlForGPXFile];
    return true;
}
@end
