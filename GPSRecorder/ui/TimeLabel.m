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

- (bool) isInitialized {
    if (_mTimer) {
        return true;
    }
    return false;
}
- (void)updateLabel {
    NSTimeInterval interval = [_mStartedDate timeIntervalSinceNow];
    _curTimeInterval = floor(fabs(interval) + 0.5);
    self.text = [NSString stringWithFormat:@"%d", (int)(_lastTimeInterval + _curTimeInterval)];
}

- (void)initTimer {
    NSLog(@"initTimer");
    if (_mTimer) {
        [self resetTimer];
    }
    _mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    [_mTimer setFireDate:[NSDate distantFuture]]; // pause
}

- (void)startTimer {
    if (![self isInitialized]) {
        [self initTimer];
    }
    [_mTimer setFireDate:[NSDate distantPast]]; // start
    _mStartedDate = [NSDate date];
    _isTimerRunning = true;
}

- (void)pauseTimer {
    [_mTimer setFireDate:[NSDate distantFuture]]; // pause
    _lastTimeInterval = _lastTimeInterval + _curTimeInterval;
    _isTimerRunning = false;
}

- (void)resetTimer {
    [_mTimer invalidate];
    _mTimer = nil;
    self.text = @"0";
    _isTimerRunning = false;
    _lastTimeInterval = 0;
    _curTimeInterval = 0;
}

@end