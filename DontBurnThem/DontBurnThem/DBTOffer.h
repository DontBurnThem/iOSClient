//
//  DBTOffer.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBTOpenLibraryBook;

@interface DBTOffer : NSObject <MKAnnotation>
@property (nonatomic, retain) DBTOpenLibraryBook *book;
@property (nonatomic, copy) NSString *bookRef;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSUInteger state;
@property (nonatomic, assign) CLLocationCoordinate2D location;
@property (nonatomic, copy) NSString *userRef;


+ (NSArray *)bookStates;

- (id)initOfferWithBook:(DBTOpenLibraryBook *)book withPrice:(CGFloat)price andState:(NSUInteger)state;
+ (DBTOffer *)offerWithBook:(DBTOpenLibraryBook *)book withPrice:(CGFloat)price andState:(NSUInteger)state;

- (void)pushAsynchronouslyToServer:(void (^)(BOOL, NSError *))cbk;
- (BOOL)pushSynchronouslyToServerError:(NSError **)err;

- (NSString *)isbnFromBookRef;
@end
