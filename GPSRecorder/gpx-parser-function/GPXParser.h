//
//  gpx-parser.h
//  gpx-parser
//
//  Created by zhangchao on 14/8/17.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import "GPXSchema.h"
#import "GPXLog.h"
#import "TrackPoint.h"
#import "TrackSegment.h"
#import "Track.h"

extern int const PARSER_ERROR_UNKNOW;
/** if file is not a xml or is not complete.*/
extern int const PARSER_ERROR_UNSUPPORTED;
/** if file is not a gpx.*/
extern int const PARSER_ERROR_UNPARSERALBE;

extern int const PARSER_CALLBACK_MODE_DEFAULT;
/** post all track points, track segments, tracks.*/
extern int const PARSER_CALLBACK_MODE_ALL;
/** just post tracks array when all tracks parser done.*/
extern int const PARSER_CALLBACK_MODE_JUST_RESULT;

/** @author zhangchao
*  @since 2014-10-27
*  @data 2014-10-27
*  @brief Delegate for View.*/
@protocol GPXParserDelegate <NSObject>
/** PARSER_ERROR_UNSUPPORTED or PARSER_ERROR_UNPARSERALBE */
- (void)onErrorWhenParser:(int)errorCode;
- (void)rootCreatorDidParser:(NSString *)creator;
- (void)rootVersionDidParser:(NSString *)version;
- (void)onPercentageOfParser:(double)percentage;
- (void)trackPointDidParser:(TrackPoint *)trackPoint;
- (void)trackSegmentDidParser:(TrackSegment *)segment;
- (void)trackDidParser:(Track *)track;
- (void)allTracksDidParser:(NSArray *)tracks;
- (void)tracksBoundsDidParser:(CGRect)rect needFixIt:(bool)needFix;
@end

/** @author zhangchao
 *  @since 2014-8-18
 *  @data 2014-10-26
 *  @brief used for parse the gpx file.*/
@interface GPXParser : NSObject {
    NSData *mXMLData;
    GDataXMLDocument *mXMLDoc;
    GDataXMLElement *mRootElement;
    // a gpx file maybe has many tracks, so save them in a array;
    NSMutableArray *mAllTracks;
}

@property (nonatomic, assign) id <GPXParserDelegate> delegate;
@property (nonatomic, assign) int callbackMode;
@property (nonatomic, assign, readonly) bool isNeedCancel;
@property (nonatomic, assign, readonly) bool hasBoundsElement;

- (id)initWithData:(NSData *)data;
- (void)parserAllElements;
- (void)parserRouteElements:(GDataXMLElement *)rootElement;
- (void)parserMetadataElements:(GDataXMLElement *)rootElement;
- (void)parserTrackElements:(GDataXMLElement *)rootElement;
- (void)postPercentageOfParser:(double)percentage;
- (void)postTrackPointOfParser:(TrackPoint *)point;
- (void)postTrackSegmentOfParser:(TrackSegment *)segment;
- (void)postTrackOfParser:(Track *)track;
- (void)postAllTracksOfParser:(NSArray *)tracks;
- (void)postTheBoundsOfAllTracks:(CGRect)rect needFixIt:(bool)needFix;

- (void)stopParser;
@end
