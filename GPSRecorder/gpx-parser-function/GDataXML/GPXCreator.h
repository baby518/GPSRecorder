//
// Created by zhangchao on 14/12/21.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GDataXMLNode.h"
#import "FileHelper.h"
#import "GPXSchema.h"

@interface GPXCreator : NSObject

@property(nonatomic, retain) GDataXMLDocument *xmlDocument;
@property(nonatomic, retain) GDataXMLElement *rootElement;

- (id)initWithName:(NSString *)creator;
- (id)initWithName:(NSString *)creator version:(NSString *)version;
- (void)addLocation:(CLLocation *)location;
- (void)addElement:(GDataXMLNode *)element;
- (void)stop;
- (void)saveFile:(NSString *)filePath;

@end