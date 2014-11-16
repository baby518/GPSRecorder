//
//  FirstViewController.h
//  GPSRecorder
//
//  Created by zhangchao on 14/11/3.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkingTabViewController : UIViewController {
    UIViewController *mSimpleViewControler;
    UIViewController *mMapViewControler;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *mSegmentedControl;
- (IBAction)segmentChangedValue:(UISegmentedControl *)sender;

@end

