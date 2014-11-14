//
//  FirstViewController.h
//  GPSRecorder
//
//  Created by zhangchao on 14/11/3.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface WorkingTabViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mTrackMapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mSegmentedControl;

@end

