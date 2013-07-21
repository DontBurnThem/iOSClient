//
//  NSString+Utils.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)
- (NSString *)lowercaseStringAndRemoveWhitespace
{
    return [[self lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
@end
