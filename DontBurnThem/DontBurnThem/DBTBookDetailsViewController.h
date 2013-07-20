//
//  DBTBookDetailsViewController.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTButtonCellDelegate.h"
@class DBTOpenLibraryBookInfo;

@interface DBTBookDetailsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, DBTButtonCellDelegate>
@property (nonatomic, retain) DBTOpenLibraryBookInfo *bookInfo;
@property (nonatomic, readonly) NSArray *bookStates;
@property (nonatomic, readonly) NSInteger currentBookState;
@end
