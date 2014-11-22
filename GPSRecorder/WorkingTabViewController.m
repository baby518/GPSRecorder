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

    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    _mSimpleViewControler = [story instantiateViewControllerWithIdentifier:@"simpleViewControler"];
    _mMapViewControler = [story instantiateViewControllerWithIdentifier:@"mapViewControler"];
    _mMapViewControler.isRealTimeMode = true;

    [self.view addSubview:_mSimpleViewControler.view];
    [self.view addSubview:_mMapViewControler.view];

    _mSimpleViewControler.view.hidden = NO;
    _mMapViewControler.view.hidden = YES;

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
    NSLog(@"segmentChangedValue %ld", index);
    
    switch (index) {
        case 0:
            _mSimpleViewControler.view.hidden = NO;
            _mMapViewControler.view.hidden = YES;
            break;
        case 1:
            _mSimpleViewControler.view.hidden = YES;
            _mMapViewControler.view.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 800, 800);
//    [_mMapViewControler.mTrackMapView setRegion:[_mMapViewControler.mTrackMapView regionThatFits:region] animated:YES];
    //refresh SimpleView
    [_mSimpleViewControler didUpdateToLocation:newLocation fromLocation:oldLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError");
}
@end
