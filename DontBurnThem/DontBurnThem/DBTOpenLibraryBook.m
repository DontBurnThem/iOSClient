//
//  DBTOpenLibraryRequest.m
//  DontBurnThem
//
//  Created by Pietro Saccardi on 20/07/13.
//  Copyright (c) 2013 Pietro Saccardi. All rights reserved.
//

#import "DBTOpenLibraryBook.h"

@interface DBTOpenLibraryBook ()

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

+ (DBTOpenLibraryBook *)fetchBookWithISBN:(NSString *)isbn
{
    return [DBTOpenLibraryBook bookInfoWithJSONData:[NSURLConnection sendSynchronousRequest:[DBTOpenLibraryBook requestForISBN:isbn]
                                                                              returningResponse:NULL
                                                                                          error:NULL]
                                                  error:NULL];
}

+ (id)bookInfoWithJSONData:(NSData *)json error:(NSError **)error
{
    if (!json)
        return nil;
    
    NSDictionary *dict; id obj;
    
    obj=[NSJSONSerialization JSONObjectWithData:json
                                           options:0
                                             error:error];
    
    // really ugly error handling
    if (!obj) {
        NSLog(@"JSON deserialization failed.");
        return nil;
    }
    
    if (![obj isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Root is not dictionary.");
        return nil;
    }
    
    dict=(NSDictionary *)obj;
    
    if (dict.count==0) {
        NSLog(@"No result.");
        return nil;
    }
    
    // take the first object
    NSString *key=[[dict allKeys] objectAtIndex:0];
    obj=[dict objectForKey:key];
    
    if (![obj isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Wrong format of 1st item.");
        return nil;
    }
    
    dict=(NSDictionary *)obj;
    
    // try to parse
    DBTOpenLibraryBook *info=[[DBTOpenLibraryBook alloc] init];
    
    [info setTitle:[dict objectForKey:@"title"]];
    [info setSubtitle:[dict objectForKey:@"subtitle"]];
    
    // check if key has the right syntax
    if (![[[key lowercaseString] substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"isbn:"]) {
        NSLog(@"Wrong format of key.");
        
        // try with bib_key
        [info setISBN:[dict objectForKey:@"bib_key"]];
        
    } else {
        
        // set that isbn
        [info setISBN:[key substringFromIndex:5]];
        
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


+ (NSURLRequest *)requestForISBN:(NSString *)isbn
{
    // prepare url
    NSString *url=@"http://openlibrary.org/api/books?bibkeys=ISBN:%@&format=json&jscmd=data";
    return [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:url, isbn]]
                            cachePolicy:NSURLRequestReloadRevalidatingCacheData
                        timeoutInterval:1.0];
}

@end
