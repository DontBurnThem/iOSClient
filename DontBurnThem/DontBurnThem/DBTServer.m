//
//  DBTServer.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTServer.h"
#import "DBTOpenLibraryBook.h"
#import "DBTOffer.h"
#import "DBTAppDelegate.h"

@interface DBTServer ()

+ (NSURLRequest *)buildGetRequestAPI:(NSString *)api;
+ (NSURLRequest *)buildPostRequestAPI:(NSString *)api fields:(NSDictionary *)dict;
+ (NSURLRequest *)buildGetRequestAPI:(NSString *)api fields:(NSDictionary *)dict;

@end

@implementation DBTServer

+ (DBTServer *)server
{
    return [(DBTAppDelegate *)[UIApplication sharedApplication].delegate server];
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

- (NSString *)userRef
{
#warning change this
    return [NSString stringWithFormat:@"%@/api/users/1/", [DBTServer address]];
}

- (NSString *)makeBookRef:(DBTOpenLibraryBook *)book
{
    return [NSString stringWithFormat:@"%@/api/books/%@/", [DBTServer address], book.ISBN];
}

+ (NSURLRequest *)buildGetRequestAPI:(NSString *)api fields:(NSDictionary *)dict
{
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/%@?%@", [DBTServer address], api, [dict stringWithURLEncoding]]]];
    
    [req setHTTPMethod:@"GET"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    return req;
}

+ (NSURLRequest *)buildPostRequestAPI:(NSString *)api fields:(NSDictionary *)dict
{
    NSMutableURLRequest *req=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/api/%@/", [DBTServer address], api]]];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[[dict stringWithURLEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
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
                       @"lat": [NSString stringWithFormat:@"%f",offer.location.latitude],
                       @"lon": [NSString stringWithFormat:@"%f",offer.location.longitude]
                       }];
    
    NSURLResponse *resp=nil;
    [NSURLConnection sendSynchronousRequest:req
                          returningResponse:&resp
                                      error:err];
    return ([(NSHTTPURLResponse *)resp statusCode]==201);
}

- (NSArray *)lookForOffersHere:(CLLocationCoordinate2D)pt radius:(CGFloat)km optionalISBN:(NSString *)isbn error:(NSError **)err
{
    NSDictionary *fields=(isbn ?
                          @{
                          @"radius": [NSString stringWithFormat:@"%f", km],
                          @"ll": [NSString stringWithFormat:@"%f,%f", pt.latitude, pt.longitude],
                          @"isbn": isbn
                          }
                          :
                          @{
                          @"radius": [NSString stringWithFormat:@"%f", km],
                          @"ll": [NSString stringWithFormat:@"%f,%f", pt.latitude, pt.longitude]
                          }
                          );
    
    NSURLRequest *req=[DBTServer buildGetRequestAPI:@"offers/search"
                                             fields: fields];
    
    NSData *result=[NSURLConnection sendSynchronousRequest:req
                                         returningResponse:NULL
                                                     error:err];
    
    if (!result) return nil;
    
    // now parse results
}

- (BOOL)containsBook:(DBTOpenLibraryBook *)book error:(NSError **)err
{
    NSURLResponse *resp=nil;
    [NSURLConnection sendSynchronousRequest:[DBTServer buildGetRequestAPI:[@"books/" stringByAppendingString:book.ISBN]]
                          returningResponse:&resp
                                      error:err];
    
    if (!resp) return NO;
    
    return ([(NSHTTPURLResponse *)resp statusCode]==200);
}


- (BOOL)insertBook:(DBTOpenLibraryBook *)book error:(NSError **)err
{
    NSURLRequest *req=[DBTServer buildPostRequestAPI:@"books" fields:@{@"isbn": book.ISBN}];
    
    NSURLResponse *resp=nil;
    [NSURLConnection sendSynchronousRequest:req
                          returningResponse:&resp
                                      error:err];
    return ([(NSHTTPURLResponse *)resp statusCode]==201);
}

@end
