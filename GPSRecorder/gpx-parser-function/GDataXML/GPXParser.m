//
//  gpx-parser.m
//  gpx-parser
//
//  Created by zhangchao on 14/8/17.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import "GPXParser.h"

int const PARSER_ERROR_UNKNOW                       = -1;
/** if file is not a xml or is not complete.*/
int const PARSER_ERROR_UNSUPPORTED                  = 0;
/** if file is not a gpx.*/
int const PARSER_ERROR_UNPARSERALBE                 = 1;

/** post all track points, track segments, tracks.*/
int const PARSER_CALLBACK_MODE_ALL                  = 0;
/** just post tracks array when all tracks parser done.*/
int const PARSER_CALLBACK_MODE_JUST_RESULT          = 1;

int const PARSER_CALLBACK_MODE_DEFAULT              = PARSER_CALLBACK_MODE_JUST_RESULT;

@implementation GPXParser {
}

- (instancetype)initWithData:(NSData *)data {
    self = [super self];
    if (self) {
        _isNeedCancel = false;
        _hasBoundsElement = false;
        unsigned long size = [data length];
        LOGD(@"initWithData size : %lu Byte, %lu KB", size, size / 1024);
        mXMLData = data;
        mXMLDoc = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
        mRootElement = [mXMLDoc rootElement];

        mAllTracks = [NSMutableArray array];

        _callbackMode = PARSER_CALLBACK_MODE_DEFAULT;
    }
    return self;
}

- (void)stopParser {
    _isNeedCancel = true;
    _delegate = nil;
}

- (void)parserMetadataElements:(GDataXMLElement *)rootElement {
    GDataXMLElement *meta = [rootElement elementsForName:ELEMENT_METADATA][0];
    NSString *name = [[meta elementsForName:ELEMENT_NAME][0] stringValue];
    LOGD(@"Metadata name : %@", name);
    //获取 bounds 节点
    GDataXMLElement *bounds = [meta elementsForName:ELEMENT_METADATA_BOUNDS][0];
    if (bounds != nil) {
        _hasBoundsElement = true;
        //获取 bounds 节点下的 maxLat, maxLng, minLat, minLng 属性
        double maxLat = [[[bounds attributeForName:ATTRIBUTE_METADATA_BOUNDS_MAXLAT] stringValue] doubleValue];
        double maxLng = [[[bounds attributeForName:ATTRIBUTE_METADATA_BOUNDS_MAXLNG] stringValue] doubleValue];
        double minLat = [[[bounds attributeForName:ATTRIBUTE_METADATA_BOUNDS_MINLAT] stringValue] doubleValue];
        double minLng = [[[bounds attributeForName:ATTRIBUTE_METADATA_BOUNDS_MINLNG] stringValue] doubleValue];
        LOGD(@"Metadata bounds is: (%f, %f) (%f, %f)", maxLat, maxLng, minLat, minLng);
        CGRect result = CGRectMake(minLat, minLng, maxLat - minLat, maxLng - minLng);
        [self postTheBoundsOfAllTracks:result needFixIt:false];
    } else {
        _hasBoundsElement = false;
        LOGD(@"no bounds founded.");
    }
}

- (void)parserRouteElements:(GDataXMLElement *)rootElement {
    NSArray *routes = [rootElement elementsForName:ELEMENT_ROUTE];
    int routesIndex = 0;
    for (GDataXMLElement *rte in routes) {
        routesIndex++;
        //获取 number 节点的值
        NSString *number = [[rte elementsForName:ELEMENT_ROUTE_NUM][0] stringValue];
        LOGD(@"route number :%@", number);

        //获取 rtept 节点
        NSArray *routePoints = [rte elementsForName:ELEMENT_ROUTE_POINT];
        int routePointIndex = 0;
        for (GDataXMLElement *rtept in routePoints) {
            routePointIndex++;
            //获取 rtept 节点下的 lat 和 lon 属性
            NSString *lat = [[rtept attributeForName:ATTRIBUTE_TRACK_POINT_LATITUDE] stringValue];
            NSString *lon = [[rtept attributeForName:ATTRIBUTE_TRACK_POINT_LONGITUDE] stringValue];
            LOGD(@"%d.%d route Point is: (%@, %@)", routesIndex, routePointIndex, lat, lon);
        }
    }
}

