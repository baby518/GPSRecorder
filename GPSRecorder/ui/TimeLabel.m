//
// Created by zhangchao on 15/1/17.
// Copyright (c) 2015 zhangchao. All rights reserved.
//

#import "TimeLabel.h"

@implementation TimeLabel {

}

- (instancetype)init {
    self = [super self];
    if (self) {
        [self initTimer];
    }
    return self;
}

- (void)updateLabel {
    NSTimeInterval interval = [_mStartedDate timeIntervalSinceNow];
    NSLog(@"timerFireMethod timeIntervalSinceNow : %f", fabs(interval));
    self.text = [NSString stringWithFormat:@"%d", (int)(floor(fabs(interval) + 0.5))];
}

- (void)initTimer {
    if (_mTimer) {
        [_mTimer invalidate];
        _mTimer = nil;
    }
    _mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    [_mTimer setFireDate:[NSDate distantFuture]]; // pause
}

- (void)startTimer {
    if (!_mTimer) {
        [self initTimer];
    }
    [_mTimer setFireDate:[NSDate distantPast]]; // start
    _mStartedDate = [NSDate date];
}

- (void)pauseTimer {
    [_mTimer setFireDate:[NSDate distantFuture]]; // pause
}

- (void)resetTimer {
    [_mTimer invalidate];
    _mTimer = nil;
}

@end