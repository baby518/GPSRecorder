//
//  SimpleViewController.h
//  GPSRecorder
//
//  Created by zhangchao on 14/11/17.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "TimeLabel.h"

@protocol LocationButtonDelegate <NSObject>
- (bool)locationManagerRunning;
- (bool)startLocation;
- (bool)stopLocation;
@end

@interface SimpleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mLatitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *mLongitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *mAltitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *mSpeedTextField;
@property (weak, nonatomic) IBOutlet UIButton *mLocationManagerButton;
@property (weak, nonatomic) IBOutlet UILabel *mPlacemarkLabel;
@property (weak, nonatomic) IBOutlet TimeLabel *mTimeLabel;
@property (nonatomic, assign) id <LocationButtonDelegate> delegate;

- (void)didUpdateToLocation:(CLLocation *)newLocation
               fromLocation:(CLLocation *)oldLocation;
- (IBAction)onLocationButtonClick:(UIButton *)sender;
- (void)didUpdatePlacemark:(CLPlacemark *)newPlacemark;
@end
