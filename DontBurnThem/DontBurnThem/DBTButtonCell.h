//
//  DBTButtonCell.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTButtonCellDelegate.h"

@interface DBTButtonCell : UITableViewCell
@property (nonatomic, assign) IBOutlet id <DBTButtonCellDelegate> delegate;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@end
