//
//  DBTBookDetailsViewController.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTButtonCellDelegate.h"
@class DBTOpenLibraryBook;

@interface DBTBookDetailsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, DBTButtonCellDelegate, UITextFieldDelegate>
@property (nonatomic, retain) DBTOpenLibraryBook *book;
@property (nonatomic, readonly) NSArray *bookStates;
@property (nonatomic, readonly) NSInteger state;
@property (nonatomic, readonly) CGFloat price;
@property (nonatomic, readonly) CLLocationCoordinate2D location;

@end
