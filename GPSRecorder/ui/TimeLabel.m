//
// Created by zhangchao on 15/1/17.
// Copyright (c) 2015 zhangchao. All rights reserved.
//

#import "TimeLabel.h"

@implementation TimeLabel {

}

- (void)updateLabel {
    _curTimeInterval = floor(fabs([_mStartedDate timeIntervalSinceNow]) + 0.5);
    self.text = [self formatTimerString:(int) (_lastTimeInterval + _curTimeInterval)];
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
    self.text = [self formatTimerString : 0];
    _isTimerRunning = false;
    _lastTimeInterval = 0;
    _curTimeInterval = 0;
}

/** MAX is 99:59:59 */
- (NSString *)formatTimerString:(int)timeInterval {
    int hour = timeInterval / 3600 % 100;
    int minute = timeInterval / 60 % 60;
    int second = timeInterval % 60;
    NSString *result = [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second];
    return result;
}
@end