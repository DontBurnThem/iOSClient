//
//  DBTOpenLibraryRequest.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTOpenLibraryBook.h"

@interface DBTOpenLibraryBook ()

+ (NSArray *)bookInfoWithJSONData:(NSData *)json error:(NSError **)error;
+ (DBTOpenLibraryBook *)oneBookInfoWithJSONData:(NSData *)json error:(NSError **)error;

+ (NSURLRequest *)requestForISBN:(NSString *)isbn;
+ (NSURLRequest *)requestForISBNs:(NSArray *)isbns;
+ (NSURLRequest *)requestForOLID:(NSString *)olid;
+ (NSURLRequest *)requestForOLIDs:(NSArray *)olids;
+ (NSURLRequest *)requestForSearchWithFields:(NSDictionary *)fields;


+ (DBTOpenLibraryBook *)bookWithJSONDictionary:(NSDictionary *)dict;
+ (NSArray *)arrayByFlattening:(NSArray *)array usingKey:(NSString *)key;

@end

@implementation DBTOpenLibraryBook

+ (NSArray *)arrayByFlattening:(NSArray *)array usingKey:(NSString *)key
{
    NSMutableArray *output=[[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSUInteger i=0; i<array.count; ++i) {
        id value=[(NSDictionary *)[array objectAtIndex:i] objectForKey:key];
        if (value)
            [output addObject:value];
    }
    
    return [output autorelease];
}


+ (NSArray *)fetchSearchResultsWithFields:(NSDictionary *)keys
{
    id graph=[NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:[DBTOpenLibraryBook requestForSearchWithFields:keys]
                                                                           returningResponse:NULL
                                                                                       error:NULL]
                                             options:0
                                               error:NULL];
    
    if (!graph || ![graph isKindOfClass:[NSDictionary class]]) return nil;
    
    graph=[graph objectForKey:@"docs"];
    
    if (!graph || ![graph isKindOfClass:[NSArray class]]) return nil;
    
    NSMutableArray *olids=[[NSMutableArray alloc] initWithCapacity:30];
    
    for (id result in graph) {
        if (![result isKindOfClass:[NSDictionary class]]) continue;
        
        NSDictionary *item=(NSDictionary *)result;
        
        result=[item objectForKey:@"edition_key"];
        if (!result || ![result isKindOfClass:[NSArray class]]) {
            
            result=[item objectForKey:@"key"];
            
        } else {
            
            [olids addObject:[(NSArray *)result objectAtIndex:0]];
            continue;
            
        }
        
        if (result && [result isKindOfClass:[NSString class]])
            [olids addObject:result];
    }
    
    NSArray *result=[DBTOpenLibraryBook bookInfoWithJSONData:[NSURLConnection sendSynchronousRequest:[DBTOpenLibraryBook requestForOLIDs:olids]
                                                                                   returningResponse:NULL
                                                                                               error:NULL]
                                                       error:NULL];
    
    [olids release];
    
    return result;
}

+ (DBTOpenLibraryBook *)fetchBookWithISBN:(NSString *)isbn
{
    return [DBTOpenLibraryBook oneBookInfoWithJSONData:[NSURLConnection sendSynchronousRequest:[DBTOpenLibraryBook requestForISBN:isbn]
                                                                             returningResponse:NULL
                                                                                         error:NULL]
                                                 error:NULL];
}

+ (NSArray *)fetchBooksWithISBNs:(NSArray *)isbns
{
    return [DBTOpenLibraryBook bookInfoWithJSONData:[NSURLConnection sendSynchronousRequest:[DBTOpenLibraryBook requestForISBNs:isbns]
                                                                          returningResponse:NULL
                                                                                      error:NULL]
                                              error:NULL];
}

+ (DBTOpenLibraryBook *)fetchBookWithOLID:(NSString *)olid
{
    return [DBTOpenLibraryBook oneBookInfoWithJSONData:[NSURLConnection sendSynchronousRequest:[DBTOpenLibraryBook requestForOLID:olid]
                                                                             returningResponse:NULL
                                                                                         error:NULL]
                                                 error:NULL];
}

+(DBTOpenLibraryBook *)bookWithJSONDictionary:(NSDictionary *)dict
{
    // try to parse
    DBTOpenLibraryBook *info=[[DBTOpenLibraryBook alloc] init];
    
    [info setTitle:[dict objectForKey:@"title"]];
    [info setSubtitle:[dict objectForKey:@"subtitle"]];
    
    NSDictionary *identifiers=[dict objectForKey:@"identifiers"];
    if (identifiers) {
        id isbn=nil;
        isbn=[identifiers objectForKey:@"isbn_13"];
        if (!isbn)
            isbn=[identifiers objectForKey:@"isbn_10"];
        
        if ([isbn isKindOfClass:[NSArray class]])
            isbn=[isbn objectAtIndex:0];
        
        if ([isbn isKindOfClass:[NSNumber class]])
            isbn=[(NSNumber *)isbn stringValue];
        if (![isbn isKindOfClass:[NSString class]]) {
            [info release];
            NSLog(@"No isbn found!");
            return nil;
        }
        
        [info setISBN:isbn];
    }
    
    NSString *thumb=[dict objectForKey:@"thumbnail_url"];
    if (thumb) {
        // use thumbnail_url
        [info setImageURL:[NSURL URLWithString:thumb]];
    } else {
        // try with cover
        NSDictionary *covers=[dict objectForKey:@"cover"];
        
        if (covers) {
            thumb=[covers objectForKey:@"large"];
            
            if (!thumb)
                thumb=[covers objectForKey:@"medium"];
            
            if (!thumb)
                thumb=[covers objectForKey:@"small"];
            
            if (thumb)
                [info setImageURL:[NSURL URLWithString:thumb]];
        }
    }
    
    
    NSArray *array=[dict objectForKey:@"publishers"];
    if (array)
        [info setPublishers:[DBTOpenLibraryBook arrayByFlattening:array
                                                         usingKey:@"name"]];
    
    array=[dict objectForKey:@"authors"];
    if (array)
        [info setAuthors:[DBTOpenLibraryBook arrayByFlattening:array
                                                      usingKey:@"name"]];
    return [info autorelease];
}

