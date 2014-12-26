//
// Created by zhangchao on 14/12/21.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import "GPXCreator.h"

@implementation GPXCreator {

}

- (id)initWithName:(NSString *)creator {
    return [self initWithName:creator version:@"0.1"];
}
- (id)initWithName:(NSString *)creator version:(NSString *)version {
    self = [super self];
    if (self) {
        _locations = [NSMutableArray array];
        _rootElement = [GDataXMLNode elementWithName:ROOT_NAME];
        // namespace
        [_rootElement addAttribute:[GDataXMLNode attributeWithName:XML_NAMESPACE stringValue:XML_NAMESPACE_STRING]];
        [_rootElement addAttribute:[GDataXMLNode attributeWithName:XML_NAMESPACE_XSI stringValue:XML_NAMESPACE_XSI_STRING]];
        [_rootElement addAttribute:[GDataXMLNode attributeWithName:XML_NAMESPACE_SCHEMA stringValue:XML_NAMESPACE_SCHEMA_STRING]];
        // creator
        [_rootElement addAttribute:[GDataXMLNode attributeWithName:ATTRIBUTE_ROOT_CREATOR stringValue:creator]];
        // version
        [_rootElement addAttribute:[GDataXMLNode attributeWithName:ATTRIBUTE_ROOT_VERSION stringValue:version]];
    }
    return self;
}

- (void)addLocation:(CLLocation *)location {
    [_locations addObject:location];
}

- (void)addLocations:(NSArray *)locations {
    [_locations addObjectsFromArray:locations];
}

- (void)stop {
    GDataXMLElement *lastTrkElement;
    lastTrkElement = [GDataXMLNode elementWithName:ELEMENT_TRACK];

    GDataXMLElement *lastTrksegElement;
    lastTrksegElement = [GDataXMLNode elementWithName:ELEMENT_TRACK_SEGMENT];

    int count = 0;
    for (CLLocation *location in _locations) {
        // if count > MAX, alloc a new track segment to store.
//        if (count == MAX_ELEMENT_COUNTS_OF_TRACK) {
//            [lastTrkElement addChild:lastTrksegElement];
//            lastTrksegElement = [GDataXMLNode elementWithName:ELEMENT_TRACK_SEGMENT];
//            count = 0;
//        }
        // if count > MAX, alloc a new track to store.
        if (count == MAX_ELEMENT_COUNTS_OF_TRACK) {
            [lastTrkElement addChild:lastTrksegElement];
            [_rootElement addChild:lastTrkElement];
            lastTrkElement = [GDataXMLNode elementWithName:ELEMENT_TRACK];
            lastTrksegElement = [GDataXMLNode elementWithName:ELEMENT_TRACK_SEGMENT];
            count = 0;
        }
        GDataXMLElement *trkptElement = [GDataXMLNode elementWithName:ELEMENT_TRACK_POINT];
        NSString *latString = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        NSString *lonString = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
        [trkptElement addAttribute:[GDataXMLNode attributeWithName:ATTRIBUTE_TRACK_POINT_LATITUDE stringValue:latString]];
        [trkptElement addAttribute:[GDataXMLNode attributeWithName:ATTRIBUTE_TRACK_POINT_LONGITUDE stringValue:lonString]];

        if (location.timestamp != nil) {
            GDataXMLElement *timeElement = [GDataXMLNode elementWithName:ELEMENT_TRACK_POINT_TIME];
            [timeElement setStringValue:[GPXSchema convertTime2String:location.timestamp]];
            [trkptElement addChild:timeElement];
        }

        if (location.altitude != 0.0) {
            NSString *eleString = [NSString stringWithFormat:@"%f",location.altitude];
            GDataXMLElement *eleElement = [GDataXMLNode elementWithName:ELEMENT_TRACK_POINT_ELEVATION];
            [eleElement setStringValue:eleString];
            [trkptElement addChild:eleElement];
        }

        [lastTrksegElement addChild:trkptElement];
        count++;
    }

    [lastTrkElement addChild:lastTrksegElement];
    [_rootElement addChild:lastTrkElement];

    _xmlDocument = [[GDataXMLDocument alloc] initWithRootElement:_rootElement];
    [_xmlDocument setCharacterEncoding:@"UTF-8"];
}

- (void)saveFilePath:(NSString *)filePath {
    NSData *xmlData = _xmlDocument.XMLData;

    NSLog(@"GPXCreator filePath : %@", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

- (void)saveFileUrl:(NSURL *)fileUrl {
    NSData *xmlData = _xmlDocument.XMLData;

    NSLog(@"GPXCreator fileUrl : %@", fileUrl);
    [xmlData writeToURL:fileUrl atomically:YES];
}
@end