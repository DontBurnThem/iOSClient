//
//  DBTBookDetailsViewController.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTButtonCellDelegate.h"
@class DBTOpenLibraryBook, DBTOffer;

@interface DBTOfferController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, DBTButtonCellDelegate, UITextFieldDelegate, MKMapViewDelegate>

@property (nonatomic, assign, getter=isReadOnly) BOOL readOnly;
@property (nonatomic, retain) DBTOffer *offer;

@end