+ (DBTOpenLibraryBook *)oneBookInfoWithJSONData:(NSData *)json error:(NSError **)error
{
    if (!json)
        return nil;
    
    id obj;
    
    obj=[NSJSONSerialization JSONObjectWithData:json
                                        options:0
                                          error:error];
    
    // really ugly error handling
    if (!obj) {
        NSLog(@"JSON deserialization failed.");
        return nil;
    }
    
    if (![obj isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Not the right object type.");
        return nil;
    }
    
    return [DBTOpenLibraryBook bookWithJSONDictionary:[(NSDictionary *)obj objectForKey:[[(NSDictionary *)obj allKeys] objectAtIndex:0]]];
}

+ (NSArray *)bookInfoWithJSONData:(NSData *)json error:(NSError **)error
{
    if (!json)
        return nil;
    
    id obj;
    
    obj=[NSJSONSerialization JSONObjectWithData:json
                                        options:0
                                          error:error];
    
    // really ugly error handling
    if (!obj) {
        NSLog(@"JSON deserialization failed.");
        return nil;
    }

    if (![obj isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Not the right object type.");
        return nil;
    }
    NSMutableArray *output=[[NSMutableArray alloc] initWithCapacity:[(NSDictionary *)obj count]];

    for (NSString *key in [(NSDictionary *)obj allKeys]){
        DBTOpenLibraryBook *book=[DBTOpenLibraryBook bookWithJSONDictionary:[(NSDictionary *)obj objectForKey:key]];
        
        if (book)
            [output addObject:book];
    }

    return [output autorelease];
}

- (void)dealloc
{
    self.title=nil;
    self.subtitle=nil;
    self.authors=nil;
    self.ISBN=nil;
    self.publishers=nil;
    self.imageURL=nil;
    
    [super dealloc];
}


+ (NSURLRequest *)requestForSearchWithFields:(NSDictionary *)fields
{
    // prepare url
    NSString *url=@"http://openlibrary.org/search.json?%@";
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:url, [fields stringWithURLEncoding]]]
                            cachePolicy:NSURLRequestReloadRevalidatingCacheData
                        timeoutInterval:1.0];
}

+ (NSURLRequest *)requestForISBN:(NSString *)isbn
{
    // prepare url
    NSString *url=@"http://openlibrary.org/api/books?bibkeys=ISBN:%@&format=json&jscmd=data";
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:url, isbn]]
                            cachePolicy:NSURLRequestReloadRevalidatingCacheData
                        timeoutInterval:1.0];
}
+ (NSURLRequest *)requestForOLID:(NSString *)olid
{
    // prepare url
    NSString *url=@"http://openlibrary.org/api/books?bibkeys=OLID:%@&format=json&jscmd=data";
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:url, olid]]
                            cachePolicy:NSURLRequestReloadRevalidatingCacheData
                        timeoutInterval:1.0];
}
+ (NSURLRequest *)requestForOLIDs:(NSArray *)olids
{
    // prepare url
    NSString *url=@"http://openlibrary.org/api/books?bibkeys=%@&format=json&jscmd=data";
    
    NSMutableArray *olidsWithHdr=[[NSMutableArray alloc] initWithCapacity:olids.count];
    for (NSString *olid in olids) {
        [olidsWithHdr addObject:[@"OLID:" stringByAppendingString:olid]];
    }
    
    NSURLRequest *output=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:url, [olidsWithHdr componentsJoinedByString:@","]]]
                                          cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                      timeoutInterval:1.0];
    
    [olidsWithHdr release];
    
    return output;
}
+ (NSURLRequest *)requestForISBNs:(NSArray *)isbns
{
    // prepare url
    NSString *url=@"http://openlibrary.org/api/books?bibkeys=%@&format=json&jscmd=data";
    
    NSMutableArray *isbnsWithHdr=[[NSMutableArray alloc] initWithCapacity:isbns.count];
    for (NSString *isbn in isbns) {
        [isbnsWithHdr addObject:[@"ISBN:" stringByAppendingString:isbn]];
    }
    
    NSURLRequest *output=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:url, [isbnsWithHdr componentsJoinedByString:@","]]]
                                          cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                      timeoutInterval:1.0];
    
    [isbnsWithHdr release];
    
    return output;
}

@end
