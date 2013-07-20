//
//  UITableView+Utils.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "UITableView+Utils.h"

@implementation UITableView (Utils)
- (UITableViewCell *)dequeueOrCreateCellWithIdentifier:(NSString *)identifier andClass:(Class)cls
{
    UITableViewCell *cell=[self dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
        cell=[[(UITableViewCell *)[cls alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:identifier] autorelease];
    
    return cell;
}
@end
