//
//  DBTOffer.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTOffer.h"

@implementation DBTOffer
+ (DBTOffer *)offerWithBook:(DBTOpenLibraryBookInfo *)book withPrice:(CGFloat)price andState:(NSUInteger)state
{
    return [[[DBTOffer alloc] initOfferWithBook:book
                                      withPrice:price
                                       andState:state] autorelease];
}

- (id)initOfferWithBook:(DBTOpenLibraryBookInfo *)book withPrice:(CGFloat)price andState:(NSUInteger)state
{
    if ((self=[super init])) {
        self.book=book;
        self.price=price;
        self.state=state;
    }
    return self;
}
@end
