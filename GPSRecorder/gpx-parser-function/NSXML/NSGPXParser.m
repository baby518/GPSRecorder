//
//  NSGPXParser.m
//  gpx-parser
//
//  Created by zhangchao on 14/12/12.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import "NSGPXParser.h"

@implementation NSGPXParser

- (id)initWithData:(NSData *)data {
    self = [super self];
    if (self) {
        unsigned long size = [data length];
        LOGD(@"initWithData size : %lu Byte, %lu KB", size, size / 1024);
        _mXMLData = data;
        _currentElement = @"";
        _mAllTracks = [NSMutableArray array];
    }
    return self;
}

- (void)satrtParser {
    LOGD(@"satrtParser");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _isNeedCheckRootElement = true;
        _gpxParser = [[NSXMLParser alloc] initWithData:_mXMLData];
        _gpxParser.delegate = self;
        [_gpxParser setShouldProcessNamespaces:YES];
        [_gpxParser setShouldReportNamespacePrefixes:YES];
        [_gpxParser setShouldResolveExternalEntities:YES];
        [_gpxParser parse];
    });
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    LOGD(@"parserDidStartDocument");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    LOGD(@"parserDidEndDocument");
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    LOGD(@"parseErrorOccurred %@", parseError);
    [_delegate onErrorWhenParser:parseError.code];
}

/*
 * Sent by a parser object to its delegate when it encounters a start tag for a given element.
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    LOGD(@"didStartElement elementName : %@", elementName);
    if (attributeDict.count > 0) {
        LOGD(@"didStartElement attributeDict : %@", attributeDict);
    }

    if (_isNeedCheckRootElement) {
        if (![elementName isEqualToString:ROOT_NAME]) {
            LOGD(@"parseErrorOccurred : is not a gpx file.");
            /* if file is not a gpx. Like GPXParser's PARSER_ERROR_UNPARSERALBE.*/
            [_delegate onErrorWhenParser:1];
            [parser abortParsing];
        } else {
            _isNeedCheckRootElement = false;
        }
    }

    if ([elementName isEqualToString:ROOT_NAME]) {
        NSString *creator = attributeDict[ATTRIBUTE_ROOT_CREATOR];//[attributeDict objectForKey:ATTRIBUTE_ROOT_CREATOR];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate rootCreatorDidParser:creator];
        });
        NSString *version = attributeDict[ATTRIBUTE_ROOT_VERSION];//[attributeDict objectForKey:ATTRIBUTE_ROOT_VERSION];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate rootVersionDidParser:version];
        });
    } else if ([elementName isEqualToString:ELEMENT_ROUTE]) {

    } else if ([elementName isEqualToString:ELEMENT_TRACK]) {
        _currentTrack = [[Track alloc] init];
    } else if ([elementName isEqualToString:ELEMENT_TRACK_SEGMENT]) {
        _currentTrackSegment = [[TrackSegment alloc] init];
    } else if ([elementName isEqualToString:ELEMENT_TRACK_POINT]) {
        //获取 trkpt 节点下的 lat 和 lon 属性
        double lat = [attributeDict[ATTRIBUTE_TRACK_POINT_LATITUDE] doubleValue];
        double lon = [attributeDict[ATTRIBUTE_TRACK_POINT_LONGITUDE] doubleValue];
        LOGD(@"track Point is: (%f, %f)", lat, lon);
        _currentTrackPoint = [[TrackPoint alloc] initWithTrack:lat :lon :0 :nil];
    } else if ([elementName isEqualToString:ELEMENT_ROUTE_POINT]) {
        //获取 rtept 节点下的 lat 和 lon 属性
        NSString *lat = attributeDict[ATTRIBUTE_TRACK_POINT_LATITUDE];
        NSString *lon = attributeDict[ATTRIBUTE_TRACK_POINT_LONGITUDE];
        LOGD(@"route Point is: (%@, %@)", lat, lon);
    } else if ([elementName isEqualToString:ELEMENT_METADATA_BOUNDS]) {
        // metadata's bound.
        double maxLat = [attributeDict[ATTRIBUTE_METADATA_BOUNDS_MAXLAT] doubleValue];
        double maxLng = [attributeDict[ATTRIBUTE_METADATA_BOUNDS_MAXLNG] doubleValue];
        double minLat = [attributeDict[ATTRIBUTE_METADATA_BOUNDS_MINLAT] doubleValue];
        double minLng = [attributeDict[ATTRIBUTE_METADATA_BOUNDS_MINLNG] doubleValue];
        LOGD(@"metadata bound is: (%f, %f) - (%f, %f)", maxLat, maxLng, minLat, minLng);
        CGRect result = CGRectMake(minLat, minLng, maxLat - minLat, maxLng - minLng);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate tracksBoundsDidParser:result needFixIt:false];
        });
    }
    _currentElement = elementName;
    _storingCharacters = true;
}

/*
 *
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    LOGD(@"didEndElement elementName : %@", elementName);

    if ([elementName isEqualToString:ELEMENT_TRACK_POINT]) {
        LOGD(@"didEndElement _currentTrackPoint : (%f, %f) %f time : %@",
                _currentTrackPoint.getLocation.coordinate.latitude,
                _currentTrackPoint.getLocation.coordinate.longitude,
                _currentTrackPoint.getLocation.altitude,
                [GPXSchema convertTime2String:_currentTrackPoint.getLocation.timestamp]);
        [_currentTrackSegment addTrackpoint:_currentTrackPoint];
        _currentTrackPoint = nil;
    } else if ([elementName isEqualToString:ELEMENT_TRACK_SEGMENT]) {
        [_currentTrack addTrackSegment:_currentTrackSegment];
        _currentTrackSegment = nil;
    } else if ([elementName isEqualToString:ELEMENT_TRACK]) {
        [_mAllTracks addObject:_currentTrack];
        _currentTrack = nil;
    } else if ([elementName isEqualToString:ROOT_NAME]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate allTracksDidParser:_mAllTracks];
        });
    }
    _storingCharacters = false;
}

/*
 * The parser object may send the delegate several parser:foundCharacters: messages to report the characters of an element.
 * Because string may be only part of the total character content for the current element,
 * you should append it to the current accumulation of characters until the element changes.
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!_storingCharacters) return;

    if ([_currentElement isEqualToString:ELEMENT_TRACK_POINT_ELEVATION]) {
        _currentTrackPoint.elevation = [string doubleValue];
    } else if ([_currentElement isEqualToString:ELEMENT_TRACK_POINT_TIME]) {
        _currentTrackPoint.time = [GPXSchema convertString2Time:string];
    }
}

@end
