//
// Created by zhangchao on 14/10/31.
// Copyright (c) 2014 zhangchao. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper {

}

+ (NSString *) getDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = paths[0];
    return documentsDir;
}

+ (NSArray *) getFilesListInDirectory:(NSString *)directory {
    return [self getFilesListInDirectory:directory filterSuffix:@".*"];
}

+ (NSArray *) getFilesListInDirectory:(NSString *)directory filterSuffix:(NSString *)suffix {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *filePaths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    for (NSString *path in filePaths) {
        if ([path hasSuffix:suffix] || [suffix isEqualToString:@".*"]) {
            NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", directory, path]];
            [result addObject:url];
        }
    }
    // sort elements, default is ASC.
    [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult result = [[(NSURL*)obj1 absoluteString] compare:[(NSURL*)obj2 absoluteString]];
        if (result == NSOrderedAscending) {
            return NSOrderedAscending;
        } else if (result == NSOrderedDescending) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return result;
}

+ (void) removeFile:(NSString *)fileName {
    NSLog(@"removeFile %@", fileName);
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:fileName error:nil];
}

+ (NSString *) getFilesName:(NSString *)path {
    NSMutableArray *fileName = [NSMutableArray arrayWithArray:[[path lastPathComponent] componentsSeparatedByString:@"."]];
    [fileName removeLastObject];
    return [fileName componentsJoinedByString:@"."];
}
@end