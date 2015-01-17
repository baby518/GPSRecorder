//
// Created by zhangchao on 15/1/17.
// Copyright (c) 2015 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TimeLabel : UILabel

@property (nonatomic, strong, readonly) NSTimer *mTimer;
@property (nonatomic, strong, readonly) NSDate *mStartedDate;
@property (nonatomic, strong, readonly) NSDate *mPausedDate;

- (instancetype)init;
- (void)updateLabel;
- (void)initTimer;
- (void)startTimer;
- (void)pauseTimer;
- (void)resetTimer;
@end