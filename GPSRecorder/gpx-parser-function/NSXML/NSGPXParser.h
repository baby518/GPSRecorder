//
//  NSGPXParser.h
//  gpx-parser
//
//  Created by zhangchao on 14/12/12.
//  Copyright (c) 2014年 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "TrackPoint.h"
#import "TrackSegment.h"
#import "Track.h"
#import "GPXSchema.h"
#import "GPXLog.h"

/** @author zhangchao
*  @since 2014-10-27
*  @data 2014-10-27
*  @brief Delegate for View.*/
@protocol NSGPXParserDelegate <NSObject>
@optional
- (void)onErrorWhenParser:(NSInteger)errorCode;
- (void)rootCreatorDidParser:(NSString *)creator;
- (void)rootVersionDidParser:(NSString *)version;
- (void)allTracksDidParser:(NSArray *)tracks;
- (void)tracksBoundsDidParser:(CGRect)rect needFixIt:(bool)needFix;
@end

@interface NSGPXParser : NSObject <NSXMLParserDelegate>

@property(nonatomic, assign) id <NSGPXParserDelegate> delegate;
@property(nonatomic, strong) NSXMLParser *gpxParser;
@property(nonatomic, strong, readonly) NSData *mXMLData;
@property(nonatomic, assign, readonly) bool isNeedCheckRootElement;
@property(nonatomic, assign, readonly) bool storingCharacters;
@property(nonatomic, assign, readonly) NSString *currentElement;
@property(nonatomic, strong, readonly) TrackPoint *currentTrackPoint;
@property(nonatomic, strong, readonly) TrackSegment *currentTrackSegment;
@property(nonatomic, strong, readonly) Track *currentTrack;
@property(nonatomic, strong, readonly) NSMutableArray *mAllTracks;
@property (nonatomic, assign, readonly) bool isNeedCancel;

- (id)initWithData:(NSData *)data;

- (void)satrtParser;
- (void)stopParser;
@end
