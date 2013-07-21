//
//  DBTOfferCell.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBTOffer;

@interface DBTOfferCell : UITableViewCell
- (void)loadOffer:(DBTOffer *)offer fromLocation:(CLLocation *)loc;
@end
