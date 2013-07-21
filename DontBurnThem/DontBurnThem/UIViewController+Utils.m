//
//  UIViewController+Utils.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)
- (void)dismiss
{
    if ([[NSThread currentThread] isMainThread]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:NO];
    }
}
@end
