//
//  SimpleViewController.m
//  GPSRecorder
//
//  Created by zhangchao on 14/11/17.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import "SimpleViewController.h"

@interface SimpleViewController ()

@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)didUpdateToLocation:(CLLocation *)newLocation
               fromLocation:(CLLocation *)oldLocation {
    double lat = newLocation.coordinate.latitude;
    double lon = newLocation.coordinate.longitude;
    double alt = newLocation.altitude;
    [_mLatitudeTextField setText:[NSString stringWithFormat:@"%.3f", lat]];
    [_mLongitudeTextField setText:[NSString stringWithFormat:@"%.3f", lon]];
    [_mAltitudeTextField setText:[NSString stringWithFormat:@"%.3f", alt]];
}
@end
