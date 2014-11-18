//
// Created by zhangchao on 14/10/27.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FILE [[NSString stringWithUTF8String:__FILE__] lastPathComponent]
#define LINE __LINE__
#define DEBUG_FORMAT   (@"DEBUG    <%@:(%d)> %@")
#define WARNING_FORMAT (@"WARNING  <%p %@:(%d)> %@")
#define ERROR_FORMAT   (@"ERROR    <%p %@:(%d)> %@")
#if DEBUG
#define LOGD(f, ...) NSLog(DEBUG_FORMAT, FILE, LINE, [NSString stringWithFormat:(f), ##__VA_ARGS__])
#else
#define LOGD(format, ...)
#endif
#define LOGW(f, ...) NSLog(WARNING_FORMAT, self, FILE, LINE, [NSString stringWithFormat:(f), ##__VA_ARGS__])
#define LOGE(f, ...) NSLog(ERROR_FORMAT, self, FILE, LINE, [NSString stringWithFormat:(f), ##__VA_ARGS__])


#if DEBUG
#  define LOG(fmt, ...) do {                                            \
        NSString* file = [[NSString alloc] initWithFormat:@"%s", __FILE__]; \
        NSLog((@"%@(%d) " fmt), [file lastPathComponent], __LINE__, ##__VA_ARGS__); \
        [file release];                                                 \
    } while(0)
#  define LOG_METHOD NSLog(@"%s", __func__)
#  define LOG_CMETHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#  define COUNT(p) NSLog(@"%s(%d): count = %d\n", __func__, __LINE__, [p retainCount]);
#  define LOG_TRACE(x) do {printf x; putchar('\n'); fflush(stdout);} while (0)
#else
#  define LOG(...)
#  define LOG_METHOD
#  define LOG_CMETHOD
#  define COUNT(p)
#  define LOG_TRACE(x)
#endif

@interface GPXLog : NSObject

@end