//
//  DBTServer.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBTOpenLibraryBookInfo;

@interface DBTServer : NSObject
+ (NSString *)address;
+ (DBTServer *)server;

- (BOOL)containsBook:(NSString *)isbn error:(NSError **)err;
- (void)insertBook:(DBTOpenLibraryBookInfo *)book;
@end
