//
//  DBTServer.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBTOpenLibraryBookInfo,DBTOffer;

@interface DBTServer : NSObject
+ (NSString *)address;
+ (DBTServer *)server;

@property (nonatomic, readonly) NSString *userRef;

- (NSString *)makeBookRef:(DBTOpenLibraryBookInfo *)book;

- (BOOL)containsBook:(DBTOpenLibraryBookInfo *)book error:(NSError **)err;
- (BOOL)insertBook:(DBTOpenLibraryBookInfo *)book error:(NSError **)err;
- (BOOL)insertOffer:(DBTOffer *)offer error:(NSError **)err;
@end
