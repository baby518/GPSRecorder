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
    
    [_mTrackMapView setMapType:MKMapTypeStandard];
    _mTrackMapView.showsUserLocation = YES;
//    _mTrackMapView.delegate = self;
    
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

@end
