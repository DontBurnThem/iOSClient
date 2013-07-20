//
//  DBTButtonCellDelegate.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBTButtonCell;

@protocol DBTButtonCellDelegate <NSObject>
- (void)buttonCellWasClicked:(DBTButtonCell *)cell;
@end
