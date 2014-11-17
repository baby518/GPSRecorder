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

    _mTrackMapView.delegate = self;
    [_mTrackMapView setMapType:MKMapTypeStandard];
    _mTrackMapView.showsUserLocation = YES;
    _mTrackMapView.userTrackingMode = MKUserTrackingModeFollow;
    [_mTrackMapView setZoomEnabled:YES];
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
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
    [_mTrackMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_mTrackMapView setRegion:[_mTrackMapView regionThatFits:region] animated:YES];
}

@end
