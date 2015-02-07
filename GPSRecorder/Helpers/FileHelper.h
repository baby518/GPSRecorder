//
// Created by zhangchao on 14/10/31.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject {
}

+ (NSString *) getDocumentsDirectory;
+ (NSArray *) getFilesListInDirectory:(NSString *)directory;
+ (NSArray *) getFilesListInDirectory:(NSString *)directory filterSuffix:(NSString *)suffix sortByASC:(bool) ascSort;
+ (void) removeFile:(NSString *)fileName;
+ (NSString *) getFilesName:(NSURL *)path;
+ (unsigned int)getURLLength:(NSURL *)path;
+ (NSString *)getURLSize:(NSURL *)path;
+ (long long)getFileLength:(NSString *)filePath;
+ (NSString *)getFileSize:(NSString *)filePath;
+ (NSString *)generateFilePathFromDate;
+ (NSString *)generateFilePathFromDateWithString:(NSString *)string;
+ (NSURL *)generateFileUrlFromDate;
+ (NSURL *)generateFileUrlFromDateWithString:(NSString *)string;
@end