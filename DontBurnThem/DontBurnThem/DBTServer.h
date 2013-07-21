//
//  DBTServer.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBTOpenLibraryBook,DBTOffer;

@interface DBTServer : NSObject
+ (NSString *)address;
+ (DBTServer *)server;

@property (nonatomic, readonly) NSString *userRef;

- (NSString *)makeBookRef:(DBTOpenLibraryBook *)book;

- (BOOL)containsBook:(DBTOpenLibraryBook *)book error:(NSError **)err;
- (BOOL)insertBook:(DBTOpenLibraryBook *)book error:(NSError **)err;
- (BOOL)insertOffer:(DBTOffer *)offer error:(NSError **)err;
- (NSArray *)lookForOffersHere:(CLLocationCoordinate2D)pt radius:(CGFloat)km optionalISBN:(NSString *)isbn error:(NSError **)err;
@end
