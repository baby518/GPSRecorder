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

    _xmlParseMode = 1;

    NSLog(@"viewDidLoad isRealTimeMode : %d", _isRealTimeMode);
    _mTrackMapView.delegate = self;
    if (_isRealTimeMode) {
        // I want use CLLocationManager to update it. so don't set it;
//        _mTrackMapView.showsUserLocation = YES;
        // if set userTrackingMode is MKUserTrackingModeFollow,
        // it will show user's blue point always and auto resize it ...
        _mTrackMapView.userTrackingMode = MKUserTrackingModeFollow;
    }
    [_mTrackMapView setMapType:MKMapTypeStandard];
    [_mTrackMapView setZoomEnabled:YES];

    _currentTrackPoints = [NSMutableArray array];

    if (!_isRealTimeMode && _gpxData != nil) {
        if (_xmlParseMode == 1) {
            NSLog(@"startParserButtonPressed use NSXML.");
            _nsGpxParser = [[NSGPXParser alloc] initWithData:_gpxData];
            _nsGpxParser.delegate = self;
            [_nsGpxParser satrtParser];
        } else if (_xmlParseMode == 2) {
            NSLog(@"startParserButtonPressed use GDataXML.");
            _gpxParser = [[GPXParser alloc] initWithData:_gpxData];
            _gpxParser.delegate = self;
            _gpxParser.callbackMode = PARSER_CALLBACK_MODE_JUST_RESULT;
            [_gpxParser parserAllElements];
        }
    }
}

- (void)dealloc {
    NSLog(@"MapViewController dealloc");
    [_gpxParser stopParser];
    [_nsGpxParser stopParser];
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

- (void)displayRegionInMapView :(NSArray *) trackPoints fixCenter:(bool) fixCenter {
    if (trackPoints) {
        if (fixCenter) {
            [self showCenterFromTrackPoints:trackPoints];
        }
        [self showPolylineFromTrackPoints:trackPoints];
    }
}

- (void)showCenterFromTrackPoints:(double)maxLatitude :(double)minLatitude :(double)maxLongitude :(double)minLongitude {
    double margin = 0.005f;

    double latitude = (maxLatitude + minLatitude) / 2;
    double longitude = (maxLongitude + minLongitude) / 2;

    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    centerCoordinate = [GPSLocationHelper transformFromWGSToGCJ:centerCoordinate];

    //determine the size of the map area to show around the location
    double latitudeDelta = fabs(maxLatitude) - fabs(minLatitude) + margin;
    double longitudeDelta = fabs(maxLongitude) - fabs(minLongitude) + margin;
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(fabs(latitudeDelta), fabs(longitudeDelta));

    //create the region of the map that we want to show
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, coordinateSpan);

    //update the map view
    _mTrackMapView.region = region;
}

- (void)showCenterFromTrackPoints:(NSArray *)trackPoints {
    //create a 2D coordinate for the map view
    double maxLatitude = -MAXFLOAT;
    double minLatitude = MAXFLOAT;
    double maxLongitude = -MAXFLOAT;
    double minLongitude = MAXFLOAT;

    for (TrackPoint *point in trackPoints) {
        CLLocation *location = [point getLocation];
        if (location.coordinate.latitude > maxLatitude) {
            maxLatitude = location.coordinate.latitude;
        }
        if (location.coordinate.latitude < minLatitude) {
            minLatitude = location.coordinate.latitude;
        }
        if (location.coordinate.longitude > maxLongitude) {
            maxLongitude = location.coordinate.longitude;
        }
        if (location.coordinate.longitude < minLongitude) {
            minLongitude = location.coordinate.longitude;
        }
    }
    [self showCenterFromTrackPoints:maxLatitude :minLatitude :maxLongitude :minLongitude];
}

- (void)showPolylineFromTrackPoints:(NSArray *)trackPoints {
    int count = trackPoints.count;
    // create a c array of points.
    CLLocationCoordinate2D points[count];

    int i = 0;
    for (TrackPoint *trackPoint in trackPoints) {
        CLLocation *location = trackPoint.location;
        CLLocationCoordinate2D coord = location.coordinate;

        // convert WGS to GCJ
        CLLocationCoordinate2D coordGCJ = [GPSLocationHelper transformFromWGSToGCJ:coord];
        points[i] = coordGCJ;
        i++;
    }

    MKPolyline *route = [MKPolyline polylineWithCoordinates:points count:count];
    [_mTrackMapView removeOverlays:_mTrackMapView.overlays];
    [_mTrackMapView addOverlay:route];
}

- (void)showPolylineFromLocation:(NSArray *)locationArray {
    int count = locationArray.count;
    // create a c array of points.
    CLLocationCoordinate2D points[count];

    int i = 0;
    for (CLLocation *locationPoint in locationArray) {
        CLLocationCoordinate2D coord = locationPoint.coordinate;

        // convert WGS to GCJ
        CLLocationCoordinate2D coordGCJ = [GPSLocationHelper transformFromWGSToGCJ:coord];
        points[i] = coordGCJ;
        i++;
    }

    MKPolyline *route = [MKPolyline polylineWithCoordinates:points count:count];
    [_mTrackMapView removeOverlays:_mTrackMapView.overlays];
    [_mTrackMapView addOverlay:route];
}

#pragma mark - MKMapViewDelegate

/** this Location is based on GCJ-02 if the map is chinese GaoDeMap. */
- (void)mapView:(MKMapView *)theMapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1000, 1000);
//    [_mTrackMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
//    [_mTrackMapView setRegion:[_mTrackMapView regionThatFits:region] animated:YES];
    NSLog(@"didUpdateUserLocation from theMapView : %.6f, %.6f",
            userLocation.coordinate.longitude, userLocation.coordinate.latitude);
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolylineRenderer *routeView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    routeView.fillColor = [UIColor redColor];
    routeView.strokeColor = [UIColor redColor];
    routeView.lineWidth = 3.0f;
    return routeView;
}

#pragma mark - GPXParserDelegate

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
//    NSLog(@"onPercentOfParser from GPXParserDelegate, percentage : %f", percentage);
}

- (void)trackPointDidParser:(TrackPoint *)trackPoint {
}

- (void)trackSegmentDidParser:(TrackSegment *)segment {
}

- (void)trackDidParser:(Track *)track {
}

- (void)allTracksDidParser:(NSArray *)tracks {
    // get All points in the tracks.
    for (Track *track in tracks) {
        for (TrackSegment *segment in [track trackSegments]) {
            for (TrackPoint *point in [segment trackPoints]) {
                [_currentTrackPoints addObject:point];
            }
        }
    }

    // if has no bounds, calc the center of Track.
    if (_boundsRect.size.width == 0 && _boundsRect.size.height == 0) {
        [self displayRegionInMapView:_currentTrackPoints fixCenter:true];
    } else {
        [self displayRegionInMapView:_currentTrackPoints fixCenter:false];
    }
}

- (void)tracksBoundsDidParser:(CGRect)rect needFixIt:(bool)needFix {
    _boundsRect = rect;

    double maxLatitude = _boundsRect.origin.x + _boundsRect.size.width;
    double minLatitude = _boundsRect.origin.x;
    double maxLongitude = _boundsRect.origin.y + _boundsRect.size.height;
    double minLongitude = _boundsRect.origin.y;

    [self showCenterFromTrackPoints:maxLatitude :minLatitude :maxLongitude :minLongitude];
}
@end
