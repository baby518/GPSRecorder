//
//  MapViewController.m
//  GPSRecorder
//
//  Created by zhangchao on 14/11/14.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [_mTrackMapView setMapType:MKMapTypeStandard];
    _mTrackMapView.showsUserLocation = YES;
    _mTrackMapView.delegate = self;

    self.locationManager = [[CLLocationManager alloc] init];

    //Trying to start MapKit location updates without prompting for location authorization. Must call -[CLLocationManager requestWhenInUseAuthorization] or -[CLLocationManager requestAlwaysAuthorization] first.

//    CLLocationCoordinate2D theCoordinate;
//    theCoordinate.latitude=21.238928;
//    theCoordinate.longitude=113.313353;
//
//    MKCoordinateSpan theSpan;
//    theSpan.latitudeDelta=0.1;
//    theSpan.longitudeDelta=0.1;
//
//    MKCoordinateRegion theRegion;
//    theRegion.center=theCoordinate;
//    theRegion.span=theSpan;
//
//    [_mTrackMapView setRegion:theRegion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)mapView:(MKMapView *)theMapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    [theMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}

@end
