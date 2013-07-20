//
//  UITableView+Utils.h
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Utils)
- (UITableViewCell *)dequeueOrCreateCellWithIdentifier:(NSString *)identifier andClass:(Class)cls;
@end
