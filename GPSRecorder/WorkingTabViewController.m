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

    //获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard,
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
    mSimpleViewControler = [story instantiateViewControllerWithIdentifier:@"simpleViewControler"];
    mMapViewControler = [story instantiateViewControllerWithIdentifier:@"mapViewControler"];

    [self.view addSubview:mSimpleViewControler.view];
    [self.view addSubview:mMapViewControler.view];

    mSimpleViewControler.view.hidden = NO;
    mMapViewControler.view.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentChangedValue:(UISegmentedControl *)sender {
    int index = [sender selectedSegmentIndex];
    NSLog(@"segmentChangedValue %d", index);
    
    switch (index) {
        case 0:
            mSimpleViewControler.view.hidden = NO;
            mMapViewControler.view.hidden = YES;
            break;
        case 1:
            mSimpleViewControler.view.hidden = YES;
            mMapViewControler.view.hidden = NO;
            break;
        default:
            break;
    }
}

@end