- (void)parserTrackElements:(GDataXMLElement *)rootElement {
    NSArray *tracks = [rootElement elementsForName:ELEMENT_TRACK];
    int tracksIndex = 0;
    unsigned long tracksCount = [tracks count];
    double curPercentage = 0;
    double tracksStep = (tracksCount == 0) ? 0.0 : (100.0 / tracksCount);

    for (GDataXMLElement *track in tracks) {
        tracksIndex++;
        //获取 name 节点的值
        NSString *name = [[track elementsForName:ELEMENT_NAME][0] stringValue];
        LOGD(@"track name is:%@", name);

        Track *trackForPost = [[Track alloc] initWithName:name];

        //获取 trkseg 节点
        NSArray *trackSegments = [track elementsForName:ELEMENT_TRACK_SEGMENT];
        int trksegIndex = 0;
        unsigned long segCount = [trackSegments count];
        double trksegStep = (segCount == 0) ? 0.0 : (tracksStep / segCount);
        for (GDataXMLElement *trkseg in trackSegments) {
            trksegIndex++;
            //获取 trkseg 节点下的 trkpt 节点
            NSArray *trackPoints = [trkseg elementsForName:ELEMENT_TRACK_POINT];
            int trkptIndex = 0;
            unsigned long trkptCount = [trackPoints count];
            double trkptStep = (trkptCount == 0) ? 0.0 : (trksegStep / trkptCount);
            //当前TrackSegment
            TrackSegment *trackSegmentForPost = [[TrackSegment alloc] init];
            for (GDataXMLElement *point in trackPoints) {
                trkptIndex++;
                //获取 trkpt 节点下的 lat 和 lon 属性, time 和 ele 节点
                double latValue = [[[point attributeForName:ATTRIBUTE_TRACK_POINT_LATITUDE] stringValue] doubleValue];
                double lonValue = [[[point attributeForName:ATTRIBUTE_TRACK_POINT_LONGITUDE] stringValue] doubleValue];
                NSDate *timeValue = [GPXSchema convertString2Time:[[point elementsForName:ELEMENT_TRACK_POINT_TIME][0] stringValue]];
                double eleValue = [[[point elementsForName:ELEMENT_TRACK_POINT_ELEVATION][0] stringValue] doubleValue];
                LOGD(@"track Point double : (%f, %f, %f), %@", latValue, lonValue, eleValue, timeValue);
                //当前TrackPoint
                TrackPoint *trackPointForPost = [[TrackPoint alloc] initWithTrack:latValue :lonValue :eleValue :timeValue];
                //发送当前TrackPoint
                if (_callbackMode == PARSER_CALLBACK_MODE_ALL)
                    [self postTrackPointOfParser:trackPointForPost];
                //将当前TrackPoint加入TrackSegment
                [trackSegmentForPost addTrackpoint:trackPointForPost];
                curPercentage = curPercentage + trkptStep;
                //发送当前进度
                [self postPercentageOfParser:curPercentage];
                // cancel it when need.
                if (_isNeedCancel) break;
            }
            //发送当前TrackSegment
            if (_callbackMode == PARSER_CALLBACK_MODE_ALL)
                [self postTrackSegmentOfParser:trackSegmentForPost];
            //将当前TrackSegment加入Track
            [trackForPost addTrackSegment:trackSegmentForPost];
            //发送当前进度
            if (trkptCount == 0) {
                curPercentage = curPercentage + trksegStep;
                [self postPercentageOfParser:curPercentage];
            }
            // cancel it when need.
            if (_isNeedCancel) break;
        }
        //发送当前Track
        if (_callbackMode == PARSER_CALLBACK_MODE_ALL)
            [self postTrackOfParser:trackForPost];
        [mAllTracks addObject:trackForPost];
//        if (_callbackMode == PARSER_CALLBACK_MODE_ALL)
//            [self postAllTracksOfParser:mAllTracks];
        //发送当前进度
        if (trksegStep == 0) {
            curPercentage = curPercentage + tracksStep;
            [self postPercentageOfParser:curPercentage];
        }
        // cancel it when need.
        if (_isNeedCancel) break;
    }
    if (_callbackMode == PARSER_CALLBACK_MODE_ALL || _callbackMode == PARSER_CALLBACK_MODE_JUST_RESULT)
        [self postAllTracksOfParser:mAllTracks];

    if (_isNeedCancel) {
        // maybe post some state??
    } else {
        [self postPercentageOfParser:100.0];
    }
}
- (void)postPercentageOfParser:(double)percentage {
    if (percentage < 0.0) percentage = 0.0;
    if (percentage > 100.0) percentage = 100.0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate onPercentageOfParser:percentage];
    });
}

- (void)postTrackPointOfParser:(TrackPoint *)point {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate trackPointDidParser:point];
    });
}

- (void)postTrackSegmentOfParser:(TrackSegment *)segment {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate trackSegmentDidParser:segment];
    });
}

- (void)postTrackOfParser:(Track *)track {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate trackDidParser:track];
    });
}

- (void)postAllTracksOfParser:(NSArray *)tracks {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate allTracksDidParser:tracks];
    });
}

- (void)postTheBoundsOfAllTracks:(CGRect)rect needFixIt:(bool)needFix {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_delegate tracksBoundsDidParser:rect needFixIt:needFix];
    });
}

- (void)parserAllElements {
    if (mRootElement == nil) {
        LOGE(@"Root Element is not found !!!");
        [_delegate onErrorWhenParser:PARSER_ERROR_UNSUPPORTED];
        return;
    } else if (![[mRootElement name] isEqualToString:ROOT_NAME]) {
        LOGE(@"This xml file's ROOT is %@, it seems not a gpx file !!!", [mRootElement name]);
        [_delegate onErrorWhenParser:PARSER_ERROR_UNPARSERALBE];
        return;
    }

    // use async to parser.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *creator = [[mRootElement attributeForName:ATTRIBUTE_ROOT_CREATOR] stringValue];
        LOGD(@"This xml file's CREATOR is %@", creator);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate rootCreatorDidParser:creator];
        });

        NSString *version = [[mRootElement attributeForName:ATTRIBUTE_ROOT_VERSION] stringValue];
        LOGD(@"This xml file's VERSION is %@", version);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate rootVersionDidParser:version];
        });

        //获取根节点下的节点（ Metadata ）
        [self parserMetadataElements:mRootElement];

        //获取根节点下的节点（ rte ）
        [self parserRouteElements:mRootElement];

        //获取根节点下的节点（ trk ）
        [self parserTrackElements:mRootElement];
    });
}


@end
