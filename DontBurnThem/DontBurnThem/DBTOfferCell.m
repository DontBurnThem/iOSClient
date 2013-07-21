//
//  DBTOfferCell.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTOfferCell.h"
#import "DBTOffer.h"
#import "DBTOpenLibraryBook.h"

@implementation DBTOfferCell
- (void)loadOffer:(DBTOffer *)offer fromLocation:(CLLocation *)loc
{
    [(UILabel *)[self viewWithTag:1] setText:(offer.book ? offer.book.title : [offer isbnFromBookRef])];
    [(UILabel *)[self viewWithTag:2] setText:[NSString stringWithFormat:@"%0.2f", offer.price]];
    [(UILabel *)[self viewWithTag:3] setText:[[DBTOffer bookStates] objectAtIndex:offer.state]];
    CLLocation *loc1=[[CLLocation alloc] initWithLatitude:offer.location.latitude
                                                longitude:offer.location.longitude];
    if (loc) {
        [(UILabel *)[self viewWithTag:4] setText:[NSString stringWithFormat:@"%f", [loc distanceFromLocation:loc1]]];
    } else {
        [(UILabel *)[self viewWithTag:4] setText:@"-"];
    }
    
    [loc1 release];
}
@end
