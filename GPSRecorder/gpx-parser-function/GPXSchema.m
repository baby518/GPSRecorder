//
// Created by zhangchao on 14/10/26.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import "GPXSchema.h"

NSString * const ROOT_NAME                          = @"gpx";
NSString * const ATTRIBUTE_ROOT_CREATOR             = @"creator";
NSString * const ATTRIBUTE_ROOT_VERSION             = @"version";

NSString * const ELEMENT_ROUTE                      = @"rte";
NSString * const ELEMENT_ROUTE_NUM                  = @"number";
NSString * const ELEMENT_ROUTE_POINT                = @"rtept";

NSString * const ELEMENT_NAME                       = @"name";
NSString * const ELEMENT_TRACK                      = @"trk";
NSString * const ELEMENT_TRACK_SEGMENT              = @"trkseg";

NSString * const ELEMENT_TRACK_POINT                = @"trkpt";
NSString * const ATTRIBUTE_TRACK_POINT_LATITUDE     = @"lat";
NSString * const ATTRIBUTE_TRACK_POINT_LONGITUDE    = @"lon";
NSString * const ELEMENT_TRACK_POINT_TIME           = @"time";
NSString * const ELEMENT_TRACK_POINT_ELEVATION      = @"ele";

@implementation GPXSchema
+ (NSDate *)convertString2Time:(NSString *)string {
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    //2013-11-02T15:34:49Z
    //@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    [timeFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'"];
    NSDate *result = [timeFormatter dateFromString:string];
    if (result == nil) {
        [timeFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss''Z'"];
        result = [timeFormatter dateFromString:string];
    }
    LOGD(@"convertString2Time %@", result);
    return result;
}

+ (NSString *) convertTime2String:(NSDate *)time {
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    //2013-11-02T15:34:49Z
    //@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
    [timeFormatter setDateFormat:@"yyyy'-'MM'-'dd'-'HH':'mm':'ss'.'SSS"];
    NSString *dateString = [timeFormatter stringFromDate:time];
    if ([dateString length] == 0) {
        [timeFormatter setDateFormat:@"yyyy'-'MM'-'dd'-'HH':'mm':'ss'"];
        dateString = [timeFormatter stringFromDate:time];
    }
    return dateString;
}
@end