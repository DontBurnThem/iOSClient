//
//  NSDictionary+Utils.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 21/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (stringWithURLEncoding)
- (NSString *)stringWithURLEncoding
{
    NSMutableArray *items=[[NSMutableArray alloc] initWithCapacity:self.count];
    
    for (NSString *key in [self allKeys]) {
        [items addObject:[NSString stringWithFormat:@"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                          [[self objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          ]
         ];
    }
    
    NSString *output=[items componentsJoinedByString:@"&"];
    
    [items release];
    
    return output;
}
@end
