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

    NSLog(@"viewDidLoad isRealTimeMode : %d", _isRealTimeMode);
    if (_isRealTimeMode) {
        _mTrackMapView.delegate = self;
        _mTrackMapView.showsUserLocation = YES;
        _mTrackMapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    [_mTrackMapView setMapType:MKMapTypeStandard];
    [_mTrackMapView setZoomEnabled:YES];

    if (_gpxData != nil) {
        GPXParser *gpxParser = [[GPXParser alloc] initWithData:_gpxData];
        gpxParser.delegate = self;
//        gpxParser.callbackMode = PARSER_CALLBACK_MODE_JUST_RESULT;
        [gpxParser parserAllElements];
    }

//    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(31.203, 121.6231);
//    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(31.204, 121.6232);
//
//    // create a c array of points.
//    MKMapPoint* pointArr = malloc(sizeof(CLLocationCoordinate2D) * 2);
//
//    MKMapPoint points1 = MKMapPointForCoordinate(coord1);
//    MKMapPoint points2 = MKMapPointForCoordinate(coord2);
//    pointArr[0] = points1;
//    pointArr[1] = points2;
//    _routeLine = [MKPolyline polylineWithPoints:pointArr count:2];
//
//    [_mTrackMapView addOverlay:_routeLine];
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
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
//    [_mTrackMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//    [_mTrackMapView setRegion:[_mTrackMapView regionThatFits:region] animated:YES];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    MKOverlayView *overlayView = nil;
    if (overlay == _routeLine) {
        //if we have not yet created an overlay view for this overlay, create it now.
        if (nil == _routeLineView) {
            _routeLineView = [[MKPolylineView alloc] initWithPolyline:_routeLine];
            _routeLineView.fillColor = [UIColor redColor];
            _routeLineView.strokeColor = [UIColor redColor];
            _routeLineView.lineWidth = 3;
        }
        overlayView = _routeLineView;
    }

    return overlayView;
}

#pragma mark - GPXParser

- (void)rootCreatorDidParser:(NSString *)creator {
    NSLog(@"rootCreatorDidParser from GPXParserDelegate. %@", creator);
}

- (void)rootVersionDidParser:(NSString *)version {
    NSLog(@"rootVersionDidParser from GPXParserDelegate. %@", version);
}

- (void)onErrorWhenParser:(int)errorCode {
    NSLog(@"onErrorWhenParser from GPXParserDelegate, errorCode : %d", errorCode);
}

- (void)onPercentageOfParser:(double)percentage {
    NSLog(@"onPercentOfParser from GPXParserDelegate, percentage : %f", percentage);
}

- (void)trackPointDidParser:(TrackPoint *)trackPoint {
}

- (void)trackSegmentDidParser:(TrackSegment *)segment {
}

- (void)trackDidParser:(Track *)track {
}

- (void)allTracksDidParser:(NSArray *)tracks {
}

@end
