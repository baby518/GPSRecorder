//
//  LocalTrackTableViewController.h
//  GPSRecorder
//
//  Created by zhangchao on 14/11/19.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocalTrackTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mLocalTrackTableView;
@property (strong, nonatomic) NSMutableArray *trackFiles;

@end
