//
//  DBTOffer.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBTOpenLibraryBookInfo;

@interface DBTOffer : NSObject
@property (nonatomic, retain) DBTOpenLibraryBookInfo *book;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSUInteger state;
@property (nonatomic, assign) CGPoint geolocation;

- (id)initOfferWithBook:(DBTOpenLibraryBookInfo *)book withPrice:(CGFloat)price andState:(NSUInteger)state;
+ (DBTOffer *)offerWithBook:(DBTOpenLibraryBookInfo *)book withPrice:(CGFloat)price andState:(NSUInteger)state;
@end
