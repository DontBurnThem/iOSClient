//
//  DBTServer.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTServer.h"

@interface DBTServer ()

+ (NSURLRequest *)buildGetRequestAPI:(NSString *)api;
+ (NSURLRequest *)buildPostRequestAPI:(NSString *)api fields:(NSDictionary *)dict;

@end

@implementation DBTServer

+ (DBTServer *)server
{
    return [[[DBTServer alloc] init] autorelease];
}

+ (NSString *)address
{
    return @"http://dontburnthem.herokuapp.com";
}

+ (NSURLRequest *)buildGetRequestAPI:(NSString *)api
{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/%@/", [DBTServer address], api]]];
}

+ (NSURLRequest *)buildPostRequestAPI:(NSString *)api fields:(NSDictionary *)dict
{
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/%@/", [DBTServer address], api]]];
    
    for (NSString *key in [dict allKeys]) {
        
    }
    
    [req setHTTPMethod:@"POST"];

}

- (BOOL)containsISBN:(NSString *)isbn error:(NSError **)err
{
    NSURLResponse *resp=nil;
    [NSURLConnection sendSynchronousRequest:[DBTServer buildGetRequestAPI:[@"books/" stringByAppendingString:isbn]]
                          returningResponse:&resp
                                      error:err];
    
    if (!resp) return NO;

    return ([(NSHTTPURLResponse *)resp statusCode]==200);
}

- (void)insertBook:(DBTOpenLibraryBookInfo *)book
{
    NSURLRequest *req=[DBTServer buildPostRequestAPI:@"offers" fields:<#(NSDictionary *)#>];
}

@end
