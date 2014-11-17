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

@interface WorkingTabViewController : UIViewController <CLLocationManagerDelegate> {
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *mSegmentedControl;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) SimpleViewController *mSimpleViewControler;
@property(nonatomic, retain) MapViewController *mMapViewControler;

- (IBAction)segmentChangedValue:(UISegmentedControl *)sender;

@end

