//
//  DBTOpenLibraryRequest.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBTOpenLibraryBookInfo : NSObject <UITableViewDataSource>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSArray *authors;
@property (nonatomic, copy) NSString *ISBN;
@property (nonatomic, copy) NSArray *publishers;
@property (nonatomic, copy) NSURL *imageURL;

+ (DBTOpenLibraryBookInfo *)bookInfoWithJSONData:(NSData *)json error:(NSError **)error;

+ (NSURLRequest *)requestForISBN:(NSString *)isbn;

+ (DBTOpenLibraryBookInfo *)fetchBookWithISBN:(NSString *)isbn;

@end
