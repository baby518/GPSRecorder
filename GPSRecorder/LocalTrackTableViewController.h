//
//  LocalTrackTableViewController.h
//  GPSRecorder
//
//  Created by zhangchao on 14/11/19.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileHelper.h"
#import "MapViewController.h"

@interface LocalTrackTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mLocalTrackTableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mDeleteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *mRefreshButton;
@property (strong, nonatomic) NSMutableArray *trackFiles;

- (IBAction)onDeleteClick:(UIBarButtonItem *)sender;
- (IBAction)onRefreshClick:(UIBarButtonItem *)sender;

- (void)refreshFilesList;
- (NSData *)loadDataFromURL:(NSURL *)fileURL;
- (NSData *)loadDataFromPath:(NSString *)filePath;
- (void)updateDeleteButtonTitle;
- (void)updateEditButtonTitle;
@end
