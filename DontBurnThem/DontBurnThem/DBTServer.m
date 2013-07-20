//
//  DBTServer.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTServer.h"
#import "DBTOpenLibraryBookInfo.h"
#import "DBTOffer.h"

@interface DBTServer ()

+ (NSURLRequest *)buildGetRequestAPI:(NSString *)api;
+ (NSURLRequest *)buildPostRequestAPI:(NSString *)api fields:(NSDictionary *)dict;
+ (NSString *)urlEncodeDictionary:(NSDictionary *)dict;

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
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/%@/", [DBTServer address], api]]];
    
    [req setHTTPMethod:@"GET"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return req;
}

+ (NSString *)urlEncodeDictionary:(NSDictionary *)dict
{
    NSMutableArray *items=[[NSMutableArray alloc] initWithCapacity:dict.count];
    
    for (NSString *key in [dict allKeys]) {
        [items addObject:[NSString stringWithFormat:@"%@=%@",
                          [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                          [[dict objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          ]
         ];
    }
    
    NSString *output=[items componentsJoinedByString:@"&"];
    
    [items release];
    
    return output;
}

- (NSString *)userRef
{
#warning change this
    return [NSString stringWithFormat:@"%@/api/users/1/", [DBTServer address]];
}

- (NSString *)makeBookRef:(DBTOpenLibraryBookInfo *)book
{
    return [NSString stringWithFormat:@"%@/api/books/isbn/%@/", [DBTServer address], book.ISBN];
}

+ (NSURLRequest *)buildPostRequestAPI:(NSString *)api fields:(NSDictionary *)dict
{
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/%@/", [DBTServer address], api]]];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[[DBTServer urlEncodeDictionary:dict] dataUsingEncoding:NSUTF8StringEncoding]];
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return req;
}

- (BOOL)insertOffer:(DBTOffer *)offer error:(NSError **)err
{
    NSURLRequest *req=[DBTServer buildPostRequestAPI:@"offers"
                                              fields:@{
                       @"status": [NSString stringWithFormat:@"%d", offer.state],
                       @"price": [NSString stringWithFormat:@"%0.2f", offer.price],
                       @"user": [self userRef],
                       @"book": [self makeBookRef:offer.book],
                       @"lat": [NSString stringWithFormat:@"%f",offer.geolocation.y],
                       @"lon": [NSString stringWithFormat:@"%f",offer.geolocation.x]
                       }];
    
    NSURLResponse *resp=nil;
    [NSURLConnection sendSynchronousRequest:req
                          returningResponse:&resp
                                      error:err];
    return ([(NSHTTPURLResponse *)resp statusCode]==201);
}

- (BOOL)containsBook:(DBTOpenLibraryBookInfo *)book error:(NSError **)err
{
    NSURLResponse *resp=nil;
    [NSURLConnection sendSynchronousRequest:[DBTServer buildGetRequestAPI:[@"books/" stringByAppendingString:book.ISBN]]
                          returningResponse:&resp
                                      error:err];
    
    if (!resp) return NO;
    
    return ([(NSHTTPURLResponse *)resp statusCode]==200);
}


- (BOOL)insertBook:(DBTOpenLibraryBookInfo *)book error:(NSError **)err
{
    NSURLRequest *req=[DBTServer buildPostRequestAPI:@"books" fields:@{@"isbn": book.ISBN}];
    
    NSURLResponse *resp=nil;
    [NSURLConnection sendSynchronousRequest:req
                          returningResponse:&resp
                                      error:err];
    return ([(NSHTTPURLResponse *)resp statusCode]==201);
}

@end
